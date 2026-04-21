import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

/// Manages the entire authentication flow:
/// Login → OTP → (Sign-up if needed) → Role routing.
///
/// All network calls delegate to [AuthRepository].
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required AuthRepository repository})
      : _repo = repository,
        super(const AuthInitial());

  final AuthRepository _repo;
  String _phone = '';

  // ── Step 1: Send OTP ───────────────────────────────────────────────────────

  Future<void> sendOtp(String phone) async {
    _phone = phone.trim();
    if (_phone.length < 10) {
      emit(const AuthFailure(message: 'Enter a valid 10-digit mobile number.'));
      return;
    }
    emit(const AuthLoading());
    try {
      await _repo.sendOtp(_phone);
      emit(AuthOtpSent(phone: '+91 $_phone'));
    } on AuthException catch (e) {
      emit(AuthFailure(message: e.message));
    } catch (_) {
      emit(const AuthFailure(message: 'Could not send OTP. Please try again.'));
    }
  }

  // ── Step 2: Verify OTP ─────────────────────────────────────────────────────

  Future<void> verifyOtp(String otp) async {
    if (otp.length < 6) {
      emit(const AuthFailure(message: 'Enter the complete 6-digit OTP.'));
      return;
    }
    emit(const AuthLoading());
    try {
      final user = await _repo.verifyOtp(otp);
      if (user == null) {
        // New user — show sign-up screen.
        emit(AuthSignUpRequired(phone: _phone));
      } else {
        emit(AuthSuccess(role: user.role));
      }
    } on AuthException catch (e) {
      emit(AuthFailure(message: e.message));
    } catch (_) {
      emit(const AuthFailure(message: 'OTP verification failed. Please try again.'));
    }
  }

  // ── Step 3 (new users): Create account ─────────────────────────────────────

  Future<void> createAccount({
    required String name,
    required String phone,
    required String role,
  }) async {
    if (name.trim().isEmpty) {
      emit(const AuthFailure(message: 'Please enter your full name.'));
      return;
    }
    emit(const AuthLoading());
    try {
      final user = await _repo.createAccount(
        name: name.trim(),
        phone: phone,
        role: role,
      );
      emit(AuthSuccess(role: user.role));
    } on AuthException catch (e) {
      emit(AuthFailure(message: e.message));
    } catch (_) {
      emit(const AuthFailure(message: 'Account creation failed. Please try again.'));
    }
  }

  /// Signs out and resets to initial state.
  Future<void> signOut() async {
    await _repo.signOut();
    emit(const AuthInitial());
  }

  /// Allow screens to re-show the login form (e.g. "edit number" button).
  void reset() => emit(const AuthInitial());

  /// Expose current phone for OTP screen subtitle.
  String get currentPhone => '+91 $_phone';
}
