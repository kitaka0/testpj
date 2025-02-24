import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'common/account.dart';
import 'common/background.dart';
import 'common/banner.dart';
import 'common/custom_app_bar.dart';
import 'model/box.dart';
import 'model/bugs.dart';
import 'model/crops.dart';
import 'model/water.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/account': (context) => const AccountPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  // cropのGlobalKeyを作成
  final GlobalKey<CropDisplayState> cropKey = GlobalKey<CropDisplayState>();

  int counter = 0;
  List<String> shipmentHistory = [];

  // 出荷履歴を更新するための関数
  void _updateShipmentHistory(String shipmentEntry) {
    setState(() {
      shipmentHistory.add(shipmentEntry); // 出荷履歴を更新
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: widget.title,
        shipmentHistory: shipmentHistory,
      ),
      body: Stack(
        children: [
          const Background(),
          Center(child: CropDisplay(key: cropKey)),
          BugDisplay(),
          BoxDisplay(onShipment: _updateShipmentHistory),
          WaterDisplay(cropkey: cropKey),
          CustomBanner(
            onTap: () {
              const url = 'https://flutter.dev';
              final Uri uri = Uri.parse(url);
              launchUrl(uri, mode: LaunchMode.externalApplication);
            },
          ),
        ],
      ),
    );
  }
}
