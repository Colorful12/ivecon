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


  Widget _buildHistoryList(List<DocumentSnapshot> historyDocs) {
    if (historyDocs == null || historyDocs.isEmpty) {
      return Text('履歴はありません');
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: historyDocs.length,
      itemBuilder: (context, index) {
        var history = historyDocs[index];
        int? change = history['change'];
        int? newStock = history['new_stock'];
        String? reason = history['reason'];
        Timestamp? timestamp = history['timestamp'];
        DateTime dateTime = timestamp?.toDate() ?? DateTime.now();

        return Container(
          height: 40,
          margin: EdgeInsets.only(
            left: 400,
            right: 400,
            top: 20,
            bottom: 20,
          ),
          color : Colors.white,
          child: Column(
            children: [
              Text('${dateTime.toLocal()}'),
              Text('変動：${change ?? 0}, 在庫：${newStock ?? 0}, 理由：${reason ?? "不明"}')
            ],
         ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffC5C7D3),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: ListView( // ListViewで囲む
            children: [
              Center(
                child: Text('変動登録', style: TextStyle(fontSize: 20, color: Color(0xff2C2C2C)))  
              ),
              _buildInputField('差分', _stockChangeController, TextInputType.number),
              SizedBox(height: 20),
              _buildInputField('理由', _reasonController, TextInputType.text),
              SizedBox(height: 20),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 600), 
                  child:ElevatedButton(
                    onPressed: _saveStockChange,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      primary: Color(0xFFE65A71),
                      onPrimary: Color(0xFFF7F7F7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('新規登録'),
                  ),
               ),
              SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Text('変動履歴', style: TextStyle(fontSize: 20, color: Color(0xff2C2C2C))),
                    StreamBuilder<QuerySnapshot>(
                      stream: _historyDocRef.collection('history')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<DocumentSnapshot> historyDocs = snapshot.data!.docs;
                          return _buildHistoryList(historyDocs);
                        } else if (snapshot.hasError) {
                          return Text('エラーが発生しました');
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ]
                )
              )
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

Widget _buildInputField(String labelText, TextEditingController controller, TextInputType keyboardType) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 10),
       Padding(
          padding: EdgeInsets.symmetric(horizontal: 400), 
          child:TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color.fromARGB(255, 105, 124, 234)),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              // setState(() {}); // onChangedの処理は必要ない場合はコメントアウトしても問題ありません
            },
          ),
       )
    ],
  );
}
}