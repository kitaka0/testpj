import 'package:flutter/material.dart';

class BoxDisplay extends StatefulWidget {
  final Function(String) onShipment; // 履歴を更新するための関数

  const BoxDisplay({super.key, required this.onShipment});

  @override
  BoxDisplayState createState() => BoxDisplayState();
}

class BoxDisplayState extends State<BoxDisplay> {
  int counter = 0; // カウントの初期値
  List<String> shipmentHistory = []; // 出荷履歴を管理

  // カウントを増やす処理
  void _incrementCounter() {
    setState(() {
      counter++; // 1増やす
    });
  }

  // 出荷処理（15以上で出荷、出荷後はカウントを15減らす）
  void _handleShipping(BuildContext context) {
    if (counter >= 15) {
      setState(() {
        counter -= 15; // 出荷処理として15減らす
      });

      // 出荷履歴に追加
      final shipmentEntry = '出荷しました: ${DateTime.now().toLocal()}';
      widget.onShipment(shipmentEntry); // 親ウィジェットに履歴を通知

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('出荷しました！')),
      );

      // 出荷後にダイアログを閉じる
      Navigator.of(context).pop(); // ダイアログを閉じる
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('出荷には15以上が必要です')),
      );

      // 出荷できない場合もダイアログを閉じる
      Navigator.of(context).pop(); // ダイアログを閉じる
    }
  }

// ダイアログを表示
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
                Navigator.of(context).pop(); // ダイアログを閉じる
              },
              child: const Text('そのまま'),
            ),
            TextButton(
              onPressed: () {
                _handleShipping(context); // 出荷処理を実行
              },
              child: const Text('出荷する'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          bottom: 16,
          left: 16,
          child: GestureDetector(
            onTap: () => _showDialog(context), // ダイアログを表示
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  counter >= 15
                      ? 'assets/images/box_full.png'
                      : 'assets/images/box_empty.png',
                  width: 100,
                  height: 100,
                ),
                Text(
                  '$counter/15', // カウント表示
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 120,
          child: FloatingActionButton(
            onPressed: _incrementCounter, // ＋ボタンでカウントを増やす
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
