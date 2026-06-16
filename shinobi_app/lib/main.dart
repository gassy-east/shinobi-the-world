import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'game_page.dart';

final InAppLocalhostServer localhostServer = InAppLocalhostServer(port: 8080);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // iOSのWeb Audio APIはsecure originを要求するため file:// ではなく
  // http://localhost のローカルサーバー経由でHTMLを配信する
  await localhostServer.start();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const ShinobiApp());
}

class ShinobiApp extends StatelessWidget {
  const ShinobiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '忍 SHINOBI TIMESTOP',
      debugShowCheckedModeBanner: false,
      home: GamePage(),
    );
  }
}
