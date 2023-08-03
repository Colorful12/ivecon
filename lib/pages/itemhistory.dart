import 'package:flutter/material.dart';
import 'eachitem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemHistory extends StatefulWidget {
  final String name;
  final String category;
  final int itemNum;
  final String memo;
  final String uid;
  final String itemId;

  ItemHistory({
    required this.name,
    required this.category,
    required this.itemNum,
    required this.memo,
    required this.uid,
    required this.itemId,
  });

  @override
  _ItemHistoryState createState() => _ItemHistoryState();
}

class _ItemHistoryState extends State<ItemHistory> {
  final TextEditingController _stockChangeController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  int _currentStock = 0;
  late bool _isStockFetched;
  late final DocumentReference _historyDocRef;

  @override
  void initState() {
    super.initState();
    _isStockFetched = false;
    _historyDocRef = FirebaseFirestore.instance
      .collection('users')
      .doc(widget.uid)
      .collection('itemdetails')
      .doc(widget.itemId);

    _fetchInitialStock();
  }

  @override
  void dispose() {
    _stockChangeController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialStock() async {
    try {
      QuerySnapshot querySnapshot = await _historyDocRef.collection('history')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
      print(querySnapshot.docs);
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        _currentStock = docSnapshot['new_stock'] ?? 0;
        print(_currentStock);
        _isStockFetched = true;
        setState(() {});
      } else {
        // データが存在しない場合の処理
        // 初期在庫を0として設定するなど、適切な処理を行う
      }
    } catch (e) {
      print('Error fetching initial stock: $e');
    }
  }

  void _saveStockChange() {
    if (!_isStockFetched) {
      // 在庫データがまだ取得されていない場合、保存を行わない
      print('Stock data not fetched yet.');
      return;
    }
    int stockChange = int.parse(_stockChangeController.text);
    int newStock = _currentStock + stockChange;
    String reason = _reasonController.text;
    print(newStock);

    // Firestoreに在庫の変動を保存する処理
    _historyDocRef.collection('history').doc().set({
      'change': stockChange,
      'new_stock': newStock,
      'timestamp': FieldValue.serverTimestamp(),
      'reason': reason,
    });

    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.uid)
      .collection('itemdetails')
      .doc(widget.itemId)
      .update({'itemNum': newStock});

    _stockChangeController.clear();
    _reasonController.clear();
    _fetchInitialStock();
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
              Text('差分'),
              SizedBox(height: 10),
              TextField(
                controller: _stockChangeController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Text('理由'), // 追加：理由のラベル
              SizedBox(height: 10),
              TextField(
                controller: _reasonController,
                keyboardType: TextInputType.text,
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
                child: Text('新規登録'),
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
                      itemId: widget.itemId,
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