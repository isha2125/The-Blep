import 'package:flutter/material.dart';

class StoresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Stores', style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child:
            Text('Stores Page Content', style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
