// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:notely/main.dart';
import 'package:notely/core/services/theme_provider.dart';
import 'package:notely/features/editor/screens/editor_screen.dart';
import 'package:notely/features/notes/providers/note_provider.dart';

void main() {
  testWidgets('Notely loads with splash screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final themeProvider = ThemeProvider(preferences);

    await tester.pumpWidget(
      ChangeNotifierProvider<ThemeProvider>.value(
        value: themeProvider,
        child: const NotelyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Notely'), findsOneWidget);
  });

  testWidgets('Saving a note without a title shows a dialog', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<NoteProvider>(
          create: (_) => NoteProvider(),
          child: const EditorScreen(),
        ),
      ),
    );

    await tester.ensureVisible(find.text('Save note'));
    await tester.tap(find.text('Save note'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Add a title before saving your note.'), findsOneWidget);
  });
}
