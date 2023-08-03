import 'package:flutter/material.dart';
import 'itemhistory.dart';

class EachItemPage extends StatefulWidget {
  final String uid; 
  final String name;
  final String category;
  final String itemNum;
  final String memo;

  EachItemPage({
    required this.name,
    required this.category,
    required this.itemNum,
    required this.memo,
    required this.uid,
  });

  @override
  _EachItemPageState createState() => _EachItemPageState();
}

class _EachItemPageState extends State<EachItemPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffC5C7D3),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildItemInfo('アイテム名', widget.name),
              _buildItemInfo('カテゴリ', widget.category),
              _buildItemInfo('在庫数', widget.itemNum),
              _buildMemoInfo('メモ', widget.memo),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 20),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffC5C7D3),
                primary: Colors.white,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('アイテム詳細'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemHistory(
                      name: widget.name,
                      category: widget.category,
                      itemNum: widget.itemNum,
                      memo: widget.memo,
                      uid: widget.uid,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffC5C7D3),
                primary: Colors.white,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('在庫変動'),
            ),
          ],
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