import 'package:flutter/foundation.dart'; // Flutterの開発モードやデバッグモードの情報を取得するためのパッケージ
import 'package:flutter/material.dart'; // Flutterの基本的なUIコンポーネントを提供するパッケージ
import 'account.dart';
import 'model/box.dart';
import 'model/bugs.dart';
import 'model/crops.dart'; // crops.dart をインポート
import 'package:url_launcher/url_launcher.dart';
import 'shipment_history.dart'; // URLを開くためのパッケージ

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
        '/settings': (context) => const SettingsPage(), // 設定ページ
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
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 🔹 AppBarの背景を透明に
        elevation: 0, // 🔹 AppBarの影を消す
        title: Text(
          widget.title, // 🔹 タイトルを表示
          style: const TextStyle(color: Colors.white), // 🔹 タイトルの色を白に
        ),
        iconTheme: const IconThemeData(color: Colors.white), // 🔹 アイコンの色を白に
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // 履歴画面に遷移
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShipmentHistoryPage(
                    history: shipmentHistory,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle), // アカウントアイコン
            tooltip: 'Account', // ツールチップを設定
            onPressed: () {
              Navigator.pushNamed(context, '/account'); // アカウント画面に遷移
            },
          ),
        ],
      ),
      body: Stack(
        // スタックウィジェットを使用して複数の要素を重ねる
        children: [
          // 背景画像
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg', // アセットから背景画像を読み込む
              fit: BoxFit.cover, // 画像が画面いっぱいに広がるように調整
            ),
          ),

          // 画面中央にスイカたちを横並びで表示
          const Center(child: CropDisplay()), // crops.dartから呼びだしてるらしい

          // 虫
          BugDisplay(),
          // 箱
          BoxDisplay(onShipment: _updateShipmentHistory),
          // バナー（AppBarの下に配置）
          Positioned(
            top: kToolbarHeight + 70, // ← AppBarの高さ分下げる
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: _openUrl, // バナーがタップされたときにURLを開く
              child: Container(
                width: double.infinity, // 横幅を画面全体に広げる
                height: 100, // バナーの高さを調整
                color: Colors.blueAccent, // バナーの色
                alignment: Alignment.center, // テキストを中央に配置
                child: const Text(
                  'Visit Flutter Website', // バナーに表示するテキスト
                  style: TextStyle(
                    color: Colors.white, // テキストの色を白に
                    fontSize: 18, // フォントサイズを18に設定
                    fontWeight: FontWeight.bold, // 太字に設定
                  ),
                  textAlign: TextAlign.center, // テキストを中央揃え
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 設定画面
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Setting 1'),
              trailing: Switch(
                value: true,
                onChanged: (bool value) {
                  // 設定の変更
                },
              ),
            ),
            ListTile(
              title: const Text('Setting 2'),
              trailing: Switch(
                value: false,
                onChanged: (bool value) {
                  // 設定の変更
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
