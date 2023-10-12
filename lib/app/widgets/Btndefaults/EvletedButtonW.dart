import 'package:flutter/material.dart';


class EventBtn extends StatelessWidget {
  final onPressed;
  final String txt;
  const EventBtn({super.key ,required this.txt,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.red[900],
      minimumSize: Size(double.infinity, 80),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
    );
    return Container(
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        style: raisedButtonStyle,
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(txt,style: TextStyle(fontSize: 25),),
            Icon(Icons.check_circle_outline,color: Colors.white,)
          ],
        ),
      ),
    );
  }
}
