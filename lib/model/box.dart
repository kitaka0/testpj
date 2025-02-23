import 'package:flutter/material.dart';

class BoxDisplay extends StatefulWidget {
  const BoxDisplay({super.key});

  @override
  BoxDisplayState createState() => BoxDisplayState();
}

class BoxDisplayState extends State<BoxDisplay> {
  int counter = 0; // カウントの初期値

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('出荷しました！')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('出荷には15以上が必要です')),
      );
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
                Navigator.of(context).pop();
              },
              child: const Text('そのまま'),
            ),
            TextButton(
              onPressed: () {
                _handleShipping(context); // 出荷処理を実行
                Navigator.of(context).pop();
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
                  'assets/images/box_full.png',
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
          left: 120, // 箱の横に配置するため位置調整
          child: FloatingActionButton(
            onPressed: _incrementCounter, // ＋ボタンでカウントを増やす
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
