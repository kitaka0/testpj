import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // デバッグ

// 虫のクラス
class Bug {
  // 現在の位置
  double topPosition;
  double leftPosition;

  // Animation関連
  late AnimationController controller;
  late Animation<double> animation;

  Bug({
    required this.topPosition,
    required this.leftPosition,
  });
}

// ウィジェット
class BugDisplay extends StatefulWidget {
  const BugDisplay({super.key});

  @override
  BugDisplayState createState() => BugDisplayState();
}

// 状態管理
class BugDisplayState extends State<BugDisplay> with TickerProviderStateMixin {
  List<Bug> _bugs = []; // 虫のリスト
  final Random _random = Random(); // ランダム生成用
  Timer? _bugTimer; // タイマー

  // 最初の一回だけ実行されるメソッド
  @override
  void initState() {
    super.initState();
    _startPeriodicBugSpawn(); // 定期的に虫を出現させる
  }

  // dipose
  @override
  void dispose() {
    _bugTimer?.cancel(); // タイマーを破棄
    // すべての虫のアニメーションを破棄
    for (var bug in _bugs) {
      bug.controller.dispose();
    }
    super.dispose();
  }

  // タイマーの設定
  void _startPeriodicBugSpawn() {
    _bugTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      _startCountdown();
    });
  }

  // カウントダウン
  void _startCountdown() {
    // 乱数取得
    int randomSeconds = _random.nextInt(6) + 3; //3~8秒

    Future.delayed(Duration(seconds: randomSeconds), () {
      if (mounted) {
        _createBug();
      }
    });
  }

  // 虫作成
  void _createBug() {
    // 3匹以上の場合は虫を追加しない
    if (_bugs.length >= 3) {
      return;
    }

    if (kDebugMode) print('虫 ${_bugs.length + 1} 匹目を追加');

    setState(() {
      // 虫
      double initialTopPosition = 100.0;
      double initialLeftPosition = 0.0;
      switch (_bugs.length) {
        case 0:
          initialLeftPosition = 70.0;
          break;
        case 1:
          initialLeftPosition = 180.0;
          break;
        case 2:
          initialLeftPosition = 290.0;
          break;
      }
      Bug newBug = Bug(
          topPosition: initialTopPosition, leftPosition: initialLeftPosition);

      // AnimationControllerの定義
      newBug.controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 5),
      );

      // animation処理の定義
      newBug.animation = Tween<double>(
              begin: newBug.topPosition, end: newBug.topPosition + 200)
          .animate(newBug.controller)
        ..addListener(() {
          setState(() {
            newBug.topPosition = newBug.animation.value;
          });
        });

      // アニメーションを開始
      newBug.controller.forward();
      // リストに追加
      _bugs.add(newBug);
    });
  }

  // 虫削除（タップ時）
  void _bugTap(Bug bug) {
    setState(() {
      _bugs.remove(bug); // タップされた虫をリストから削除
      bug.controller.dispose(); // アニメーションを破棄
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // 複数の虫を表示
          ..._bugs.map((bug) => Positioned(
                top: bug.topPosition,
                left: bug.leftPosition,
                child: GestureDetector(
                  onTap: () => _bugTap(bug),
                  child: Image.asset(
                    'assets/images/bug.png',
                    width: 50,
                    height: 50,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
