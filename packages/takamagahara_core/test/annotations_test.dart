import 'package:test/test.dart';
import 'package:takamagahara_core/src/annotations.dart';

void main() {
  group('Utsushiyo', () {
    test('creates with name', () {
      const u = Utsushiyo('rpg-task');
      expect(u.name, equals('rpg-task'));
      expect(u.description, isNull);
    });

    test('creates with name and description', () {
      const u = Utsushiyo('money-quest', description: '金融リテラシーRPG');
      expect(u.name, equals('money-quest'));
      expect(u.description, equals('金融リテラシーRPG'));
    });
  });

  group('Feature', () {
    test('creates with name', () {
      const f = Feature('auth');
      expect(f.name, equals('auth'));
      expect(f.ownedBy, isNull);
    });

    test('creates with name and owner', () {
      const f = Feature('guild', ownedBy: 'Dev');
      expect(f.name, equals('guild'));
      expect(f.ownedBy, equals('Dev'));
    });
  });
}
