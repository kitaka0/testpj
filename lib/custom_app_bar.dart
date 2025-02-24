import 'package:flutter/material.dart';
import 'shipment_history.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<String> shipmentHistory;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.shipmentHistory,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // 背景を透明に
      elevation: 0, // 影を消す
      title: Text(
        title,
        style: const TextStyle(color: Colors.white), // タイトルの文字色
      ),
      iconTheme: const IconThemeData(color: Colors.white), // アイコンの色
      actions: [
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShipmentHistoryPage(
                  history: shipmentHistory,
                ),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.account_circle),
          tooltip: 'Account',
          onPressed: () {
            Navigator.pushNamed(context, '/account');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
