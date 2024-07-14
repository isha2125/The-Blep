import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('New', style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Text('New Page Content', style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
