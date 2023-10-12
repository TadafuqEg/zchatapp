import 'package:zchatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Weclome To Zhat",
            body:
                "Chat with your friends share photo fiels fast ",
            image: Container(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset("assets/lottie/main-laptop-duduk.json"),
              ),
            ),
          ),
          PageViewModel(
            title: "Chat someone",
            body:
                "Chat write the people you want during your flight!",
            image: Container(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset("assets/lottie/animation_lnlf14mp.json"),
              ),
            ),
          ),
          PageViewModel(
            title: "Chat anytime, anywere",
            body: "Passing of any information on any Screen, any device instantly is made simple at its sublime.",
            image: Container(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset("assets/lottie/chatanytime.json"),
              ),
            ),
          ),

        ],
        onDone: () => Get.offAllNamed(Routes.LOGIN),
        showSkipButton: true,
        skip: Text("Skip"),
        next: Text(
          "Next",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        done: const Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
