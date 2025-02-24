import 'package:flutter/material.dart';

class ShipmentHistoryPage extends StatelessWidget {
  final List<String> history; // historyを受け取るための変数

  const ShipmentHistoryPage(
      {super.key, required this.history}); // コンストラクタでhistoryを受け取る

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('出荷履歴'),
        backgroundColor: Colors.deepPurple,
      ),
      body: history.isEmpty // 履歴が空の場合
          ? const Center(child: Text('出荷履歴はありません')) // メッセージ表示
          : ListView.builder(
              itemCount: history.length, // 履歴の数を表示
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(history[index]), // 履歴アイテムの表示
                );
              },
            ),
    );
  }
}
