import 'package:flutter/material.dart';
import 'colors.dart';

/// 高天原テーマ定義
///
/// 和モダン×ピクセルアートのトンマナに基づくライト／ダークテーマ。
///
/// ライトテーマ：和紙白(#F5F0E8)基調 × 金 × 深紫
/// ダークテーマ：墨色(#1A1A2E)基調 × 金アクセント × 薄金テキスト
class TakamagaharaTheme {
  TakamagaharaTheme._();

  /// ライトテーマ
  ///
  /// - プライマリ: 金 (gold)
  /// - セカンダリ: 深紫 (deepPurple)
  /// - 背景: 和紙白 (washi)
  /// - エラー: 朱 (vermilion)
  /// - ボタンスタイル: 金背景 + 白文字
  static ThemeData get light {
    final colorScheme = ColorScheme.light(
      primary: TakamagaharaColors.gold,
      onPrimary: Colors.white,
      secondary: TakamagaharaColors.deepPurple,
      onSecondary: TakamagaharaColors.washi,
      error: TakamagaharaColors.vermilion,
      onError: Colors.white,
      surface: TakamagaharaColors.washi,
      onSurface: TakamagaharaColors.textPrimaryLight,
      surfaceContainerHighest: TakamagaharaColors.deepPurple
          .withValues(alpha: 0.08),
      outline: TakamagaharaColors.deepPurple.withValues(alpha: 0.30),
      outlineVariant: TakamagaharaColors.deepPurple.withValues(alpha: 0.15),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: TakamagaharaColors.gold,
      scaffoldBackgroundColor: TakamagaharaColors.washi,
      colorScheme: colorScheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: TakamagaharaColors.gold,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: TakamagaharaColors.deepPurple,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: TakamagaharaColors.deepPurple,
        ),
        bodyMedium: TextStyle(
          color: TakamagaharaColors.textPrimaryLight,
        ),
        bodySmall: TextStyle(
          color: TakamagaharaColors.textSecondaryLight,
        ),
      ),
    );
  }

  /// ダークテーマ
  ///
  /// - プライマリ: 薄金 (goldLight)
  /// - セカンダリ: 金 (gold)
  /// - 背景: 墨色 (sumiDark) — 創造主様指定 #1A1A2E
  /// - 表面: 墨色+ (sumiLight) — カード/ダイアログ
  /// - エラー: 金赤 (goldCrimson) — ダークテーマ用
  /// - テキスト: 薄金系（高コントラスト）
  static ThemeData get dark {
    final colorScheme = ColorScheme.dark(
      primary: TakamagaharaColors.goldLight,
      onPrimary: TakamagaharaColors.sumiDeep,
      secondary: TakamagaharaColors.gold,
      onSecondary: TakamagaharaColors.sumiDeep,
      error: TakamagaharaColors.goldCrimson,
      onError: TakamagaharaColors.sumiDeep,
      surface: TakamagaharaColors.sumiLight,
      onSurface: TakamagaharaColors.textPrimaryDark,
      surfaceContainerHighest: TakamagaharaColors.goldLeaf
          .withValues(alpha: 0.10),
      outline: TakamagaharaColors.goldLight.withValues(alpha: 0.35),
      outlineVariant: TakamagaharaColors.goldLight.withValues(alpha: 0.18),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: TakamagaharaColors.goldLight,
      scaffoldBackgroundColor: TakamagaharaColors.sumiDark,
      colorScheme: colorScheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: TakamagaharaColors.gold,
          foregroundColor: TakamagaharaColors.sumiDeep,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: TakamagaharaColors.goldLight,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: TakamagaharaColors.goldLight,
        ),
        bodyMedium: TextStyle(
          color: TakamagaharaColors.textPrimaryDark,
        ),
        bodySmall: TextStyle(
          color: TakamagaharaColors.textSecondaryDark,
        ),
      ),
    );
  }
}
