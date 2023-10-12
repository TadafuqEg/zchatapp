import 'package:flutter/material.dart';

class WAuthTitleTxt extends StatelessWidget {
  String txt;
  WAuthTitleTxt({super.key,required this.txt});

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.red.shade900,
        fontWeight: FontWeight.w900,
        fontSize: 25
      ),
    );
  }
}
class WAuthDescTxt extends StatelessWidget {
  String txt;
   WAuthDescTxt({super.key,required this.txt});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Text(
        txt,
        style: TextStyle(
            color: Colors.red.shade700,
            fontWeight: FontWeight.w600,
            fontSize: 18
        ),
        
      ),
    );
  }
}
