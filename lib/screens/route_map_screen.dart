import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../theme.dart';

// Условный импорт: на вебе подключается iframe, на десктопе — заглушка
import 'route_map_stub.dart' if (dart.library.html) 'route_map_web.dart';

class RouteMapScreen extends StatefulWidget {
  final String title;
  final String url;

  const RouteMapScreen({super.key, required this.title, required this.url});

  @override
  State<RouteMapScreen> createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> {
  late final WebViewController? _controller;
  bool _isLoading = true;

  bool get _isWindowsDesktop => !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

  @override
  void initState() {
    super.initState();
    if (_isWindowsDesktop) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              if (mounted) setState(() => _isLoading = false);
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
    } else {
      _controller = null;
    }
  }

  Future<void> _openInBrowser() async {
    try {
      final success = await launchUrl(
        Uri.parse(widget.url),
        mode: LaunchMode.externalApplication,
      );
      if (!success && mounted) _showOpenError();
    } catch (_) {
      if (mounted) _showOpenError();
    }
  }

  void _showOpenError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Не удалось открыть сайт. Проверьте интернет-соединение.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _openInBrowser,
            icon: const Icon(Icons.open_in_new_rounded),
            tooltip: 'Открыть в браузере',
          ),
        ],
      ),
      body: Column(
        children: [
          Material(
            color: GuideColors.mint,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: GuideColors.greenDark, size: 19),
                  SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      'Интерактивная схема загружается внутри приложения.',
                      style: TextStyle(fontSize: 12, color: GuideColors.ink, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: kIsWeb
                ? buildPlatformWidget(widget.url) // Рендерим iframe в браузере
                : _isWindowsDesktop
                    ? Stack(
                        children: [
                          WebViewWidget(controller: _controller!),
                          if (_isLoading)
                            const Center(child: CircularProgressIndicator()),
                        ],
                      )
                    : Center(
                        child: FilledButton.icon(
                          onPressed: _openInBrowser,
                          icon: const Icon(Icons.open_in_new_rounded),
                          label: const Text('Открыть карту'),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}