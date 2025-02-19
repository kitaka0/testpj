import 'dart:async';
import 'package:flutter/material.dart';

// 作物のクラス
class Crop {
  final String name; // 作物の名前
  final String type; // 作物の種類
  final List<String> imageStages; // 各成長段階に対応する画像のリスト
  int stage; // 0: 土, 1: 苗, 2: スイカ (成長段階)
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

  // 現在の段階に応じた画像パスを返すゲッター
  String get imagePath => imageStages[stage];

  // 成長を開始するメソッド
  void startGrowing(VoidCallback refreshUI) {
    if (stage == 0) {
      // 土の段階の場合
      stage = 1; // 苗に変更
      progress = 0.0; // 進行度をリセット
      refreshUI(); // UIを更新

      timer?.cancel(); // 既存のタイマーがあればキャンセル
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (progress < 1.0) {
          progress += 0.1; // 1秒ごとに10%成長
          refreshUI(); // UIを更新
        } else {
          stage = 2; // スイカに変更
          progress = 0.0; // 進行度をリセット
          timer.cancel(); // タイマーを停止
          refreshUI(); // UIを更新
        }
      });
    }
  }

  // スイカをタップした場合にリセットするメソッド
  void reset(VoidCallback refreshUI) {
    if (stage == 2) {
      // スイカの段階の場合
      stage = 0; // 土にリセット
      progress = 0.0; // 進行度をリセット
      timer?.cancel(); // タイマーをキャンセル
      refreshUI(); // UIを更新
    }
  }
}

// 作物リスト（3つの作物を生成）
final List<Crop> crops = List.generate(
  3, // 作物の数は3つ
  (index) => Crop(
    name: '作物$index', // 作物の名前
    type: '植物', // 作物の種類
    imageStages: [
      'assets/images/planter.png', // 土の画像
      'assets/images/seedling.png', // 苗の画像
      'assets/images/watermelon.png', // スイカの画像
    ],
  ),
);

// 作物をタップした時の処理
void onCropTap(int index, VoidCallback refreshUI) {
  if (crops[index].stage == 0) {
    // 土の段階の場合、成長を開始
    crops[index].startGrowing(refreshUI);
  } else if (crops[index].stage == 2) {
    // スイカの段階の場合、リセット
    crops[index].reset(refreshUI);
  }
}

// 中央の作物を表示するウィジェット
class CropDisplay extends StatefulWidget {
  const CropDisplay({super.key});

  @override
  CropDisplayState createState() => CropDisplayState();
}

// 作物の状態管理
class CropDisplayState extends State<CropDisplay> {
  // UIを更新するメソッド
  void refreshUI() {
    setState(() {}); // 状態を変更して画面を再描画
  }

  String _getRemainingTimeText(double progress) {
    // 残り時間の計算（進行度が0.0〜1.0の範囲）
    int totalSeconds = (10 - (progress * 10)).toInt(); // 10秒が最大時間
    int minutes = totalSeconds ~/ 60; // 分
    int seconds = totalSeconds % 60; // 秒

    return 'あと$minutes分$seconds秒'; // 残り時間のテキストを返す
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // 子要素が画面全体を占めないように設定
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // 作物を中央に配置
          children: List.generate(
            crops.length, // 作物の数だけリストを生成
            (index) => GestureDetector(
              onTap: () => onCropTap(index, refreshUI), // 作物がタップされたときの処理
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0), // 左右に余白を追加
                child: Column(
                  children: [
                    Image.asset(
                      crops[index].imagePath, // 現在の成長段階に応じた画像を表示sdfdfsdf
                      height: 100, // 画像の高さを100に設定
                    ),
                    // 苗の時だけプログレスバーを表示
                    if (crops[index].stage == 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          width: 80,
                          height: 20,
                          child: Stack(
                            children: [
                              // プログレスバー
                              LinearProgressIndicator(
                                value: crops[index].progress, // 現在の進行度
                                backgroundColor: Colors.grey[300], // 背景色
                                color: Colors.yellow, // 成長の進行を示す色（黄色）
                              ),
                              // 残り時間のテキスト
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                    _getRemainingTimeText(
                                        crops[index].progress), // 残り時間のテキストを取得
                                    style: const TextStyle(
                                      color: Colors.black, // テキストの色（黒）
                                      fontSize: 12, // フォントサイズ
                                      fontWeight: FontWeight.bold, // フォントを太く
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
          ),
        ),
      ],
    );
  }
}
