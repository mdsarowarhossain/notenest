import 'package:flutter/material.dart';

import '../../widgets/nest_empty_state.dart';

/// Requirement 9 — notes classmates have shared with you.
///
/// Phase 5 fills this in: list incoming shares with sender and permission,
/// and offer "Save to my notes" and "Dismiss" on each one.
class SharedPage extends StatelessWidget {
  const SharedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NestEmptyState(
      icon: Icons.people_rounded,
      title: 'Shared',
      message: 'Notes classmates send you land here before you save them into '
          'your own subjects.',
    );
  }
}
