import 'package:equatable/equatable.dart';

/// State produced by [AuthCubit].
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// ── Login screen states ───────────────────────────────────────────────────────

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthOtpSent extends AuthState {
  const AuthOtpSent({required this.phone});
  final String phone;

  @override
  List<Object?> get props => [phone];
}

class AuthSignUpRequired extends AuthState {
  /// The OTP has been verified but no account exists yet — show sign-up form.
  const AuthSignUpRequired({required this.phone});
  final String phone;

  @override
  List<Object?> get props => [phone];
}

class AuthSuccess extends AuthState {
  /// OTP verified + account exists → ready to route by role.
  const AuthSuccess({required this.role});

  /// "customer" | "owner" | "both"
  final String role;

  @override
  List<Object?> get props => [role];
}

class AuthFailure extends AuthState {
  const AuthFailure({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
