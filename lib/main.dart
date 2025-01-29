import 'package:flutter/foundation.dart'; // Flutterの開発モードやデバッグモードの情報を取得するためのパッケージ
import 'package:flutter/material.dart'; // Flutterの基本的なUIコンポーネントを提供するパッケージ
import 'package:url_launcher/url_launcher.dart'; // URLを開くためのパッケージ

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

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0; // カウンターの初期値

  void _incrementCounter() {
    setState(() {
      _counter++; // カウンターをインクリメント
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
            icon: const Icon(Icons.settings), // 設定アイコン
            tooltip: 'Settings', // ツールチップを設定
            onPressed: () {
              if (kDebugMode) {
                // デバッグモードでのアクション
                print('Settings button pressed');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout), // ログアウトアイコン
            tooltip: 'Logout', // ツールチップを設定
            onPressed: () {
              if (kDebugMode) {
                // デバッグモードでのアクション
                print('Logout button pressed');
              }
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

          // メインコンテンツ（カウンター）
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 中央揃え
              children: <Widget>[
                const Text('You have pushed the button this many times:'),
                Text(
                  '$_counter', // カウンターの値を表示
                  style:
                      Theme.of(context).textTheme.headlineMedium, // テーマのスタイルを使用
                ),
              ],
            ),
          ),

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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter, // ボタンが押されたときにカウンターを増やす
        tooltip: 'Increment', // ツールチップ
        child: const Icon(Icons.add), // プラスアイコン
      ),
    );
  }
}
