import 'package:flutter/material.dart';

class TextBubble extends StatelessWidget {
  final String slang;

  const TextBubble({Key? key, required this.slang}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.yellowAccent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        slang,
        style: TextStyle(fontSize: 16.0, color: Colors.black),
      ),
    );
  }
}
