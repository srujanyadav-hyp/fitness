import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

/// Keys used in SharedPreferences.
abstract final class _PrefKeys {
  static const uid   = 'auth_uid';
  static const phone = 'auth_phone';
  static const name  = 'auth_name';
  static const role  = 'auth_role';
}

/// Real Firebase implementation of [AuthRepository].
///
/// Flow:
///   1. [sendOtp]     → FirebaseAuth.verifyPhoneNumber()
///   2. [verifyOtp]   → signInWithCredential → check Firestore
///   3. [createAccount] → write Firestore doc → cache in SharedPreferences
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  // Internal state — verification ID received from Firebase
  String? _verificationId;

  // In-memory cache of the current user (set after verifyOtp / createAccount)
  AuthUser? _currentUser;

  // ── Cached user from SharedPreferences ──────────────────────────────────────

  @override
  AuthUser? get cachedUser => _currentUser;

  /// Call once at app start to restore session from SharedPreferences.
  static Future<AuthUser?> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(_PrefKeys.uid);
    if (uid == null) return null;
    return AuthUser(
      uid: uid,
      phone: prefs.getString(_PrefKeys.phone) ?? '',
      role: prefs.getString(_PrefKeys.role) ?? 'customer',
      name: prefs.getString(_PrefKeys.name),
    );
  }

  // ── Step 1: Send OTP ────────────────────────────────────────────────────────

  @override
  Future<void> sendOtp(String phone) async {
    // Ensure +91 prefix
    final formattedPhone = phone.startsWith('+') ? phone : '+91$phone';
    final completer = Completer<void>();

    await _auth.verifyPhoneNumber(
      phoneNumber: formattedPhone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        // Auto-retrieval (Android only) — store verification ID.
        _verificationId = credential.verificationId;
        if (!completer.isCompleted) completer.complete();
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!completer.isCompleted) {
          completer.completeError(AuthException(_mapFirebaseError(e)));
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        if (!completer.isCompleted) completer.complete();
      },
      codeAutoRetrievalTimeout: (_) {},
    );

    return completer.future;
  }

  // ── Step 2: Verify OTP ──────────────────────────────────────────────────────

  @override
  Future<AuthUser?> verifyOtp(String otp) async {
    if (_verificationId == null) {
      throw const AuthException('Session expired. Please resend OTP.');
    }
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user!;

      // Check if the user already has a Firestore document.
      final doc = await _db
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (doc.exists) {
        // Existing user — load their profile.
        final userModel = UserModel.fromFirestore(doc);
        _currentUser = userModel;
        await _saveToPrefs(userModel);
        return userModel;
      } else {
        // New user — caller should show sign-up screen.
        // Keep FirebaseAuth signed in; Firestore doc will be written in createAccount.
        return null;
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e));
    } on FirebaseException catch (e) {
      // Typically Firestore permission or network errors
      throw AuthException('Database error: ${e.message ?? e.code}');
    }
  }

  // ── Step 3: Create account (new users) ──────────────────────────────────────

  @override
  Future<AuthUser> createAccount({
    required String name,
    required String phone,
    required String role,
    Map<String, dynamic> profileData = const {},
  }) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      throw const AuthException('Session lost. Please sign in again.');
    }

    final userModel = UserModel(
      uid: firebaseUser.uid,
      phone: phone,
      role: role,
      name: name,
      createdAt: DateTime.now(),
    );

    // Merge base fields + extended profile data in a single Firestore write.
    final firestoreData = {
      ...userModel.toFirestore(),
      ...profileData,
    };

    await _db
        .collection('users')
        .doc(firebaseUser.uid)
        .set(firestoreData);

    _currentUser = userModel;
    await _saveToPrefs(userModel);
    return userModel;
  }

  // ── Sign out ────────────────────────────────────────────────────────────────

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    _verificationId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_PrefKeys.uid);
    await prefs.remove(_PrefKeys.phone);
    await prefs.remove(_PrefKeys.name);
    await prefs.remove(_PrefKeys.role);
  }

  // ── Private helpers ─────────────────────────────────────────────────────────

  Future<void> _saveToPrefs(AuthUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_PrefKeys.uid, user.uid);
    await prefs.setString(_PrefKeys.phone, user.phone);
    await prefs.setString(_PrefKeys.role, user.role);
    if (user.name != null) {
      await prefs.setString(_PrefKeys.name, user.name!);
    }
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'Invalid phone number. Please check and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment.';
      case 'invalid-verification-code':
        return 'Wrong OTP. Please check and try again.';
      case 'session-expired':
        return 'OTP expired. Please resend.';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Try again later.';
      case 'network-request-failed':
        return 'No internet connection.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}

// ── Internal helper to bridge Firebase callbacks to Future ──────────────────
// Dart's built-in Completer bridges the Firebase callback-style API
// into the awaitable Future that our Cubit expects.
