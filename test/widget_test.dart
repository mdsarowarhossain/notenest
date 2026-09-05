import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:notenest/theme/nest_theme.dart';
import 'package:notenest/widgets/nest_stepper.dart';

void main() {
  testWidgets('stepper marks completed, current and upcoming steps',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: nestTheme(),
        home: const Scaffold(
          body: NestStepper(
            steps: [
              NestStep(title: 'One', icon: Icons.person_rounded),
              NestStep(title: 'Two', icon: Icons.folder_rounded),
              NestStep(title: 'Three', icon: Icons.alarm_rounded),
            ],
            currentIndex: 1,
          ),
        ),
      ),
    );

    // Step one is done, so its icon is replaced by a tick.
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);

    // The current and upcoming steps still show their own icons.
    expect(find.byIcon(Icons.folder_rounded), findsOneWidget);
    expect(find.byIcon(Icons.alarm_rounded), findsOneWidget);

    // Every step label is on screen.
    expect(find.text('One'), findsOneWidget);
    expect(find.text('Two'), findsOneWidget);
    expect(find.text('Three'), findsOneWidget);
  });
}
