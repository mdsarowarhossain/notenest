import 'package:flutter/material.dart';

/// The small shape of a note as it appears in a list.
///
/// This is deliberately smaller than a full note: a list never needs the body,
/// the attachments or the transcript. When the real database arrives, the full
/// `Note` entity will live beside this file and repositories will map a stored
/// note down to a [NoteSummary] before handing it to a screen.
class NoteSummary {
  const NoteSummary({
    required this.id,
    required this.title,
    required this.subjectCode,
    required this.subjectColor,
    required this.updatedLabel,
    this.important = false,
    this.status = StudyStatus.newNote,
  });

  final String id;
  final String title;
  final String subjectCode;
  final Color subjectColor;

  /// Human text such as "Yesterday". Replaced by a real timestamp later.
  final String updatedLabel;

  final bool important;
  final StudyStatus status;
}

/// Where a note sits in the revision cycle. Exam Mode orders notes by this.
enum StudyStatus { newNote, read, review, mastered }

extension StudyStatusLabel on StudyStatus {
  String get label {
    switch (this) {
      case StudyStatus.newNote:
        return 'New';
      case StudyStatus.read:
        return 'Read';
      case StudyStatus.review:
        return 'Review';
      case StudyStatus.mastered:
        return 'Mastered';
    }
  }
}
