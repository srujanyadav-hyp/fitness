/// Represents a fully authenticated FitHub user.
///
/// Populated from Firestore `users/{uid}` after OTP verification.
class AuthUser {
  const AuthUser({
    required this.uid,
    required this.phone,
    required this.role,
    this.name,
  });

  /// Firebase Auth UID.
  final String uid;

  /// E.g. "+919876543210"
  final String phone;

  /// "customer" | "owner" | "both"
  final String role;

  /// Populated after sign-up.
  final String? name;

  AuthUser copyWith({String? uid, String? phone, String? role, String? name}) {
    return AuthUser(
      uid: uid ?? this.uid,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      name: name ?? this.name,
    );
  }
}
