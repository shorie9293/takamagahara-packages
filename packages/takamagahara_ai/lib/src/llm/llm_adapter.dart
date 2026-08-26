import 'package:takamagahara_core/takamagahara_core.dart';

/// LLMアダプターのエラー型
sealed class LLMError {
  final String message;
  const LLMError(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// APIキー関連のエラー
final class ApiKeyError extends LLMError {
  const ApiKeyError(super.message);
}

/// ネットワーク接続エラー
final class NetworkError extends LLMError {
  const NetworkError(super.message);
}

/// レート制限エラー
final class RateLimitError extends LLMError {
  const RateLimitError(super.message);
}

/// 無効なレスポンスエラー
final class InvalidResponseError extends LLMError {
  const InvalidResponseError(super.message);
}

/// チャットメッセージ
class ChatMessage {
  final String role;
  final String content;

  const ChatMessage({
    required this.role,
    required this.content,
  });

  @override
  String toString() => 'ChatMessage(role: $role, content: $content)';
}

/// LLMオプション
class LLMOptions {
  final double temperature;
  final int maxTokens;
  final String? model;

  const LLMOptions({
    this.temperature = 0.7,
    this.maxTokens = 2048,
    this.model,
  });

  @override
  String toString() =>
      'LLMOptions(temperature: $temperature, maxTokens: $maxTokens, model: $model)';
}

/// LLMアダプター抽象インターフェース
abstract class LLMAdapter {
  const LLMAdapter();

  /// プロンプトからテキストを生成する
  Future<Result<String, LLMError>> generate(
    String prompt, {
    LLMOptions? options,
  });

  /// チャットメッセージからテキストを生成する
  Future<Result<String, LLMError>> generateChat(
    List<ChatMessage> messages, {
    LLMOptions? options,
  });
}
