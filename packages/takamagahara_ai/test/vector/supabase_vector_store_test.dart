import 'package:test/test.dart';
import 'package:takamagahara_ai/src/vector/vector_store.dart';
import 'package:takamagahara_ai/src/vector/supabase_vector_store.dart';

void main() {
  group('SupabaseVectorStore', () {
    const config = SupabaseVectorStoreConfig(
      url: 'https://test.supabase.co',
      apiKey: 'test-api-key',
      tableName: 'documents',
      columnName: 'embedding',
    );

    test('コンストラクタで設定を受け取れること', () {
      final store = SupabaseVectorStore(config);
      expect(store, isA<VectorStore>());
      expect(store.config.url, equals('https://test.supabase.co'));
      expect(store.config.apiKey, equals('test-api-key'));
      expect(store.config.tableName, equals('documents'));
      expect(store.config.columnName, equals('embedding'));
    });

    test('ConnectionError のメッセージを確認できる', () {
      const error = ConnectionError('Supabase接続エラー');
      expect(error.message, contains('接続'));
      expect(error, isA<VectorStoreError>());
    });

    test('QueryError のメッセージを確認できる', () {
      const error = QueryError('類似検索エラー');
      expect(error.message, contains('検索'));
      expect(error, isA<VectorStoreError>());
    });
  });
}
