import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomBanner extends StatelessWidget {
  final VoidCallback onTap; // タップ時の処理を受け取る

  const CustomBanner({super.key, required this.onTap});

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
    return Positioned(
      top: kToolbarHeight + 70, // AppBarの高さ分下げる
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: _openUrl, // タップされたらURLを開く
        child: Container(
          width: double.infinity, // 画面いっぱいに広げる
          height: 100, // 高さを設定
          color: Colors.blueAccent, // 背景色
          alignment: Alignment.center, // 中央に配置
          child: const Text(
            'Visit Flutter Website', // 表示テキスト
            style: TextStyle(
              color: Colors.white, // 文字色
              fontSize: 18, // フォントサイズ
              fontWeight: FontWeight.bold, // 太字
            ),
            textAlign: TextAlign.center, // 中央揃え
          ),
        ),
      ),
    );
  }
}
