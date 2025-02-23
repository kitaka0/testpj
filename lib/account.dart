import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String nickname = "ユーザー名";
  String email = "example@example.com";

  void _editField(String title, String currentValue, Function(String) onSave) {
    TextEditingController controller =
        TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$title を編集'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: '新しい $title を入力してください'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント情報'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          // 背景画像を設定
          Positioned.fill(
            child: Image.asset(
              'assets/account-BG.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // コンテンツ
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text('ニックネーム: $nickname'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _editField('ニックネーム', nickname, (newValue) {
                          setState(() {
                            nickname = newValue;
                          });
                        });
                      },
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: const Icon(Icons.email),
                    title: Text('メールアドレス: $email'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _editField('メールアドレス', email, (newValue) {
                          setState(() {
                            email = newValue;
                          });
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
