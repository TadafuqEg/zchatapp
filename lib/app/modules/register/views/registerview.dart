import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zchatapp/app/widgets/Btndefaults/EvletedButtonW.dart';
import 'package:zchatapp/app/widgets/EditTextlogin/edtlogin.dart';
import 'package:zchatapp/app/widgets/TextsDefaluts/authTexted/authTxt.dart';

import '../../../controllers/auth_controller.dart';
import '../controllers/register_controller.dart';
class RegisterView extends GetView<RegisterController>{
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Get.back();
        },
        icon: Icon(Icons.arrow_back_ios_new,color: Colors.red.shade900,),
        ),
        title: Text('Create Account',style: TextStyle(color: Colors.red.shade900),),
      ),
      body: SafeArea(
        child:ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                WAuthDescTxt(
                  txt: 'Create an Account ',
                ),
                EdtLoginW(
                  tec: authC.nametec,
                  obscureText: false,
                  hinttext: 'Name',
                  prefixIcon: Icon(Icons.account_box,color: Colors.red.shade900),
                ),
                EdtLoginW(
                  tec: authC.emailtec,
                  obscureText: false,
                  hinttext: 'Email',
                  prefixIcon: Icon(Icons.alternate_email,color: Colors.red.shade900),
                ),
                EdtLoginW(
                  tec: authC.phonetec,
                  obscureText: false,
                  hinttext: 'Phone',
                  prefixIcon: Icon(Icons.phone_android,color: Colors.red.shade900),
                ),
                EdtLoginW(
                  tec: authC.passwordtec,
                  obscureText: true,
                  hinttext: 'Password',
                  prefixIcon: Icon(Icons.password,color: Colors.red.shade900),
                ),
                EdtLoginW(
                  tec: authC.confirmpasswordtec,
                  obscureText: true,
                  hinttext: 'Confirm Password',
                  prefixIcon: Icon(Icons.password,color: Colors.red.shade900),
                ),
                EventBtn(txt: 'Create',onPressed: (){
                  authC.RegisterWithEmailAndPassword(context);

                },)
              ],
            )
          ],
        ) ,
      ),
    );
  }
}