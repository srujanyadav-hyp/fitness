import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/auth_user.dart';

/// Firestore serialization wrapper for [AuthUser].
class UserModel extends AuthUser {
  const UserModel({
    required super.uid,
    required super.phone,
    required super.role,
    super.name,
    required this.createdAt,
  });

  final DateTime createdAt;

  // ── Firestore → Model ──────────────────────────────────────────────────────

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      phone: data['phone'] as String? ?? '',
      role: data['role'] as String? ?? 'customer',
      name: data['name'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ── Model → Firestore ──────────────────────────────────────────────────────

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'phone': phone,
      'role': role,
      'name': name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
