import 'package:flutter/material.dart';
class BtnTxt extends StatelessWidget {
  final String txt;
  final onPressed;
  const BtnTxt({super.key,required this.onPressed,required this.txt});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      foregroundColor: Colors.blue,
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
    );
    return TextButton(
      style: flatButtonStyle,
      onPressed: onPressed,
      child: Text(txt),
    );
  }
}
