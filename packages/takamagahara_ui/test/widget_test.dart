import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takamagahara_ui/takamagahara_ui.dart';

void main() {
  group('DivineButton', () {
    testWidgets('renders with given text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DivineButton(
              onPressed: () {},
              child: const Text('神威発動'),
            ),
          ),
        ),
      );

      expect(find.text('神威発動'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DivineButton(
              onPressed: () => pressed = true,
              child: const Text('発動'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('発動'));
      expect(pressed, true);
    });

    testWidgets('does not call onPressed when disabled', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DivineButton(
              onPressed: null,
              child: const Text('発動'),
            ),
          ),
        ),
      );

      // Should be disabled
      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('disabled state shows deep purple color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DivineButton(
              onPressed: null,
              child: const Text('発動'),
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      final style = button.style;
      final bgColor = style?.backgroundColor?.resolve({});
      expect(bgColor, TakamagaharaColors.deepPurple);
    });
  });

  group('DivineLoading', () {
    testWidgets('shows circular progress indicator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: DivineLoading()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows oracle text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: DivineLoading()),
        ),
      );

      expect(find.text('御神籤を引いています…'), findsOneWidget);
    });

    testWidgets('uses deep purple for progress indicator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: DivineLoading()),
        ),
      );

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.color, TakamagaharaColors.deepPurple);
    });
  });

  group('DivineDialog', () {
    testWidgets('shows title and content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => DivineDialog(
                    title: '神託',
                    content: '汝の使命は果たされた',
                    onConfirm: () {},
                  ),
                ),
                child: const Text('開く'),
              ),
            ),
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('開く'));
      await tester.pumpAndSettle();

      expect(find.text('神託'), findsOneWidget);
      expect(find.text('汝の使命は果たされた'), findsOneWidget);
      expect(find.text('承知'), findsOneWidget);
    });

    testWidgets('calls onConfirm when confirm button tapped', (tester) async {
      var confirmed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => DivineDialog(
                    title: '神託',
                    content: '内容',
                    onConfirm: () => confirmed = true,
                  ),
                ),
                child: const Text('開く'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('開く'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('承知'));
      expect(confirmed, true);
    });

    testWidgets('uses custom confirm text when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => DivineDialog(
                    title: '神託',
                    content: '内容',
                    confirmText: '然り',
                    onConfirm: () {},
                  ),
                ),
                child: const Text('開く'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('開く'));
      await tester.pumpAndSettle();

      expect(find.text('然り'), findsOneWidget);
    });
  });
}
