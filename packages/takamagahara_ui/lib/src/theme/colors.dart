import 'package:flutter/material.dart';

/// 高天原のブランドカラー定義
///
/// 和モダン×ピクセルアートのトンマナに基づく色彩。
/// ライトテーマ：和紙白(#F5F0E8)基調 × 金(#D4A038) × 深紫(#1A1040)
/// ダークテーマ：墨色(#1A1A2E)基調 × 金アクセント × 薄金(#F0C860)テキスト
class TakamagaharaColors {
  TakamagaharaColors._();

  // ━━━ ライトテーマ ━━━

  /// 金 — 神々しい金色。アクセントカラー、CTA要素に使用
  static const Color gold = Color(0xFFD4A038);

  /// 深紫 — 神秘的な深紫。テキスト・見出しに使用
  static const Color deepPurple = Color(0xFF1A1040);

  /// 朱 — 情熱的な朱色。警告・エラー表示に使用
  static const Color vermilion = Color(0xFFE85050);

  /// 和紙白 — 温かみのある生成り。ライトテーマ背景色
  static const Color washi = Color(0xFFF5F0E8);

  // ━━━ ダークテーマ ━━━

  /// 墨色 — ダークテーマの基調色。深みのある紺黒
  /// 創造主様指定：#1A1A2E
  static const Color sumiDark = Color(0xFF1A1A2E);

  /// 墨色+（一段明るい墨）— カード・ダイアログ表面
  static const Color sumiLight = Color(0xFF252540);

  /// 墨色-（最暗色）— Scaffold 背景・AppBar 背景
  static const Color sumiDeep = Color(0xFF10101E);

  /// 和紙黒 — ダークテーマの和紙相当色（旧称、互換性維持）
  static const Color washiDark = Color(0xFF2A2520);

  /// 墨黒 — 旧ダークテーマの最暗色（互換性維持）
  static const Color inkBlack = Color(0xFF0D0D1A);

  // ━━━ 金アクセントパレット ━━━

  /// 薄金 — ダークテーマ用の明るめ金。本文テキスト・アイコンに
  static const Color goldLight = Color(0xFFF0C860);

  /// 金箔 — 淡い金色。ダークテーマの背景アクセント（金箔・光彩）
  static const Color goldLeaf = Color(0xFFE6D088);

  /// 黄金 — 濃い金色。ダークテーマのCTAボタン・強調要素
  static const Color goldDeep = Color(0xFFB8860B);

  /// 金赤 — 赤みがかった金色。ダークテーマのエラー要素
  static const Color goldCrimson = Color(0xFFC85040);

  // ━━━ ダークテーマ テキストトークン ━━━

  /// ダークテーマ本文：薄金（高コントラスト）
  static const Color textPrimaryDark = Color(0xFFF0C860);

  /// ダークテーマ補足文：薄金75%（WCAG AA 準拠。カード面 sumiLight 上で 5.5:1）
  static Color get textSecondaryDark =>
      const Color(0xFFF0C860).withValues(alpha: 0.75);

  /// ダークテーマ薄文：薄金65%（WCAG AA 準拠。最暗のダイアログ面上でも 4.5:1 超）
  static Color get textTertiaryDark =>
      const Color(0xFFF0C860).withValues(alpha: 0.65);

  // ━━━ ダークテーマ サーフェストークン ━━━

  /// ダークテーマカード表面
  static const Color surfaceCardDark = Color(0xFF252540);

  /// ダークテーマダイアログ表面
  static const Color surfaceDialogDark = Color(0xFF2A2A45);

  /// ダークテーマ入力フィールド表面
  static const Color surfaceInputDark = Color(0xFF1E1E35);

  // ━━━ ライトテーマ テキストトークン ━━━

  /// ライトテーマ本文：深紫（高コントラスト）
  static const Color textPrimaryLight = Color(0xFF1A1040);

  /// ライトテーマ補足文：深紫75%（WCAG AA 準拠。和紙面上で 7.4:1）
  static Color get textSecondaryLight =>
      const Color(0xFF1A1040).withValues(alpha: 0.75);

  /// ライトテーマ薄文：深紫65%（WCAG AA 準拠。和紙面上で 5.3:1）
  static Color get textTertiaryLight =>
      const Color(0xFF1A1040).withValues(alpha: 0.65);
}
