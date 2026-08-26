import 'package:takamagahara_core/takamagahara_core.dart';

/// ベクトル型（List<double> のエイリアス）
typedef Vector = List<double>;

/// ベクトル検索結果
final class VectorSearchResult {
  /// 類似度スコア（-1.0 〜 1.0）
  final double score;

  /// ドキュメントID
  final String id;

  /// メタデータ
  final Map<String, dynamic> metadata;

  const VectorSearchResult({
    required this.score,
    required this.id,
    required this.metadata,
  });
}

/// ベクトルストアのエラー（sealed class）
sealed class VectorStoreError {
  final String message;
  const VectorStoreError(this.message);

  @override
  String toString() => '${runtimeType}: $message';
}

/// 接続エラー
final class ConnectionError extends VectorStoreError {
  const ConnectionError(super.message);
}

/// クエリエラー
final class QueryError extends VectorStoreError {
  const QueryError(super.message);
}

/// 無効なベクトルエラー
final class InvalidVectorError extends VectorStoreError {
  const InvalidVectorError(super.message);
}

/// ベクトルストアの抽象インターフェース
abstract class VectorStore {
  /// 類似ベクトル検索を実行する。
  ///
  /// [vector] に最も近いベクトルを最大 [limit] 件返す。
  Future<Result<List<VectorSearchResult>, VectorStoreError>> searchSimilar(
    Vector vector, {
    int limit = 10,
  });
}
