import 'package:takamagahara_ai/src/llm/llm_adapter.dart';

/// プロンプトテンプレートエラー
class PromptTemplateError {
  final String message;
  const PromptTemplateError(this.message);

  @override
  String toString() => 'PromptTemplateError: $message';
}

/// プロンプトテンプレート
///
/// テンプレート文字列内の `{{variableName}}` 形式の変数を
/// 対応する値で置換する。
class PromptTemplate {
  final String template;
  late final RegExp _variablePattern;

  PromptTemplate(this.template) {
    _variablePattern = RegExp(r'\{\{(\w+)\}\}');
  }

  /// テンプレートをレンダリングする
  ///
  /// [variables] に含まれない変数がテンプレート内にある場合、
  /// [PromptTemplateError] を投げる。
  String render(Map<String, dynamic> variables) {
    return template.replaceAllMapped(_variablePattern, (match) {
      final variableName = match.group(1)!;
      if (!variables.containsKey(variableName)) {
        throw PromptTemplateError(
          'Variable "$variableName" is not defined in the provided variables',
        );
      }
      final value = variables[variableName];
      return value?.toString() ?? '';
    });
  }
}
