import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takamagahara_ui/takamagahara_ui.dart';

void main() {
  group('TakamagaharaTheme', () {
    test('light theme is provided', () {
      final theme = TakamagaharaTheme.light;
      expect(theme, isA<ThemeData>());
      expect(theme.brightness, Brightness.light);
    });

    test('uses TakamagaharaColors for primary and secondary', () {
      final theme = TakamagaharaTheme.light;
      expect(theme.primaryColor, TakamagaharaColors.gold);
      expect(theme.colorScheme.secondary, TakamagaharaColors.deepPurple);
    });

    test('uses washi as scaffold background', () {
      final theme = TakamagaharaTheme.light;
      expect(theme.scaffoldBackgroundColor, TakamagaharaColors.washi);
    });

    test('elevated button has gold background', () {
      final theme = TakamagaharaTheme.light;
      final style = theme.elevatedButtonTheme.style;
      expect(style, isNotNull);
      final bgColor = style!.backgroundColor?.resolve({});
      expect(bgColor, TakamagaharaColors.gold);
    });
  });
}
