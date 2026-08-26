import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// 御神籤（おみくじ）ローディング表示
///
/// CircularProgressIndicator と「御神籤を引いています…」のテキストを
/// 中央揃えで表示するローディングWidget。
class DivineLoading extends StatelessWidget {
  const DivineLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: TakamagaharaColors.deepPurple,
          ),
          SizedBox(height: 16),
          Text(
            '御神籤を引いています…',
            style: TextStyle(
              fontSize: 16,
              color: TakamagaharaColors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }
}
