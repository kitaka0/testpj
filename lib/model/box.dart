import 'package:flutter/material.dart';

// 箱を表示するウィジェット（左下に配置）
class BoxDisplay extends StatelessWidget {
  final int counter; // 現在のカウント値
  final VoidCallback onShip; // 「出荷する」時に呼ばれるコールバック

  const BoxDisplay({super.key, required this.counter, required this.onShip});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16, // 画面下から16ピクセルの位置
      left: 16, // 画面左から16ピクセルの位置
      child: GestureDetector(
        onTap: () => _showDialog(context), // 箱をタップしたときにダイアログを表示
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/box_empty.png', // 箱の画像ファイル
              width: 100, // 幅
              height: 100, // 高さ
            ),
            Text(
              '$counter/15', // カウント表示
              style: const TextStyle(
                color: Colors.white, // テキストの色
                fontSize: 24, // フォントサイズを少し大きく
                fontWeight: FontWeight.bold, // 太字
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ダイアログを表示するメソッド
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('箱をどうしますか？'),
          content: const Text('出荷しますか、それともそのままにしますか？'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // 「そのまま」ボタンが押された場合の処理
                Navigator.of(context).pop(); // ダイアログを閉じる
              },
              child: const Text('そのまま'),
            ),
            TextButton(
              onPressed: () {
                // 「出荷する」ボタンが押された場合の処理
                onShip(); // 出荷処理のコールバックを呼び出す
                Navigator.of(context).pop(); // ダイアログを閉じる
              },
              child: const Text('出荷する'),
            ),
          ],
        );
      },
    );
  }
}
