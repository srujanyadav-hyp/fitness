import '../entities/auth_user.dart';

/// Abstract contract for all authentication operations.
/// Implemented by [FirebaseAuthRepository] in the data layer.
abstract class AuthRepository {
  /// Sends a phone OTP via Firebase Phone Auth.
  /// Throws [AuthException] on failure.
  Future<void> sendOtp(String phone);

  /// Verifies the OTP entered by the user.
  ///
  /// Returns:
  ///   - [AuthUser] if the user already exists in Firestore.
  ///   - `null` if the phone number is new (no Firestore doc) → show sign-up.
  ///
  /// Throws [AuthException] on wrong OTP / timeout.
  Future<AuthUser?> verifyOtp(String otp);

  /// Creates a new user document in Firestore after sign-up.
  Future<AuthUser> createAccount({
    required String name,
    required String phone,
    required String role,
  });

  /// Signs out and clears local cache.
  Future<void> signOut();

  /// Returns the cached user from SharedPreferences (instant, no network).
  /// Returns `null` if not logged in.
  AuthUser? get cachedUser;
}

/// Thrown by [AuthRepository] on any auth-related error.
class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => 'AuthException: $message';
}
