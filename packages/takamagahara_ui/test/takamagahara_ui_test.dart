import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takamagahara_ui/takamagahara_ui.dart';

void main() {
  test('TakamagaharaColors provides correct color values', () {
    expect(TakamagaharaColors.gold, const Color(0xFFD4A038));
    expect(TakamagaharaColors.deepPurple, const Color(0xFF1A1040));
    expect(TakamagaharaColors.vermilion, const Color(0xFFE85050));
    expect(TakamagaharaColors.washi, const Color(0xFFF5F0E8));
  });
}
