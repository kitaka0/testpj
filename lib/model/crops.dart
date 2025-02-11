import 'package:flutter/material.dart';

class Crop {
  final String imagePath; // 画像のパス
  final String name;
  final String type; // type パラメータを追加

  Crop({required this.imagePath, required this.name, required this.type});
}

// 作物リスト（画像のパスは assets フォルダ内の画像を指定）
final List<Crop> crops = [
  Crop(name: '土', type: '土壌', imagePath: 'assets/images/planter.png'),
  Crop(name: '苗', type: '植物', imagePath: 'assets/images/seedling.png'),
  Crop(name: 'スイカ', type: '果物', imagePath: 'assets/images/watermelon.png'),
];
