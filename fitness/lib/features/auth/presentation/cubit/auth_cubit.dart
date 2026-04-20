import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

/// Manages the entire authentication flow:
/// Login → OTP → (Sign-up if needed) → Role routing.
///
/// NOTE: All network calls are stubbed with [Future.delayed] for now.
/// Replace the stubs with real API calls when the backend is ready.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  String _phone = '';

  // ── Step 1: send OTP ───────────────────────────────────────────────────────

  Future<void> sendOtp(String phone) async {
    _phone = phone.trim();
    if (_phone.length < 10) {
      emit(const AuthFailure(message: 'Enter a valid 10-digit mobile number.'));
      return;
    }
    emit(const AuthLoading());
    // TODO: replace with real OTP API call
    await Future<void>.delayed(const Duration(seconds: 1));
    emit(AuthOtpSent(phone: '+91 $_phone'));
  }

  // ── Step 2: verify OTP ─────────────────────────────────────────────────────

  Future<void> verifyOtp(String otp) async {
    emit(const AuthLoading());
    // TODO: replace with real OTP verification API call
    await Future<void>.delayed(const Duration(seconds: 1));

    // Stub: "0000" simulates a brand-new user → show sign-up form.
    if (otp == '0000') {
      emit(AuthSignUpRequired(phone: _phone));
      return;
    }

    // Any other OTP → treated as existing user with role "customer".
    emit(const AuthSuccess(role: 'customer'));
  }

  // ── Step 3 (new users): create account ─────────────────────────────────────

  Future<void> createAccount({
    required String name,
    required String phone,
  }) async {
    emit(const AuthLoading());
    // TODO: replace with real sign-up API call
    await Future<void>.delayed(const Duration(seconds: 1));
    emit(const AuthSuccess(role: 'customer'));
  }

  /// Allow screens to re-show the login form.
  void reset() => emit(const AuthInitial());

  /// Expose the current phone (used to pre-fill the OTP subtitle).
  String get currentPhone => '+91 $_phone';
}
