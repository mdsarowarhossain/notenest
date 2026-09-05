import 'package:flutter/material.dart';

import '../models/note_summary.dart';
import '../widgets/nest_drawer.dart';

/// The one place every screen asks for data.
///
/// Everything here is empty on purpose. There is no database yet, so there is
/// nothing real to return, and returning invented subjects and notes would only
/// hide which parts of the application actually work.
///
/// When the local database arrives, only this file changes: the empty lists
/// become queries and the fields become writes. No screen reads data from
/// anywhere else, so no screen will need editing.
class NoteRepository {
  NoteRepository._();

  static final NoteRepository instance = NoteRepository._();

  // ------------------------------------------------------------------ user

  /// Null until the student completes setup and it is stored.
  String? userName;

  /// Null until a semester is created.
  String? semesterLabel;

  // -------------------------------------------------------------- subjects

  final List<NestSubject> _subjects = [];

  List<NestSubject> subjects() => List.unmodifiable(_subjects);

  bool get hasSubjects => _subjects.isNotEmpty;

  NestSubject? subjectByCode(String code) {
    for (final s in _subjects) {
      if (s.code == code) return s;
    }
    return null;
  }

  // ---------------------------------------------------------- drawer links

  /// These are real destinations, so they stay. No badges until there is
  /// something to count.
  List<NestDrawerLink> drawerLinks() => const [
        NestDrawerLink(
          id: 'inbox',
          label: 'Shared inbox',
          icon: Icons.move_to_inbox_rounded,
        ),
        NestDrawerLink(
          id: 'groups',
          label: 'Study groups',
          icon: Icons.groups_rounded,
        ),
        NestDrawerLink(
          id: 'requests',
          label: 'Note requests',
          icon: Icons.pending_actions_rounded,
        ),
        NestDrawerLink(
          id: 'trash',
          label: 'Trash',
          icon: Icons.delete_outline_rounded,
        ),
      ];

  // ----------------------------------------------------------------- notes

  final List<NoteSummary> _notes = [];

  bool get hasNotes => _notes.isNotEmpty;

  List<NoteSummary> recentNotes({int limit = 5}) =>
      List.unmodifiable(_notes.take(limit));

  List<NoteSummary> notesForSubject(String code) =>
      List.unmodifiable(_notes.where((n) => n.subjectCode == code));

  /// Notes not yet at [StudyStatus.mastered].
  int get unrevisedCount =>
      _notes.where((n) => n.status != StudyStatus.mastered).length;

  // ------------------------------------------------------------------ exam

  /// Null until the student creates an exam entry.
  DateTime? nextExamDate;
  String? nextExamSubject;

  int? get daysToNextExam {
    final exam = nextExamDate;
    if (exam == null) return null;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DateTime(exam.year, exam.month, exam.day).difference(today).inDays;
  }

  // ------------------------------------------------------------------ sync

  /// No cloud connection exists yet, so this stays false.
  bool get isSynced => false;
}

/// Today's date as the printed-index label used on the home screen.
String todayLabel([DateTime? date]) {
  final d = date ?? DateTime.now();
  const days = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];
  const months = [
    'JANUARY',
    'FEBRUARY',
    'MARCH',
    'APRIL',
    'MAY',
    'JUNE',
    'JULY',
    'AUGUST',
    'SEPTEMBER',
    'OCTOBER',
    'NOVEMBER',
    'DECEMBER',
  ];
  return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]}';
}
