import 'package:takamagahara_core/takamagahara_core.dart';
import 'package:takamagahara_ai/src/llm/llm_adapter.dart';

/// DeepSeekアダプター設定
class DeepSeekAdapterConfig {
  final String apiKey;
  final String? baseUrl;
  final String? model;

  const DeepSeekAdapterConfig({
    required this.apiKey,
    this.baseUrl,
    this.model,
  });
}

/// DeepSeek LLMアダプター具象クラス
class DeepSeekAdapter implements LLMAdapter {
  final DeepSeekAdapterConfig config;

  DeepSeekAdapter(this.config);

  @override
  Future<Result<String, LLMError>> generate(
    String prompt, {
    LLMOptions? options,
  }) async {
    if (config.apiKey.isEmpty) {
      return Result.err(ApiKeyError('API key is empty or not set'));
    }
    // TODO: 実際のAPI呼び出しを実装
    return Result.err(NetworkError('API call not yet implemented'));
  }

  @override
  Future<Result<String, LLMError>> generateChat(
    List<ChatMessage> messages, {
    LLMOptions? options,
  }) async {
    if (config.apiKey.isEmpty) {
      return Result.err(ApiKeyError('API key is empty or not set'));
    }
    // TODO: 実際のAPI呼び出しを実装
    return Result.err(NetworkError('API call not yet implemented'));
  }
}
