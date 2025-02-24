import 'package:flutter/foundation.dart'; // Flutterの開発モードやデバッグモードの情報を取得するためのパッケージ
import 'package:flutter/material.dart'; // Flutterの基本的なUIコンポーネントを提供するパッケージ
import 'account.dart';
import 'background.dart';
import 'banner.dart';
import 'custom_app_bar.dart';
import 'model/box.dart';
import 'model/bugs.dart';
import 'model/crops.dart'; // crops.dart をインポート
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp()); // MyAppウィジェットをアプリのエントリーポイントとして実行
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // MyAppのコンストラクタ

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo', // アプリのタイトル
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepPurple), // アプリのテーマカラー（紫）
        useMaterial3: true, // Material3スタイルを使用する
      ),
      home: const MyHomePage(
          title: 'Flutter Demo Home Page'), // アプリのホームページにMyHomePageウィジェットを設定
      routes: {
        '/account': (context) => const AccountPage(), // アカウントページ
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title}); // MyHomePageのコンストラクタ

  final String title; // タイトルの文字列

  @override
  State<MyHomePage> createState() =>
      _MyHomePageState(); // MyHomePageの状態管理クラスを作成
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  int counter = 0;

  List<String> shipmentHistory = []; // 親ウィジェットで履歴を管理

  // 出荷履歴を更新するための関数
  void _updateShipmentHistory(String shipmentEntry) {
    setState(() {
      shipmentHistory.add(shipmentEntry); // 出荷履歴を更新
    });
  }

  Future<void> _openUrl() async {
    const url = 'https://flutter.dev'; // 開くURL
    final Uri uri = Uri.parse(url); // URLをUriに変換
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // 外部ブラウザでURLを開く
      );
    } else {
      if (kDebugMode) {
        // デバッグモードの場合のみログを表示
        print('Could not launch $url');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose(); // アニメーションコントローラーを解放
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // 🔹 AppBarを背景画像の上に配置する
      appBar: CustomAppBar(
        title: widget.title, // タイトルを渡す
        shipmentHistory: shipmentHistory, // 履歴を渡す
      ),
      body: Stack(
        // スタックウィジェットを使用して複数の要素を重ねる
        children: [
          // 背景を呼び出す
          const Background(),

          // 画面中央にスイカたちを横並びで表示
          const Center(child: CropDisplay()), // crops.dartから呼びだしてるらしい
          // 虫
          BugDisplay(),
          // 箱
          BoxDisplay(onShipment: _updateShipmentHistory),
          // バナー（AppBarの下に配置）
          CustomBanner(onTap: _openUrl),
        ],
      ),
    );
  }
}
