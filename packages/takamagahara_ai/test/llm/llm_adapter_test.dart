import 'package:test/test.dart';
import 'package:takamagahara_ai/takamagahara_ai.dart';

void main() {
  group('LLMError sealed class hierarchy', () {
    test('ApiKeyError has correct type', () {
      final error = ApiKeyError('API key is missing');
      expect(error, isA<ApiKeyError>());
      expect(error, isA<LLMError>());
      expect(error.message, equals('API key is missing'));
    });

    test('NetworkError has correct type', () {
      final error = NetworkError('Connection refused');
      expect(error, isA<NetworkError>());
      expect(error, isA<LLMError>());
      expect(error.message, equals('Connection refused'));
    });

    test('RateLimitError has correct type', () {
      final error = RateLimitError('Too many requests');
      expect(error, isA<RateLimitError>());
      expect(error, isA<LLMError>());
      expect(error.message, equals('Too many requests'));
    });

    test('InvalidResponseError has correct type', () {
      final error = InvalidResponseError('Invalid JSON');
      expect(error, isA<InvalidResponseError>());
      expect(error, isA<LLMError>());
      expect(error.message, equals('Invalid JSON'));
    });

    test('switch pattern matching works on LLMError', () {
      final errors = <LLMError>[
        ApiKeyError('a'),
        NetworkError('b'),
        RateLimitError('c'),
        InvalidResponseError('d'),
      ];

      final descriptions = errors.map((e) => switch (e) {
            ApiKeyError() => 'api_key',
            NetworkError() => 'network',
            RateLimitError() => 'rate_limit',
            InvalidResponseError() => 'invalid_response',
          });

      expect(descriptions, orderedEquals([
        'api_key',
        'network',
        'rate_limit',
        'invalid_response',
      ]));
    });
  });

  group('ChatMessage', () {
    test('creates a chat message with role and content', () {
      final message = ChatMessage(role: 'user', content: 'Hello');
      expect(message.role, equals('user'));
      expect(message.content, equals('Hello'));
    });

    test('creates a system message', () {
      final message = ChatMessage(role: 'system', content: 'You are a helper');
      expect(message.role, equals('system'));
      expect(message.content, equals('You are a helper'));
    });

    test('creates an assistant message', () {
      final message = ChatMessage(role: 'assistant', content: 'Sure!');
      expect(message.role, equals('assistant'));
      expect(message.content, equals('Sure!'));
    });
  });

  group('LLMOptions', () {
    test('uses default values when no options provided', () {
      final options = LLMOptions();
      expect(options.temperature, equals(0.7));
      expect(options.maxTokens, equals(2048));
      expect(options.model, isNull);
    });

    test('accepts custom values', () {
      final options = LLMOptions(
        temperature: 0.1,
        maxTokens: 4096,
        model: 'deepseek-chat',
      );
      expect(options.temperature, equals(0.1));
      expect(options.maxTokens, equals(4096));
      expect(options.model, equals('deepseek-chat'));
    });

    test('allows partial customization', () {
      final options = LLMOptions(temperature: 0.9);
      expect(options.temperature, equals(0.9));
      expect(options.maxTokens, equals(2048));
      expect(options.model, isNull);
    });
  });
}
