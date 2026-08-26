import 'package:test/test.dart';
import 'package:takamagahara_ai/takamagahara_ai.dart';

void main() {
  group('PromptTemplate', () {
    test('renders template with single variable', () {
      final template = PromptTemplate('Hello, {{name}}!');
      final result = template.render({'name': 'World'});
      expect(result, equals('Hello, World!'));
    });

    test('renders template with multiple variables', () {
      final template = PromptTemplate('{{greeting}}, {{name}}! You are {{age}} years old.');
      final result = template.render({
        'greeting': 'Hi',
        'name': 'Alice',
        'age': '30',
      });
      expect(result, equals('Hi, Alice! You are 30 years old.'));
    });

    test('renders empty template', () {
      final template = PromptTemplate('');
      final result = template.render({});
      expect(result, equals(''));
    });

    test('renders template with no variables', () {
      final template = PromptTemplate('Hello, World!');
      final result = template.render({});
      expect(result, equals('Hello, World!'));
    });

    test('throws PromptTemplateError for undefined variable', () {
      final template = PromptTemplate('Hello, {{name}}!');
      expect(
        () => template.render({}),
        throwsA(isA<PromptTemplateError>()),
      );
    });

    test('throws PromptTemplateError with variable name in message', () {
      final template = PromptTemplate('Hello, {{name}}!');
      try {
        template.render({});
        fail('Expected PromptTemplateError was not thrown');
      } on PromptTemplateError catch (e) {
        expect(e.message, contains('name'));
      }
    });

    test('throws error when some variables are missing', () {
      final template = PromptTemplate('{{a}} and {{b}}');
      expect(
        () => template.render({'a': '1'}),
        throwsA(isA<PromptTemplateError>()),
      );
    });

    test('reuses same variable multiple times', () {
      final template = PromptTemplate('{{x}} + {{x}} = {{result}}');
      final result = template.render({'x': '2', 'result': '4'});
      expect(result, equals('2 + 2 = 4'));
    });

    test('renders with numeric variable values', () {
      final template = PromptTemplate('Count: {{count}}');
      final result = template.render({'count': 42});
      expect(result, equals('Count: 42'));
    });

    test('renders template with adjacent variables', () {
      final template = PromptTemplate('{{a}}{{b}}');
      final result = template.render({'a': 'hello', 'b': 'world'});
      expect(result, equals('helloworld'));
    });
  });

  group('PromptTemplateError', () {
    test('has a message', () {
      final error = PromptTemplateError('Variable "name" is not defined');
      expect(error.message, contains('name'));
    });
  });
}
