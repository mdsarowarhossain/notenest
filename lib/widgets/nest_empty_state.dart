import 'package:flutter/material.dart';

import '../theme/nest_theme.dart';
import 'nest_marks.dart';

/// Shown when a screen has nothing to display.
///
/// Every list in NoteNest needs one of these, so it lives here rather than
/// being rewritten on each screen. An empty state should always say what the
/// screen is for and, where possible, offer the action that fills it.
class NestEmptyState extends StatelessWidget {
  const NestEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 34, color: NestColor.inkFaint),
            const SizedBox(height: 16),
            Highlighted(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 22),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
