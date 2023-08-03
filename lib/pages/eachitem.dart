import 'package:flutter/material.dart';

class EachItemPage extends StatelessWidget {
  final String name;
  final String category;
  final String itemNum;
  final String memo;

  EachItemPage({required this.name, required this.category, required this.itemNum, required this.memo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(name), // アイテム名をAppBarのタイトルに表示
        backgroundColor: Color(0xffC5C7D3),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 400), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildItemInfo('アイテム名', name),
              _buildItemInfo('カテゴリ', category),
              _buildItemInfo('在庫数', itemNum),
              _buildMemoInfo('メモ', memo),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white, 
        ),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: InputBorder.none, // 枠線を削除
          ),
          child: Text(value, style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 139, 143, 163))), // 編集不可の場合は色を灰色に設定
        ),
      ),
    );
  }

  Widget _buildMemoInfo(String label, String value) {
     return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white, 
        ),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: InputBorder.none, // 枠線を削除
          ),
          child: Text(value, style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 139, 143, 163))), // 編集不可の場合は色を灰色に設定
        ),
      ),
    );
  }
}