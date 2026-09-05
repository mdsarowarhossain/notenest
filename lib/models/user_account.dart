/// A NoteNest account stored on this device.
///
/// The password itself is never kept. Only a salted hash is stored, so reading
/// the database file does not reveal what the student typed.
class UserAccount {
  const UserAccount({
    this.id,
    required this.name,
    required this.email,
    this.institution,
    required this.createdAt,
  });

  final int? id;
  final String name;
  final String email;
  final String? institution;
  final DateTime createdAt;

  UserAccount copyWith({String? name, String? institution}) => UserAccount(
        id: id,
        name: name ?? this.name,
        email: email,
        institution: institution ?? this.institution,
        createdAt: createdAt,
      );

  factory UserAccount.fromMap(Map<String, Object?> m) => UserAccount(
        id: m['id'] as int?,
        name: m['name'] as String,
        email: m['email'] as String,
        institution: m['institution'] as String?,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          m['created_at'] as int? ?? 0,
        ),
      );

  /// Initials for the drawer avatar.
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'NN';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
