import 'package:flutter/material.dart';

class AddItemPage extends StatelessWidget {
  final String uid;
  const AddItemPage({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 243, 245),
      body: const Center(
          child: Text('予備ページ', style: TextStyle(fontSize: 32.0))),
    );
  }
}