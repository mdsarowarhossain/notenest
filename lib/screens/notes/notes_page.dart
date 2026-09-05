import 'package:flutter/material.dart';

import '../../data/note_repository.dart';
import '../../widgets/nest_empty_state.dart';

/// Requirement 6 — every note the student owns.
///
/// Phase 1 fills this in: read notes for [subjectCode] from the repository,
/// show them with search, filter and sort, and open the editor on tap. The
/// shell already passes the drawer's selected subject in, so nothing outside
/// this file needs to change then.
class NotesPage extends StatelessWidget {
  const NotesPage({
    super.key,
    required this.subjectCode,
    required this.onCapture,
  });

  final String subjectCode;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    final repo = NoteRepository.instance;
    final subject = repo.subjectByCode(subjectCode);

    return NestEmptyState(
      icon: Icons.auto_stories_rounded,
      title: subject?.name ?? 'Notes',
      message: subject == null
          ? 'Every note you keep, grouped by subject and topic.'
          : 'Notes for ${subject.code} will appear here once you write your '
              'first one.',
      actionLabel: 'Add a note',
      onAction: onCapture,
    );
  }
}
