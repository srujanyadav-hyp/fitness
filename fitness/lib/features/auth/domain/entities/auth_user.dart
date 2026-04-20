/// Represents the authentication state held in shared preferences / memory.
class AuthUser {
  const AuthUser({
    required this.phone,
    this.name,
    this.role,
  });

  /// E.g. "+919876543210"
  final String phone;

  /// Populated after sign-up.
  final String? name;

  /// "customer" | "owner" | "both" — populated after OTP verification.
  final String? role;
}
