import 'package:flutter/material.dart';

class EdtLoginW extends StatelessWidget {
    String hinttext;
    TextEditingController tec;
    bool obscureText;
    Icon prefixIcon;
   EdtLoginW({super.key, required this.hinttext,required this.obscureText,required this.prefixIcon,required this.tec});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(

        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25)
      ),
      child: TextFormField(
        controller: tec,
        obscureText:obscureText ,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText:hinttext,
          labelStyle: TextStyle(color: Colors.red.shade900),
          labelText: hinttext,
          prefixIcon: prefixIcon
        ),
      ),
    );
  }
}
