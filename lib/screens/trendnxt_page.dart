import 'package:flutter/material.dart';

class TrendNxtPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('TrendNxt', style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Text('TrendNxt Page Content',
            style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
