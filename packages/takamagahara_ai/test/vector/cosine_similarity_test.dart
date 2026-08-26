import 'package:test/test.dart';
import 'package:takamagahara_ai/src/vector/cosine_similarity.dart';

void main() {
  group('cosineSimilarity', () {
    test('同一ベクトル → 1.0', () {
      final v = [1.0, 2.0, 3.0];
      expect(cosineSimilarity(v, v), closeTo(1.0, 1e-10));
    });

    test('直交ベクトル → 0.0', () {
      final a = [1.0, 0.0];
      final b = [0.0, 1.0];
      expect(cosineSimilarity(a, b), closeTo(0.0, 1e-10));
    });

    test('逆向きベクトル → -1.0', () {
      final a = [1.0, 2.0, 3.0];
      final b = [-1.0, -2.0, -3.0];
      expect(cosineSimilarity(a, b), closeTo(-1.0, 1e-10));
    });

    test('部分一致 → 0〜1の値', () {
      final a = [3.0, 4.0];
      final b = [6.0, 8.0]; // 同じ方向（スカラー倍）
      expect(cosineSimilarity(a, b), closeTo(1.0, 1e-10));
    });

    test('空リスト → ArgumentError', () {
      expect(
        () => cosineSimilarity([], [1.0]),
        throwsArgumentError,
      );
    });

    test('長さ不一致 → ArgumentError', () {
      expect(
        () => cosineSimilarity([1.0, 2.0], [1.0]),
        throwsArgumentError,
      );
    });

    test('ゼロベクトル → 0.0', () {
      final a = [1.0, 2.0];
      final b = [0.0, 0.0];
      expect(cosineSimilarity(a, b), closeTo(0.0, 1e-10));
    });
  });
}
