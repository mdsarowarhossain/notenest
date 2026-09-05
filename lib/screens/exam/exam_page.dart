import 'package:flutter/material.dart';

import '../../widgets/nest_empty_state.dart';

/// Requirement 12 — Exam Mode.
///
/// Phase 3 fills this in: create an exam entry, count down to its date, and
/// order notes by the priority rule (important, not yet mastered, on a covered
/// topic, not opened recently).
class ExamPage extends StatelessWidget {
  const ExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NestEmptyState(
      icon: Icons.timer_rounded,
      title: 'Exam',
      message: 'Set an exam date and NoteNest will order your revision by what '
          'needs it most.',
    );
  }
}
