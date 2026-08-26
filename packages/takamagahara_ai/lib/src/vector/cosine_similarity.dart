import 'dart:math' show sqrt;

/// コサイン類似度を計算する。
///
/// 2つのベクトル [a] と [b] のコサイン類似度を -1.0 〜 1.0 の範囲で返す。
///
/// - 空リストまたは長さ不一致の場合は [ArgumentError] をスローする。
/// - いずれかのベクトルがゼロベクトルの場合は 0.0 を返す。
double cosineSimilarity(List<double> a, List<double> b) {
  if (a.isEmpty || b.isEmpty) {
    throw ArgumentError('ベクトルは空であってはなりません: a=${a.length}, b=${b.length}');
  }
  if (a.length != b.length) {
    throw ArgumentError('ベクトルの長さが一致しません: a=${a.length}, b=${b.length}');
  }

  double dotProduct = 0.0;
  double normA = 0.0;
  double normB = 0.0;

  for (int i = 0; i < a.length; i++) {
    dotProduct += a[i] * b[i];
    normA += a[i] * a[i];
    normB += b[i] * b[i];
  }

  if (normA == 0.0 || normB == 0.0) {
    return 0.0;
  }

  return dotProduct / (sqrt(normA) * sqrt(normB));
}
