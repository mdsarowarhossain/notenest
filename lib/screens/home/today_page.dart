import 'package:flutter/material.dart';

import '../../data/note_repository.dart';
import '../../models/note_summary.dart';
import '../subjects/subject_form.dart';
import '../../theme/nest_theme.dart';
import '../../widgets/nest_marks.dart';

/// The landing screen. Requirement 3.
///
/// Only the date is real so far. The exam countdown, the revision count and the
/// recent list appear as soon as the repository has something to return; until
/// then this screen says so plainly instead of showing invented numbers.
class TodayPage extends StatelessWidget {
  const TodayPage({
    super.key,
    required this.onOpenNotes,
    required this.onCapture,
  });

  final VoidCallback onOpenNotes;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    final repo = NoteRepository.instance;
    final t = Theme.of(context).textTheme;
    final days = repo.daysToNextExam;
    final recent = repo.recentNotes(limit: 5);

    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 120),
      children: [
        Text(todayLabel(), style: nestEyebrow),
        const SizedBox(height: 8),
        Text(_headline(repo, days), style: t.displaySmall),
        const SizedBox(height: 10),
        Text(_subline(repo), style: t.bodyMedium),
        const SizedBox(height: 24),

        if (!repo.hasSubjects)
          _StartCard(
            eyebrow: 'FIRST STEP',
            title: 'Add a subject',
            body: 'Subjects give every note a colour and a place to live. '
                'You can add more later from the drawer.',
            actionLabel: 'Add a subject',
            onAction: () => showSubjectForm(context),
          )
        else if (!repo.hasNotes)
          _StartCard(
            eyebrow: 'NEXT STEP',
            title: 'Capture your first note',
            body: 'Write it, photograph a page, attach a PDF or record the '
                'lecture. Everything lands in the subject you choose.',
            actionLabel: 'Add a note',
            onAction: onCapture,
          )
        else ...[
          _RevisionCard(count: repo.unrevisedCount, onOpen: onOpenNotes),
          const SizedBox(height: 26),
          Row(
            children: [
              Text('RECENT', style: nestEyebrow),
              const SizedBox(width: 8),
              Expanded(child: Container(height: 1, color: NestColor.rule)),
            ],
          ),
          const SizedBox(height: 6),
          for (final n in recent) NoteRow(note: n),
        ],
      ],
    );
  }

  String _headline(NoteRepository repo, int? days) {
    if (days == null) return 'Nothing due yet.';
    if (days <= 0) return 'Your ${repo.nextExamSubject} exam is today.';
    return '$days ${days == 1 ? 'day' : 'days'} to your\n'
        '${repo.nextExamSubject} exam.';
  }

  String _subline(NoteRepository repo) {
    if (!repo.hasSubjects) {
      return 'Your notebook is empty. Set up a subject to begin.';
    }
    if (!repo.hasNotes) return 'No notes yet in any subject.';
    return 'Set an exam date in Exam Mode to see a countdown here.';
  }
}

/// A card that names the single next thing worth doing.
class _StartCard extends StatelessWidget {
  const _StartCard({
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
  });

  final String eyebrow;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: NestColor.card,
        borderRadius: BorderRadius.circular(NestRadius.card),
        border: Border.all(color: NestColor.rule),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4, height: 16, color: NestColor.pen),
              const SizedBox(width: 8),
              Text(eyebrow, style: nestEyebrow.copyWith(color: NestColor.pen)),
            ],
          ),
          const SizedBox(height: 14),
          Text(title, style: t.titleMedium),
          const SizedBox(height: 6),
          Text(body, style: t.bodySmall),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onAction,
              child: Text(actionLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _RevisionCard extends StatelessWidget {
  const _RevisionCard({required this.count, required this.onOpen});

  final int count;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: NestColor.card,
        borderRadius: BorderRadius.circular(NestRadius.card),
        border: Border.all(color: NestColor.rule),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4, height: 16, color: NestColor.redPen),
              const SizedBox(width: 8),
              Text(
                'NEEDS REVISION',
                style: nestEyebrow.copyWith(color: NestColor.redPen),
              ),
              const Spacer(),
              Text('$count NOTES', style: nestEyebrow),
            ],
          ),
          const SizedBox(height: 14),
          Text('Start with the ones you marked important', style: t.titleMedium),
          const SizedBox(height: 6),
          Text(
            'These are notes you starred but have not moved past Read yet.',
            style: t.bodySmall,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onOpen,
              child: const Text('Open exam mode'),
            ),
          ),
        ],
      ),
    );
  }
}

/// One note in a list. Shared by Today and, later, the Notes screen.
class NoteRow extends StatelessWidget {
  const NoteRow({super.key, required this.note, this.onTap});

  final NoteSummary note;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 5,
                  height: 34,
                  decoration: BoxDecoration(
                    color: note.subjectColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              note.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          if (note.important) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.star_rounded,
                                size: 15, color: NestColor.redPen),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${note.subjectCode} · ${note.updatedLabel}',
                        style: nestEyebrow.copyWith(
                          letterSpacing: 0.3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: NestColor.inkFaint),
              ],
            ),
          ),
        ),
        const PaperRule(indent: 19),
      ],
    );
  }
}
