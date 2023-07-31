import 'package:flutter/material.dart';

class AddItemPage extends StatelessWidget {
  const AddItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 243, 245),
      body: const Center(
          child: Text('一括増減', style: TextStyle(fontSize: 32.0))),
    );
  }
}