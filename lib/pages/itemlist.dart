import 'package:flutter/material.dart';
import 'addoneitem.dart';
import 'eachitem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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
                      String itemNum = data['itemNum'] as String? ?? '';
                      String memo = data['memo'] as String? ?? '';
                      return InkWell(
                        onTap: () {
                          // アイテムの詳細ページに移動する処理をここに記述
                          _navigateToEachItemPage(context, name, category, itemNum, memo);
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
                                Container(
                                  child: Text("画像"),
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Text(name),
                                      Text(category),
                                      Text(itemNum),
                                      Text(memo),
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

  void _navigateToEachItemPage(BuildContext context, String name, String category, String itemNum, String memo) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EachItemPage(
        name: name,
        category: category,
        itemNum: itemNum,
        memo: memo,
      ),
    ),
  );
}

}