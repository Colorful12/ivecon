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
  String itemNum = '';
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
                _pickImage();
              },
              child: Text('画像を選択'),
            ),
            ElevatedButton(
              onPressed: _uploadAndSave, 
              child: Text('登録する'),
            ),
            _getImageWidget(),
          ],
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
      'itemNum': itemNumController.text,
      'memo': memoController.text,
      'name': nameController.text,
      'image_url': imageUrl,
    };

    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .collection('itemdetails')
        .add(itemData);

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


