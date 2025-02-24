import 'dart:async';
import 'package:flutter/material.dart';

// 作物のクラス
class Crop {
  final String name; // 作物の名前
  final String type; // 作物の種類
  final List<String> imageStages; // 各成長段階に対応する画像のリスト
  int stage; // 0: 乾いた土, 1: 湿った土 2: 苗, 3: スイカ (成長段階)
  double progress; // 成長の進行度（0.0 〜 1.0）
  Timer? timer; // 成長を管理するタイマー

  // コンストラクタ
  Crop({
    required this.name,
    required this.type,
    required this.imageStages,
    this.stage = 0, // 初期段階は土（0）
    this.progress = 0.0, // 初期進行度は0
  });
}

// 中央の作物を表示するウィジェット
class CropDisplay extends StatefulWidget {
  const CropDisplay({super.key});

  @override
  CropDisplayState createState() => CropDisplayState();
}

// 作物の状態管理
class CropDisplayState extends State<CropDisplay> {
  // 作物を作成
  final Crop crop = Crop(
    name: 'スイカ',
    type: '植物',
    imageStages: [
      'assets/images/planter.png', // 乾いた土の画像
      'assets/images/planter.png', // 湿った土の画像
      'assets/images/seedling.png', // 苗の画像
      'assets/images/watermelon.png', // スイカの画像
    ],
  );

  String _getRemainingTimeText(double progress) {
    // 残り時間の計算（進行度が0.0〜1.0の範囲）
    int totalSeconds = (10 - (progress * 10)).toInt(); // 10秒が最大時間
    int minutes = totalSeconds ~/ 60; // 分
    int seconds = totalSeconds % 60; // 秒

    return 'あと$minutes分$seconds秒'; // 残り時間のテキストを返す
  }

  // 現在の段階に応じた画像パスを返すゲッター
  String get imagePath => crop.imageStages[crop.stage];

  // 土用の変数
  double soil_max_num = 5.0;
  double soil_num = 0.0;

  // 水がタップされた時の処理
  void onWaterTap() {
    if (crop.stage == 0) {
      // 土の段階の場合
      soil_num += 1.0;

      // 最大に達したら次の段階へ
      if (soil_num >= soil_max_num) {
        print("濡れた土");
        crop.stage = 1;
      }
    }
    setState(() {}); // UIを更新
  }

  // 作物をタップした時の処理
  void onCropTap() {
    if (crop.stage == 1) {
      startGrowing();
    } else if (crop.stage == 3) {
      // スイカの段階の場合、リセット
      reset();
    }
    setState(() {}); // UIを更新
  }

  // 成長を開始するメソッド
  void startGrowing() {
    crop.stage = 2; // 苗に変更
    crop.progress = 0.0; // 進行度をリセット
    setState(() {}); // UIを更新

    crop.timer?.cancel(); // 既存のタイマーがあればキャンセル
    crop.timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (crop.progress < 1.0) {
        crop.progress += 0.1; // 1秒ごとに10%成長
        setState(() {}); // UIを更新
      } else {
        crop.stage = 3; // スイカに変更
        crop.progress = 0.0; // 進行度をリセット
        timer.cancel(); // タイマーを停止
        setState(() {}); // UIを更新
      }
    });
  }

  // スイカをタップした場合にリセットするメソッド
  void reset() {
    if (crop.stage == 3) {
      // スイカの段階の場合
      crop.stage = 0; // 土にリセット
      crop.progress = 0.0; // 進行度をリセット
      soil_num = 0.0; // 土の成長度をリセット
      crop.timer?.cancel(); // タイマーをキャンセル
      setState(() {}); // UIを更新
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // 子要素が画面全体を占めないように設定
      children: [
        GestureDetector(
          onTap: () => onCropTap(), // 作物がタップされたときの処理
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                // 作物
                Image.asset(
                  imagePath,
                  height: 100,
                ),
                // バー表示
                // 土の時
                if (crop.stage == 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      width: 80,
                      height: 20,
                      child: Stack(
                        children: [
                          // プログレスバー
                          LinearProgressIndicator(
                            value: soil_num / soil_max_num,
                            backgroundColor: Colors.grey[300],
                            color: Colors.yellow,
                          ),
                          // バー下のテキスト
                          Positioned.fill(
                            child: Center(
                              child: Text(
                                "水押して",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // 苗の時
                if (crop.stage == 2)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      width: 80,
                      height: 20,
                      child: Stack(
                        children: [
                          // プログレスバー
                          LinearProgressIndicator(
                            value: crop.progress,
                            backgroundColor: Colors.grey[300],
                            color: Colors.yellow,
                          ),
                          // 残り時間のテキスト
                          Positioned.fill(
                            child: Center(
                              child: Text(
                                _getRemainingTimeText(crop.progress),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
