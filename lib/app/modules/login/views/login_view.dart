import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:zchatapp/app/routes/app_pages.dart';
import 'package:zchatapp/app/widgets/EditTextlogin/edtlogin.dart';

import '../../../widgets/Btndefaults/txtBtn.dart';
import '../controllers/login_controller.dart';
import '../../../controllers/auth_controller.dart';

class LoginView extends GetView<LoginController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: Get.width * 0.5,
                  height: Get.width * 0.5,
                  child: Lottie.asset("assets/lottie/login.json"),
                ),
                SizedBox(height: 16),
                EdtLoginW(
                    tec: authC.emailtec,
                    hinttext: "Email", obscureText: false, prefixIcon: Icon(Icons.alternate_email,color: Colors.red.shade900)),
                EdtLoginW(
                    tec: authC.passwordtec,
                    hinttext: "Password", obscureText: true, prefixIcon: Icon(Icons.password,color: Colors.red.shade900)),
                Container(
                  margin: EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () => authC.LoginwithEmailAndPassword(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                BtnTxt(txt: 'Create new account',onPressed: (){
                  // Get.offAllNamed(Routes.LOGIN);
                  Get.toNamed(Routes.REGISTER);
                }),
                Container(
                  margin: EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () => authC.login(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          child: Image.asset("assets/logo/google.png"),
                        ),
                        SizedBox(width: 15),
                        Text(
                          "Sign In with Google",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
               
              ],
            ),
          ),
        ),
      ),
    );
  }
}
