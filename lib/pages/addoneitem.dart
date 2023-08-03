import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:html' as html;

class AddOneItemPage extends StatefulWidget {
  const AddOneItemPage({Key? key, required this.uid}) : super(key: key);
  final String uid;


  @override
  _AddOneItemPageState createState() => _AddOneItemPageState();
}

class _AddOneItemPageState extends State<AddOneItemPage>{
  String category = '';
  int itemNum = 0;
  String memo = '';
  String name = '';
  String downloadURL = '';
  TextEditingController categoryController = TextEditingController();
  TextEditingController itemNumController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  
  html.FileUploadInputElement? _fileInput;
  String? imageUrl;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/pages/itemlist');
            },
            icon: Icon(Icons.close),
          ),
        ],
        backgroundColor: Color(0xffC5C7D3),
      ),
      backgroundColor: Color.fromARGB(255, 241, 243, 245),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 400), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'アイテム名',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent), // 枠線を透明にする
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color.fromARGB(255, 105, 124, 234)), // 枠線を透明にする
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(height: 25),
              TextFormField(
                controller: itemNumController,
                decoration: InputDecoration(
                  labelText: '在庫数',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent), // 枠線を透明にする
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color.fromARGB(255, 105, 124, 234)), // 枠線を透明にする
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(height: 25),
              TextFormField(
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: 'カテゴリ',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent), // 枠線を透明にする
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color.fromARGB(255, 105, 124, 234)), // 枠線を透明にする
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(height: 25),
              TextFormField(
                controller: memoController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'メモ',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent), // 枠線を透明にする
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color.fromARGB(255, 105, 124, 234)), // 枠線を透明にする
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(height: 25),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    _pickImage();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // 背景色を白に設定
                    onPrimary: Color(0xff2C2C2C), // 文字色を黒に設定
                  ),
                  child: Text('画像を選択'),
                ),
              ),
              SizedBox(height: 70),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 50), // ボタンとボトムの間隔を調整
                  child: ElevatedButton(
                    onPressed: _uploadAndSave,
                    style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 25), // ボタンのサイズを調整
                    primary: Color(0xFFE65A71), // 背景色を指定
                    onPrimary: Color(0xFFF7F7F7), // 文字色を指定
                    shape: RoundedRectangleBorder( // 角丸の形状を指定
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                    child: Text('登録する'),
                  ),
                ),
              ),
              _getImageWidget(),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    _fileInput = html.FileUploadInputElement()..accept = 'image/*';
    _fileInput?.click();
    setState(() {});
  }

  void _uploadAndSave() async {
    if (_fileInput != null) {
      final file = _fileInput!.files!.first;
      imageUrl = await uploadImageToFirebaseStorage(file); // 修正：画像をStorageにアップロードし、URLを変数に保持
      saveDataToFirestore();
    }
  }

  Future<String> uploadImageToFirebaseStorage(html.File file) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('item_images')
        .child('image_${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = storageRef.putBlob(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadURL = await snapshot.ref.getDownloadURL();
    print('Image uploaded: $downloadURL');
    return downloadURL;
  }

  void saveDataToFirestore() async {
    final itemData = {
      'category': categoryController.text,
      'itemNum': int.parse(itemNumController.text),
      'memo': memoController.text,
      'name': nameController.text,
      'image_url': imageUrl,
    };

    DocumentReference itemRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .collection('itemdetails')
        .add(itemData);
    
    final stockData = {
      'change': 0,
      'new_stock': int.parse(itemNumController.text),
      'reason' : '初期登録',
      'timestamp': FieldValue.serverTimestamp(),
    };
    await itemRef.collection('history').add(stockData);

    setState(() {
      // 画像を選択した後、アップロードが完了したらフォームをリセットする
      categoryController.clear();
      itemNumController.clear();
      memoController.clear();
      nameController.clear();
      _fileInput = null;
      imageUrl = null; // 追加：Firestoreへの登録後、imageUrlをリセット
    });
  }

  Widget _getImageWidget() {
    if (_fileInput != null && _fileInput!.files!.isNotEmpty) {
      // Flutter Web の場合は html.File を表示する
      final file = _fileInput!.files!.first;
      return Image.network(html.Url.createObjectUrlFromBlob(file), width: 200);
    } else {
      // モバイルアプリの場合は null を返す
      return Container();
    }
  }

}


