import 'package:takamagahara_core/takamagahara_core.dart';
import 'vector_store.dart';

/// SupabaseVectorStore の設定
final class SupabaseVectorStoreConfig {
  /// SupabaseプロジェクトのURL
  final String url;

  /// Supabaseのサービスロールキー（またはanonキー）
  final String apiKey;

  /// ベクトルを保存するテーブル名
  final String tableName;

  /// ベクトルを保存するカラム名
  final String columnName;

  const SupabaseVectorStoreConfig({
    required this.url,
    required this.apiKey,
    required this.tableName,
    required this.columnName,
  });
}

/// Supabase をバックエンドにした [VectorStore] の具象実装。
///
/// コンストラクタで設定を受け取り、後で実際のHTTP呼び出しに使用する。
class SupabaseVectorStore implements VectorStore {
  /// 設定
  final SupabaseVectorStoreConfig config;

  const SupabaseVectorStore(this.config);

  @override
  Future<Result<List<VectorSearchResult>, VectorStoreError>> searchSimilar(
    Vector vector, {
    int limit = 10,
  }) {
    // TODO: 実際のSupabase REST API呼び出しを実装
    throw UnimplementedError('searchSimilar is not yet implemented');
  }
}
