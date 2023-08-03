import 'package:flutter/material.dart';
import 'addoneitem.dart';
import 'eachitem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ItemListPage extends StatelessWidget {
  final String uid;
  const ItemListPage({Key? key, required this.uid}) : super(key: key);
  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddOneItemPage(uid: uid),
              ),
            );
        },
        backgroundColor: Color(0xffE65A71),
        child: Icon(Icons.add),
      ),
      backgroundColor: Color.fromARGB(255, 241, 243, 245),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            width: 400,
            height: 50,
            child: Row(
              children: [
                Container(
                  width: 150,
                  height: 50,
                  color: Color(0xffC5C7D3),
                  alignment: Alignment.center,
                  child: Text(
                    "グッズ一覧",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFFF7F7F7),
                    )),
                ),
                Container(
                  width: 250,
                  height: 50,
                  color: Color(0xffffffff),
                ),
              ]
            )
          ),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('itemdetails')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data?.docs[index].data() as Map<String, dynamic>?;
                      if (data == null) {
                        return Container(); // データがnullの場合は何も表示せずに終了
                      }
                      String name = data['name'] as String? ?? '';
                      String category = data['category'] as String? ?? '';
                      int itemNum = data['itemNum'] as int? ?? 0;
                      String memo = data['memo'] as String? ?? '';
                      String itemId = snapshot.data!.docs[index].id;
                      return InkWell(
                        onTap: () {
                          // アイテムの詳細ページに移動
                          _navigateToEachItemPage(context, name, category, itemNum, memo, uid, itemId);
                          },
                          child: Container(
                            height: 200,
                            margin: EdgeInsets.only(
                              left: 600,
                              right: 600,
                              top: 20,
                              bottom: 20,
                            ),
                            color: Color.fromARGB(255, 255, 255, 255),
                            child: Row(
                              children: <Widget>[
                                FutureBuilder<String?>(
                                  
                                  future: _getImageUrlFromFirestore(data['image_url']), // 'image' : Firestoreに画像URLが格納されているフィールド
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('画像の読み込みエラー');
                                    } else {
                                      String imageUrl = snapshot.data ?? '';
                                      if (imageUrl.isEmpty) {
                                        // 画像URLが空
                                        return Container(
                                          width: 150,
                                          height: 150,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(10,20,10,20),
                                            child: Container(
                                              color: Colors.grey, 
                                            ),
                                          )
                                        );
                                      } else {
                                        return Container(
                                          width: 150,
                                          height: 150,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(10,20,0,20),
                                            child : Image.network(
                                              imageUrl,
                                            ),
                                          )
                                        );
                                      }
                                    }
                                  },
                                ),
                                Container(
                                  width: 186,
                                  height: 176,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0,30,0,0),
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                            color: Color(0xFF2C2C2C),
                                            fontSize: 18,
                                          ),
                                          textAlign: TextAlign.center
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(15,60,0,0),
                                              child:Text(
                                                "在庫",
                                                style: TextStyle(
                                                  color: Color(0xFF2C2C2C),
                                                  fontSize: 22,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 100,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(15,60,0,0),
                                                child:Text(
                                                  itemNum.toString(),
                                                  style: TextStyle(
                                                    color: Color(0xFF2C2C2C),
                                                    fontSize: 24,
                                                  ),
                                                  textAlign: TextAlign.center
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                       );
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          )
        ],
      )
    );
  }

  void _navigateToEachItemPage(BuildContext context, String name, String category, int itemNum, String memo, String uid, String itemId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EachItemPage(
          name: name,
          category: category,
          itemNum: itemNum,
          memo: memo,
          uid : uid,
          itemId : itemId,
        ),
      ),
    );
  }

  Future<String?> _getImageUrlFromFirestore(String? imagePath) async {
    if (imagePath != null && imagePath.isNotEmpty) {
      Reference ref = FirebaseStorage.instance.ref().child(imagePath);
      try {
        final url = await ref.getDownloadURL();
        return url;
      } catch (e) {
        print('画像のURL取得エラー: $e');
        return null; // 画像のURLがない場合
      }
    }
  }
}