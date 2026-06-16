import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  InAppWebViewController? _controller;

  // iOS WKWebViewではAudioContextをユーザー操作で明示的にresumeする必要がある。
  // ゲームのAudioContextはSND.ctxに格納されている。
  static const String _audioUnlockJs = '''
    document.addEventListener('touchstart', function() {
      if (window.SND && window.SND.ctx && window.SND.ctx.state === 'suspended') {
        window.SND.ctx.resume();
      }
    }, { passive: true });
    document.body.addEventListener('touchmove', function(e) {
      e.preventDefault();
    }, { passive: false });
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        left: false,
        right: false,
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri('http://localhost:8080/assets/game/shinobi-mobile.html'),
          ),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            alwaysBounceVertical: false,
            alwaysBounceHorizontal: false,
            disableVerticalScroll: true,
            disableHorizontalScroll: true,
            disallowOverScroll: true,
            transparentBackground: false,
            incognito: false,
          ),
          onWebViewCreated: (controller) {
            _controller = controller;
          },
          onLoadStop: (controller, url) async {
            await controller.evaluateJavascript(source: _audioUnlockJs);
          },
          shouldOverrideUrlLoading: (controller, action) async {
            final url = action.request.url?.toString() ?? '';
            if (url.startsWith('http://localhost:8080')) {
              return NavigationActionPolicy.ALLOW;
            }
            return NavigationActionPolicy.CANCEL;
          },
        ),
      ),
    );
  }
}
