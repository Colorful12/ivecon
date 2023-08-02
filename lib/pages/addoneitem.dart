import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddOneItemPage extends StatefulWidget {
  const AddOneItemPage({Key? key, required this.uid}) : super(key: key);
  final String uid;


  @override
  _AddOneItemPageState createState() => _AddOneItemPageState();
}

class _AddOneItemPageState extends State<AddOneItemPage>{
  String category = '';
  String itemNum = '';
  String memo = '';
  String name = '';
  TextEditingController categoryController = TextEditingController();
  TextEditingController itemNumController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  TextEditingController nameController = TextEditingController();

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/itemlist');
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 241, 243, 245),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'アイテム名'),
              onChanged: (value) {
                setState(() {});
              },
            ),
            TextFormField(
              controller: itemNumController,
              decoration: InputDecoration(labelText: '在庫数'),
              onChanged: (value) {
                setState(() {});
              },
            ),
            TextFormField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'カテゴリ'),
              onChanged: (value) {
                setState(() {});
              },
            ),
            TextFormField(
              controller: memoController,
              decoration: InputDecoration(labelText: 'メモ'),
              onChanged: (value) {
                setState(() {});
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Firestoreに保存する処理をここに記述
                saveDataToFirestore();
                categoryController.clear();
                itemNumController.clear();
                memoController.clear();
                nameController.clear();
              },
              child: Text('登録する'),
            ),
          ],
        ),
      ),
    );
  }

  void saveDataToFirestore() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .collection('itemdetails')
        .add({
      'category': categoryController.text,
      'itemNum': itemNumController.text,
      'memo': memoController.text,
      'name': nameController.text,
    });
  }
}