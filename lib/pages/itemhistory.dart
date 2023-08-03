import 'package:flutter/material.dart';
import 'eachitem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemHistory extends StatefulWidget {
  final String name;
  final String category;
  final String itemNum;
  final String memo;
  final String uid;

  ItemHistory({
    required this.name,
    required this.category,
    required this.itemNum,
    required this.memo,
    required this.uid,
  });

  @override
  _ItemHistoryState createState() => _ItemHistoryState();
}

class _ItemHistoryState extends State<ItemHistory> {
  final TextEditingController _stockChangeController = TextEditingController();
  int _currentStock = 0;

  @override
  void initState() {
    super.initState();
    _fetchInitialStock();
  }

  @override
  void dispose() {
    _stockChangeController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialStock() async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .collection('itemdetails')
          .doc('stock')
          .get();

      if (docSnapshot.exists) {
        // Firestoreから在庫のデータを取得して_currentStockに設定
        _currentStock = docSnapshot['stock'] ?? 0;
        setState(() {}); // データを取得した後に画面を更新する
      } else {
        // データが存在しない場合の処理
        // 初期在庫を0として設定するなど、適切な処理を行う
      }
    } catch (e) {
      print('Error fetching initial stock: $e');
    }
  }

  void _saveStockChange() {
    int stockChange = int.parse(_stockChangeController.text);
    int newStock = _currentStock + stockChange;
    print(newStock);

    // Firestoreに在庫の変動を保存する処理（省略しています）
    // 例えば、Firestoreのコレクションにデータを追加する場合は以下のようにします
    // FirebaseFirestore.instance
    //   .collection('users')
    //   .doc(widget.uid)
    //   .collection('itemdetails')
    //   .doc('history')
    //   .collection('stock_changes')
    //   .add({
    //     'change': stockChange,
    //     'new_stock': newStock,
    //     'timestamp': FieldValue.serverTimestamp(),
    //   });

    // データの保存が成功した場合、戻る
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffC5C7D3),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('在庫の差分を入力してください：'),
              SizedBox(height: 10),
              TextField(
                controller: _stockChangeController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveStockChange,
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffC5C7D3),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('変動後の数を保存'),
              ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EachItemPage(
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
              child: Text('アイテム詳細'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {},
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
}