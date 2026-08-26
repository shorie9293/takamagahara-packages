/// takamagahara_ai — 高天原AI基盤
///
/// ベクトル類似度計算・LLMアダプター・推薦エンジンを提供する。
/// 純粋Dartパッケージ（Flutter非依存）。
library takamagahara_ai;

export 'src/vector/cosine_similarity.dart';
export 'src/vector/vector_store.dart';
export 'src/vector/supabase_vector_store.dart';
export 'src/llm/llm_adapter.dart';
export 'src/llm/deepseek_adapter.dart';
export 'src/llm/prompt_template.dart';
export 'src/recommendation/book_recommender.dart';
