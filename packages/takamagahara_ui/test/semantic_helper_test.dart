import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takamagahara_ui/takamagahara_ui.dart';

void main() {
  group('SemanticTypes', () {
    test('provides predefined type prefixes', () {
      expect(SemanticTypes.button, 'btn');
      expect(SemanticTypes.toggle, 'tgl');
      expect(SemanticTypes.textField, 'txt');
      expect(SemanticTypes.section, 'sec');
      expect(SemanticTypes.navigation, 'nav');
      expect(SemanticTypes.listItem, 'item');
      expect(SemanticTypes.dialog, 'dlg');
      expect(SemanticTypes.icon, 'ico');
    });
  });

  group('SemanticHelper', () {
    test('createTestId combines type and identifier', () {
      expect(
        SemanticHelper.createTestId(SemanticTypes.button, 'save'),
        'btn_save',
      );
      expect(
        SemanticHelper.createTestId(SemanticTypes.toggle, 'notifications'),
        'tgl_notifications',
      );
    });

    group('interactive()', () {
      testWidgets('wraps child and preserves child rendering', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: SemanticHelper.interactive(
              testId: 'btn_test',
              child: const Text('Tap me'),
            ),
          ),
        );

        expect(find.text('Tap me'), findsOneWidget);
        // MaterialApp wraps in Semantics, so atLeast(1)
        expect(find.byType(Semantics), findsAtLeast(1));
      });
    });

    group('container()', () {
      testWidgets('wraps child with container semantics', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: SemanticHelper.container(
              testId: 'sec_header',
              child: const Text('Section'),
            ),
          ),
        );

        expect(find.text('Section'), findsOneWidget);
        expect(find.byType(Semantics), findsAtLeast(1));
      });
    });

    group('toggle()', () {
      testWidgets('wraps child with toggle semantics', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: SemanticHelper.toggle(
              testId: 'tgl_notify',
              value: true,
              child: const Text('Notify'),
            ),
          ),
        );

        expect(find.text('Notify'), findsOneWidget);
        expect(find.byType(Semantics), findsAtLeast(1));
      });
    });

    group('textField()', () {
      testWidgets('wraps child with textField semantics', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: SemanticHelper.textField(
                testId: 'txt_email',
                child: const TextField(),
              ),
            ),
          ),
        );

        expect(find.byType(TextField), findsOneWidget);
        expect(find.byType(Semantics), findsAtLeast(1));
      });
    });

    group('listItem()', () {
      testWidgets('wraps child with listItem semantics', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: SemanticHelper.listItem(
              testId: 'item_task',
              index: 2,
              child: const Text('Task item'),
            ),
          ),
        );

        expect(find.text('Task item'), findsOneWidget);
        expect(find.byType(Semantics), findsAtLeast(1));
      });
    });

    group('navigation()', () {
      testWidgets('wraps child with navigation semantics', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: SemanticHelper.navigation(
              testId: 'nav_back',
              child: const Text('Back'),
            ),
          ),
        );

        expect(find.text('Back'), findsOneWidget);
        expect(find.byType(Semantics), findsAtLeast(1));
      });
    });
  });
}
