import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        'assets/background.jpg', // アセットから背景画像を読み込む
        fit: BoxFit.cover, // 画像が画面いっぱいに広がるように調整
      ),
    );
  }
}
