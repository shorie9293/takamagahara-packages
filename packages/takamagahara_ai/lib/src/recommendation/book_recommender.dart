import 'package:takamagahara_core/takamagahara_core.dart';
import '../vector/vector_store.dart';
import '../llm/llm_adapter.dart';
import '../llm/prompt_template.dart';

/// 書籍推薦結果
final class BookRecommendation {
  final String id;
  final double score;
  final Map<String, dynamic> metadata;

  const BookRecommendation({
    required this.id,
    required this.score,
    required this.metadata,
  });
}

/// 推薦エンジンのエラー（sealed class）
sealed class RecommenderError {
  const RecommenderError();
}

/// ベクトルストア由来のエラー
final class RecommendVectorStoreError extends RecommenderError {
  final String message;
  const RecommendVectorStoreError(this.message);

  @override
  String toString() => 'RecommendVectorStoreError: $message';
}

/// LLM由来のエラー
final class RecommendLLMError extends RecommenderError {
  final String message;
  const RecommendLLMError(this.message);

  @override
  String toString() => 'RecommendLLMError: $message';
}

/// 無効な入力エラー
final class InvalidInputError extends RecommenderError {
  final String message;
  const InvalidInputError(this.message);

  @override
  String toString() => 'InvalidInputError: $message';
}

/// 書籍推薦エンジン
///
/// [VectorStore] と [LLMAdapter] を組み合わせて、
/// 埋め込みベクトルに基づく書籍推薦を提供する。
class BookRecommender {
  final VectorStore vectorStore;
  final LLMAdapter llmAdapter;

  const BookRecommender({
    required this.vectorStore,
    required this.llmAdapter,
  });

  /// クエリ埋め込みベクトルに基づき類似書籍を推薦する。
  ///
  /// [queryEmbedding] に最も近い書籍を最大 [limit] 件返す。
  Future<Result<List<BookRecommendation>, RecommenderError>>
      recommendByEmbedding(
    List<double> queryEmbedding, {
    int limit = 10,
  }) async {
    if (queryEmbedding.isEmpty) {
      return Result.err(
        const InvalidInputError('埋め込みベクトルが空です'),
      );
    }

    final searchResult = await vectorStore.searchSimilar(
      queryEmbedding,
      limit: limit,
    );

    return switch (searchResult) {
      Ok(value: final results) => Result.ok(
          results
              .map(
                (r) => BookRecommendation(
                  id: r.id,
                  score: r.score,
                  metadata: r.metadata,
                ),
              )
              .toList(),
        ),
      Err(error: final e) => Result.err(
          RecommendVectorStoreError(e.message),
        ),
    };
  }

  /// 類似書籍を見つけ、LLMを使って説明文を生成する。
  ///
  /// 1. [vectorStore] で類似検索
  /// 2. 結果を [PromptTemplate] でプロンプトに整形
  /// 3. [llmAdapter] で説明文を生成
  Future<Result<String, RecommenderError>> recommendWithExplanation(
    List<double> queryEmbedding,
    String userContext,
  ) async {
    if (queryEmbedding.isEmpty) {
      return Result.err(
        const InvalidInputError('埋め込みベクトルが空です'),
      );
    }

    // 1. 類似検索
    final searchResult = await vectorStore.searchSimilar(
      queryEmbedding,
      limit: 5,
    );

    if (searchResult is Err) {
      return Result.err(
        RecommendVectorStoreError((searchResult as Err).error.message),
      );
    }

    final bookList = (searchResult as Ok).value;

    // 2. プロンプト構築
    final booksText = bookList
        .map(
          (b) =>
              '- ${b.metadata['title'] ?? 'Unknown'} (スコア: ${b.score.toStringAsFixed(2)})',
        )
        .join('\n');

    final template = PromptTemplate(
      '以下の書籍がユーザーのクエリに基づいて推薦されました。\n'
      'ユーザーの状況: {{userContext}}\n'
      '推薦書籍:\n'
      '{{books}}\n'
      'これらの書籍がなぜ推薦されたか、ユーザーにとってどのように役立つかを'
      'わかりやすく説明してください。',
    );

    final prompt = template.render({
      'userContext': userContext,
      'books': booksText,
    });

    // 3. LLMで説明文生成
    final llmResult = await llmAdapter.generate(prompt);

    return switch (llmResult) {
      Ok(value: final explanation) => Result.ok(explanation),
      Err(error: final e) => Result.err(
          RecommendLLMError(e.message),
        ),
    };
  }
}
