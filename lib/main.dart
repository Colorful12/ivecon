import 'package:flutter/material.dart'; // import './myapp.dart'; // Myappが別のファイル内にある場合
import 'package:flutter/cupertino.dart'; //iOS風のUIを再現するWidget群(今回は未使用)
import 'pages/itemlist.dart';
import 'pages/additems.dart';

// mainメソッドがエントリポイント
void main() {
  runApp(const MyApp()); //runAPP(): 最初に展開するウィジェットを選択. これがないとただのdartファイルになる
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BottomNaviBar(title: 'Flutter Demo Home Page'),
    );
  }
}

// StatefulWidgetは単体では意味がない. 
//State<T> クラスを別に実装し, statefulWidgetに結びつける必要がある.
//それをやってるのが createState()
//State<T>(状態)を保持するクラスと連携して動作するのがStatefulWidget
class BottomNaviBar extends StatefulWidget {
  const BottomNaviBar({super.key, required this.title});

  final String title;

  @override
  State<BottomNaviBar> createState() => _BottomNaviBarState();
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
