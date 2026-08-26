import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// 画面単位の「禍津神の封印」エラー境界
///
/// 子Widgetで発生した例外をキャッチし、禍津神（まがつかみ）の封印を思わせる
/// 和モダンRPG風のエラーUIを表示する。
///
/// 開発モードではエラー詳細を表示し、本番モードでは簡略表示とする。
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(Object error, StackTrace? stack)? errorBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;
  dynamic _originalOnError;

  @override
  void initState() {
    super.initState();
    _originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      _originalOnError?.call(details);
      if (mounted) {
        setState(() {
          _error = details.exception;
          _stackTrace = details.stack;
        });
      }
    };
  }

  @override
  void dispose() {
    FlutterError.onError = _originalOnError;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(_error!, _stackTrace) ??
          _defaultErrorWidget(_error!, _stackTrace);
    }
    return widget.child;
  }

  Widget _defaultErrorWidget(Object error, StackTrace? stackTrace) {
    final isDebug = _isDebugMode();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 封印のシンボル
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: TakamagaharaColors.deepPurple,
                border: Border.all(
                  color: TakamagaharaColors.vermilion,
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 40,
                color: TakamagaharaColors.vermilion,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '禍津神の封印',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: TakamagaharaColors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '予期せぬ禍津が発生しました。\n管理者に報告してください。',
              style: TextStyle(
                fontSize: 14,
                color: TakamagaharaColors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            if (isDebug) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TakamagaharaColors.washi,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: TakamagaharaColors.vermilion.withAlpha(76),
                  ),
                ),
                child: Text(
                  '$error',
                  style: const TextStyle(
                    fontSize: 11,
                    color: TakamagaharaColors.vermilion,
                    fontFamily: 'monospace',
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _error = null;
                  _stackTrace = null;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TakamagaharaColors.gold,
                foregroundColor: Colors.white,
              ),
              child: const Text('再試行'),
            ),
          ],
        ),
      ),
    );
  }

  bool _isDebugMode() {
    bool debug = false;
    assert(() {
      debug = true;
      return true;
    }());
    return debug;
  }
}

/// ErrorWidget.builder 用のフォールバックWidget
///
/// Widgetツリー構築中の例外をキャッチし、「禍津神の封印」UIを表示する。
class ErrorBoundaryWidget extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;

  const ErrorBoundaryWidget({
    super.key,
    required this.error,
    this.stackTrace,
  });

  @override
  Widget build(BuildContext context) {
    final isDebug = _isDebugMode();
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: TakamagaharaColors.deepPurple,
                  border: Border.all(
                    color: TakamagaharaColors.vermilion,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.broken_image,
                  size: 32,
                  color: TakamagaharaColors.vermilion,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '禍津神の封印',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: TakamagaharaColors.deepPurple,
                ),
              ),
              const SizedBox(height: 8),
              if (isDebug)
                Text(
                  '$error',
                  style: const TextStyle(
                    fontSize: 12,
                    color: TakamagaharaColors.vermilion,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isDebugMode() {
    bool debug = false;
    assert(() {
      debug = true;
      return true;
    }());
    return debug;
  }
}
