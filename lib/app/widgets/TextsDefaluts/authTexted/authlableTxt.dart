import 'package:flutter/material.dart';
class LableTxtAuth extends StatelessWidget {
  final String txt;
  const LableTxtAuth({super.key,required this.txt});

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 18
      ),

    );
  }
}
