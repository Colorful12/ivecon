import 'package:flutter/material.dart'; // import './myapp.dart'; // Myappが別のファイル内にある場合
import 'package:flutter/cupertino.dart'; //iOS風のUIを再現するWidget群(今回は未使用)
import 'pages/itemlist.dart';
import 'pages/additems.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({Key? key, required this.uid}): super(key: key);
  final String uid;
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      home:  BottomNaviBar(uid: uid),
    );
  }
}

class BottomNaviBar extends StatefulWidget {
  const BottomNaviBar({super.key, required this.uid});
  final String uid;
  @override
  State<BottomNaviBar> createState() => _BottomNaviBarState();
  // State<BottomNaviBar> createState() => _MyHomePageState();
}

class _BottomNaviBarState extends State<BottomNaviBar> {
  int _selectedIndex = 0;
  static const _pages = [
    AddItemPage(),
    ItemListPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('BottomNavigationBar Sample'),
      // ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: '入力',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: '一覧',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 105, 124, 234),
        onTap: _onItemTapped,
      ),
    );
  }
}