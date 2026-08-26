import 'package:test/test.dart';
import 'package:takamagahara_ai/takamagahara_ai.dart';

void main() {
  group('DeepSeekAdapterConfig', () {
    test('creates config with required apiKey', () {
      final config = DeepSeekAdapterConfig(apiKey: 'sk-test-key');
      expect(config.apiKey, equals('sk-test-key'));
      expect(config.baseUrl, isNull);
      expect(config.model, isNull);
    });

    test('creates config with all fields', () {
      final config = DeepSeekAdapterConfig(
        apiKey: 'sk-test-key',
        baseUrl: 'https://custom.example.com/v1',
        model: 'deepseek-chat',
      );
      expect(config.apiKey, equals('sk-test-key'));
      expect(config.baseUrl, equals('https://custom.example.com/v1'));
      expect(config.model, equals('deepseek-chat'));
    });
  });

  group('DeepSeekAdapter', () {
    late DeepSeekAdapter adapter;

    setUp(() {
      adapter = DeepSeekAdapter(
        DeepSeekAdapterConfig(apiKey: 'sk-test-key'),
      );
    });

    test('can be instantiated with config', () {
      expect(adapter, isA<DeepSeekAdapter>());
      expect(adapter, isA<LLMAdapter>());
    });

    test('uses default model from options when model not specified in config', () async {
      final result = await adapter.generate('Hello');
      // Should be an error because no real API call is made
      expect(result.isErr, isTrue);
    });

    test('returns ApiKeyError for empty API key', () async {
      final badAdapter = DeepSeekAdapter(
        DeepSeekAdapterConfig(apiKey: ''),
      );
      final result = await badAdapter.generate('Hello');
      expect(result.isErr, isTrue);
      final error = result.unwrapErr();
      expect(error, isA<ApiKeyError>());
    });

    test('generateChat returns error on empty API key', () async {
      final badAdapter = DeepSeekAdapter(
        DeepSeekAdapterConfig(apiKey: ''),
      );
      final messages = [ChatMessage(role: 'user', content: 'Hello')];
      final result = await badAdapter.generateChat(messages);
      expect(result.isErr, isTrue);
      final error = result.unwrapErr();
      expect(error, isA<ApiKeyError>());
    });

    test('generate returns ApiKeyError for null-or-empty API key', () async {
      final badAdapter = DeepSeekAdapter(
        DeepSeekAdapterConfig(apiKey: ''),
      );
      final result = await badAdapter.generate('test');
      expect(result.isErr, isTrue);
      final error = result.unwrapErr();
      expect(error, isA<ApiKeyError>());
      expect(error.message, contains('API key'));
    });
  });
}
