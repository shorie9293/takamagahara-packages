import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// 神話風ボタン
///
/// ElevatedButton のラッパー。通常時は金（gold）グラデーション風の背景、
/// 無効時は深紫（deepPurple）で表現する和モダンなボタン。
class DivineButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double? width;
  final double? height;

  const DivineButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              onPressed != null
                  ? TakamagaharaColors.gold
                  : TakamagaharaColors.deepPurple,
          foregroundColor: Colors.white,
          disabledBackgroundColor: TakamagaharaColors.deepPurple,
          disabledForegroundColor: Colors.white38,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: child,
      ),
    );
  }
}
