import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takamagahara_ui/takamagahara_ui.dart';

/// WCAG 2.1 コントラスト比の算出（相対輝度ベース）。
/// Flutter 3.27+ の非推奨でない Color API（r/g/b/a は 0.0〜1.0）を用いる。
double _channelToLinear(double c) {
  return c <= 0.03928 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4) as double;
}

double _relativeLuminance(Color color) {
  final r = _channelToLinear(color.r);
  final g = _channelToLinear(color.g);
  final b = _channelToLinear(color.b);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

/// 前景の半透明色を背景に合成した実効色（sRGB 線形補間）
Color _composite(Color fg, Color bg) {
  final a = fg.a;
  double mix(double f, double b) => a * f + (1 - a) * b;
  return Color.from(alpha: 1, red: mix(fg.r, bg.r), green: mix(fg.g, bg.g), blue: mix(fg.b, bg.b));
}

double _contrast(Color fg, Color bg) {
  final effective = _composite(fg, bg);
  final l1 = _relativeLuminance(effective);
  final l2 = _relativeLuminance(bg);
  final lighter = math.max(l1, l2);
  final darker = math.min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  // WCAG AA: 通常サイズの本文は 4.5:1 以上
  const aa = 4.5;

  group('TakamagaharaColors — WCAG AA コントラスト準拠', () {
    test('ダークテーマ 補足文(textSecondaryDark) はカード面上で AA を満たす', () {
      final fg = TakamagaharaColors.textSecondaryDark;
      expect(
        _contrast(fg, TakamagaharaColors.sumiLight),
        greaterThanOrEqualTo(aa),
        reason: 'textSecondaryDark vs surfaceCard(sumiLight)',
      );
      expect(
        _contrast(fg, TakamagaharaColors.surfaceDialogDark),
        greaterThanOrEqualTo(aa),
        reason: 'textSecondaryDark vs surfaceDialogDark',
      );
    });

    test('ダークテーマ 薄文(textTertiaryDark) は各面上で AA を満たす', () {
      final fg = TakamagaharaColors.textTertiaryDark;
      expect(
        _contrast(fg, TakamagaharaColors.sumiDark),
        greaterThanOrEqualTo(aa),
        reason: 'textTertiaryDark vs scaffold(sumiDark)',
      );
      expect(
        _contrast(fg, TakamagaharaColors.sumiLight),
        greaterThanOrEqualTo(aa),
        reason: 'textTertiaryDark vs surfaceCard(sumiLight)',
      );
      expect(
        _contrast(fg, TakamagaharaColors.surfaceDialogDark),
        greaterThanOrEqualTo(aa),
        reason: 'textTertiaryDark vs surfaceDialogDark',
      );
    });

    test('ライトテーマ 補足文(textSecondaryLight) は和紙面上で AA を満たす', () {
      expect(
        _contrast(
          TakamagaharaColors.textSecondaryLight,
          TakamagaharaColors.washi,
        ),
        greaterThanOrEqualTo(aa),
      );
    });

    test('ライトテーマ 薄文(textTertiaryLight) は和紙面上で AA を満たす', () {
      expect(
        _contrast(
          TakamagaharaColors.textTertiaryLight,
          TakamagaharaColors.washi,
        ),
        greaterThanOrEqualTo(aa),
      );
    });

    test('視覚階層が保たれる: 本文 > 補足文 > 薄文（両テーマ）', () {
      final pD = _contrast(
        TakamagaharaColors.textPrimaryDark,
        TakamagaharaColors.sumiDark,
      );
      final sD = _contrast(
        TakamagaharaColors.textSecondaryDark,
        TakamagaharaColors.sumiDark,
      );
      final tD = _contrast(
        TakamagaharaColors.textTertiaryDark,
        TakamagaharaColors.sumiDark,
      );
      expect(pD, greaterThan(sD));
      expect(sD, greaterThan(tD));

      final pL = _contrast(
        TakamagaharaColors.textPrimaryLight,
        TakamagaharaColors.washi,
      );
      final sL = _contrast(
        TakamagaharaColors.textSecondaryLight,
        TakamagaharaColors.washi,
      );
      final tL = _contrast(
        TakamagaharaColors.textTertiaryLight,
        TakamagaharaColors.washi,
      );
      expect(pL, greaterThan(sL));
      expect(sL, greaterThan(tL));
    });

    test('コントラスト計算式の妥当性（既知値: 白黒=21:1, 同色=1:1）', () {
      expect(
        _contrast(const Color(0xFFFFFFFF), const Color(0xFF000000)),
        closeTo(21.0, 0.01),
      );
      expect(
        _contrast(const Color(0xFF808080), const Color(0xFF808080)),
        closeTo(1.0, 0.001),
      );
    });
  });
}
