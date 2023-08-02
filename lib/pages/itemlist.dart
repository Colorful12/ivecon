import 'package:flutter/material.dart';
import 'addoneitem.dart';

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
            child: Row(
              children: [
                Text("一覧"),
                Text("仮")
              ]
            )
          ),
          Flexible( //Columnの子にListViewをそのまま入れるとエラー : Flexibleで覆って解決
            child: ListView(
              children: _getItems(),
            ),
          )
        ],
      )
    );
  }
  List<Widget> _getItems(){
    List<String> _itemName= ["ポスカ1", "ポスカ2", "ポスカ3", "ポスカ4", "ポスカ5", "ポスカ6"];
    final List<Widget> _todoWidgets = <Widget>[];
    for (String title in _itemName) {
      _todoWidgets.add(
        Container(
          height: 200,
          margin: EdgeInsets.only(
            left: 80,
            right: 80,
            top: 20,
            bottom: 20
          ),
          color: Color.fromARGB(255, 255, 255, 255),
          child: Row(
            children: <Widget>[
              Container(
                child: Text("あいてむ"),
              ),
              Text(title),
            ],
          ),
        )
      );
    }
    return _todoWidgets;
  }

}