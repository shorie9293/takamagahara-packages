import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../testing/app_keys.dart';

/// 神託（しんたく）ダイアログ
///
/// AlertDialog のラッパー。神話風の装飾を持つ確認ダイアログ。
/// タイトル・内容・確認ボタンを提供する。
class DivineDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final VoidCallback onConfirm;
  final Widget? icon;

  const DivineDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = '承知',
    required this.onConfirm,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: AppKeys.dialogueScreen_dialog,
      backgroundColor: TakamagaharaColors.washi,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: TakamagaharaColors.gold,
          width: 2,
        ),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: const TextStyle(
              color: TakamagaharaColors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(
        content,
        style: const TextStyle(
          color: TakamagaharaColors.deepPurple,
          fontSize: 16,
        ),
      ),
      actions: [
        ElevatedButton(
          key: AppKeys.dialogueScreen_confirmButton,
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: TakamagaharaColors.gold,
            foregroundColor: Colors.white,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
