import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:test/model/crops.dart'; // デバッグ

// 水のクラス
class Water {
  //
  int id;

  Water({
    required this.id,
  });
}

// ウィジェット
class WaterDisplay extends StatefulWidget {
  // GlobalKeyを受け取る
  final GlobalKey<CropDisplayState> cropkey;
  const WaterDisplay({super.key, required this.cropkey});

  @override
  WaterDisplayState createState() => WaterDisplayState();
}

// 状態管理
class WaterDisplayState extends State<WaterDisplay>
    with TickerProviderStateMixin {
  // 水タップ時の処理
  void _waterTap() {
    widget.cropkey.currentState?.onWaterTap();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 20,
      child: FloatingActionButton(
        onPressed: _waterTap,
        child: Icon(Icons.check),
      ),
    );
  }
}
