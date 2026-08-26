import 'package:test/test.dart';
import 'package:takamagahara_ai/src/vector/vector_store.dart';

void main() {
  group('VectorStoreError', () {
    test('ConnectionError が VectorStoreError を継承している', () {
      final error = ConnectionError('接続失敗');
      expect(error, isA<VectorStoreError>());
      expect(error.message, equals('接続失敗'));
    });

    test('QueryError が VectorStoreError を継承している', () {
      final error = QueryError('クエリ失敗');
      expect(error, isA<VectorStoreError>());
      expect(error.message, equals('クエリ失敗'));
    });

    test('InvalidVectorError が VectorStoreError を継承している', () {
      final error = InvalidVectorError('無効なベクトル');
      expect(error, isA<VectorStoreError>());
      expect(error.message, equals('無効なベクトル'));
    });
  });

  group('VectorSearchResult', () {
    test('score, id, metadata を保持できる', () {
      final result = VectorSearchResult(
        score: 0.95,
        id: 'doc-1',
        metadata: {'title': 'test'},
      );
      expect(result.score, closeTo(0.95, 1e-10));
      expect(result.id, equals('doc-1'));
      expect(result.metadata, equals({'title': 'test'}));
    });

    test('metadata が空マップでも生成できる', () {
      final result = VectorSearchResult(
        score: 0.5,
        id: 'doc-2',
        metadata: {},
      );
      expect(result.score, closeTo(0.5, 1e-10));
      expect(result.id, equals('doc-2'));
      expect(result.metadata, isEmpty);
    });
  });
}
