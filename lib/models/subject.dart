import 'package:flutter/material.dart';

import '../theme/nest_theme.dart';

/// A subject the student is taking this semester.
///
/// The colour is stored as an index into [NestColor.tabs] rather than as a raw
/// colour value. The palette is fixed by the design, so an index is smaller,
/// survives a theme change, and keeps the database free of presentation data.
class Subject {
  const Subject({
    this.id,
    required this.userId,
    required this.name,
    required this.code,
    required this.colorIndex,
    this.archived = false,
    required this.createdAt,
    this.noteCount = 0,
    this.mastery = 0,
  });

  final int? id;
  final int userId;
  final String name;
  final String code;
  final int colorIndex;
  final bool archived;
  final DateTime createdAt;

  /// Filled in by the repository once notes exist. Not stored.
  final int noteCount;

  /// Share of notes at Mastered, 0..1. Not stored.
  final double mastery;

  Color get color => NestColor.tabs[colorIndex % NestColor.tabs.length];

  Subject copyWith({
    int? id,
    String? name,
    String? code,
    int? colorIndex,
    bool? archived,
    int? noteCount,
    double? mastery,
  }) =>
      Subject(
        id: id ?? this.id,
        userId: userId,
        name: name ?? this.name,
        code: code ?? this.code,
        colorIndex: colorIndex ?? this.colorIndex,
        archived: archived ?? this.archived,
        createdAt: createdAt,
        noteCount: noteCount ?? this.noteCount,
        mastery: mastery ?? this.mastery,
      );

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'user_id': userId,
        'name': name,
        'code': code,
        'color_index': colorIndex,
        'archived': archived ? 1 : 0,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  factory Subject.fromMap(Map<String, Object?> m) => Subject(
        id: m['id'] as int?,
        userId: m['user_id'] as int,
        name: m['name'] as String,
        code: m['code'] as String,
        colorIndex: m['color_index'] as int,
        archived: (m['archived'] as int? ?? 0) == 1,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          m['created_at'] as int? ?? 0,
        ),
      );
}
