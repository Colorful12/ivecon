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
        title: Text(name), // アイテム名をAppBarのタイトルに表示
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('カテゴリ: $category'),
            Text('在庫数: $itemNum'),
            Text('メモ: $memo'),
          ],
        ),
      ),
    );
  }
}