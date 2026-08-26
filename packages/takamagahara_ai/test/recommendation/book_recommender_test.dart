import 'package:test/test.dart';
import 'package:takamagahara_core/takamagahara_core.dart';
import 'package:takamagahara_ai/takamagahara_ai.dart';

// =====================================================================
// モック実装（手動モック）
// =====================================================================

class MockVectorStore implements VectorStore {
  final List<VectorSearchResult>? results;
  final VectorStoreError? error;

  MockVectorStore({this.results, this.error});

  @override
  Future<Result<List<VectorSearchResult>, VectorStoreError>> searchSimilar(
    Vector vector, {
    int limit = 10,
  }) async {
    if (error != null) {
      return Result.err(error!);
    }
    return Result.ok(results ?? []);
  }
}

class MockLLMAdapter implements LLMAdapter {
  final String? responseText;
  final LLMError? error;

  MockLLMAdapter({this.responseText, this.error});

  @override
  Future<Result<String, LLMError>> generate(
    String prompt, {
    LLMOptions? options,
  }) async {
    if (error != null) {
      return Result.err(error!);
    }
    return Result.ok(responseText ?? '');
  }

  @override
  Future<Result<String, LLMError>> generateChat(
    List<ChatMessage> messages, {
    LLMOptions? options,
  }) async {
    if (error != null) {
      return Result.err(error!);
    }
    return Result.ok(responseText ?? '');
  }
}

// =====================================================================
// テスト
// =====================================================================

void main() {
  group('BookRecommender', () {
    late MockVectorStore mockVectorStore;
    late MockLLMAdapter mockLLMAdapter;
    late BookRecommender recommender;

    setUp(() {
      mockVectorStore = MockVectorStore();
      mockLLMAdapter = MockLLMAdapter();
      recommender = BookRecommender(
        vectorStore: mockVectorStore,
        llmAdapter: mockLLMAdapter,
      );
    });

    group('recommendByEmbedding', () {
      test('正常系：モックから類似書籍のリストが返る', () async {
        // Arrange
        final expectedResults = [
          VectorSearchResult(
              id: 'book1', score: 0.95, metadata: {'title': 'Dart入門'}),
          VectorSearchResult(
              id: 'book2', score: 0.87, metadata: {'title': 'Flutter実践'}),
          VectorSearchResult(
              id: 'book3',
              score: 0.72,
              metadata: {'title': 'プログラミング基礎'}),
        ];
        mockVectorStore = MockVectorStore(results: expectedResults);
        recommender = BookRecommender(
          vectorStore: mockVectorStore,
          llmAdapter: mockLLMAdapter,
        );

        // Act
        final result = await recommender.recommendByEmbedding(
          [0.1, 0.2, 0.3],
          limit: 5,
        );

        // Assert
        expect(result.isOk, true);
        final recommendations = result.unwrap();
        expect(recommendations.length, 3);
        expect(recommendations[0].id, 'book1');
        expect(recommendations[0].score, 0.95);
        expect(recommendations[0].metadata['title'], 'Dart入門');
        expect(recommendations[1].id, 'book2');
        expect(recommendations[2].id, 'book3');
      });

      test('VectorStoreがエラーを返した場合、RecommenderErrorが返る', () async {
        // Arrange
        mockVectorStore = MockVectorStore(
          error: const ConnectionError('DB接続エラー'),
        );
        recommender = BookRecommender(
          vectorStore: mockVectorStore,
          llmAdapter: mockLLMAdapter,
        );

        // Act
        final result = await recommender.recommendByEmbedding(
          [0.1, 0.2, 0.3],
          limit: 5,
        );

        // Assert
        expect(result.isErr, true);
        expect(result.unwrapErr(), isA<RecommendVectorStoreError>());
      });

      test('空の埋め込みベクトルでエラー（InvalidInputError）', () async {
        // Act
        final result = await recommender.recommendByEmbedding(
          [],
          limit: 5,
        );

        // Assert
        expect(result.isErr, true);
        expect(result.unwrapErr(), isA<InvalidInputError>());
      });
    });

    group('recommendWithExplanation', () {
      test('正常系：類似検索結果からLLMが説明文を生成する', () async {
        // Arrange
        final searchResults = [
          VectorSearchResult(
              id: 'book1',
              score: 0.95,
              metadata: {'title': 'Dart入門', 'author': '山田'}),
          VectorSearchResult(
              id: 'book2',
              score: 0.87,
              metadata: {'title': 'Flutter実践', 'author': '鈴木'}),
        ];
        mockVectorStore = MockVectorStore(results: searchResults);
        mockLLMAdapter = MockLLMAdapter(
          responseText: 'これらの本はDartとFlutterの学習に最適です。',
        );
        recommender = BookRecommender(
          vectorStore: mockVectorStore,
          llmAdapter: mockLLMAdapter,
        );

        // Act
        final result = await recommender.recommendWithExplanation(
          [0.1, 0.2, 0.3],
          '初心者がDartを学びたい',
        );

        // Assert
        expect(result.isOk, true);
        final explanation = result.unwrap();
        expect(explanation, contains('Dart'));
        expect(explanation, contains('Flutter'));
      });

      test('LLMがエラーを返した場合、RecommenderErrorが返る', () async {
        // Arrange
        mockVectorStore = MockVectorStore(results: [
          VectorSearchResult(
              id: 'book1', score: 0.95, metadata: {'title': 'Dart入門'}),
        ]);
        mockLLMAdapter = MockLLMAdapter(
          error: const ApiKeyError('APIキーが無効です'),
        );
        recommender = BookRecommender(
          vectorStore: mockVectorStore,
          llmAdapter: mockLLMAdapter,
        );

        // Act
        final result = await recommender.recommendWithExplanation(
          [0.1, 0.2, 0.3],
          '初心者向け',
        );

        // Assert
        expect(result.isErr, true);
        expect(result.unwrapErr(), isA<RecommendLLMError>());
      });

      test('VectorStoreがエラーの場合もRecommenderErrorが返る', () async {
        // Arrange
        mockVectorStore = MockVectorStore(
          error: const QueryError('検索クエリエラー'),
        );
        recommender = BookRecommender(
          vectorStore: mockVectorStore,
          llmAdapter: mockLLMAdapter,
        );

        // Act
        final result = await recommender.recommendWithExplanation(
          [0.1, 0.2, 0.3],
          '初心者向け',
        );

        // Assert
        expect(result.isErr, true);
        expect(result.unwrapErr(), isA<RecommendVectorStoreError>());
      });

      test('空の埋め込みベクトルでエラー（InvalidInputError）', () async {
        // Act
        final result = await recommender.recommendWithExplanation(
          [],
          '初心者向け',
        );

        // Assert
        expect(result.isErr, true);
        expect(result.unwrapErr(), isA<InvalidInputError>());
      });
    });
  });
}
