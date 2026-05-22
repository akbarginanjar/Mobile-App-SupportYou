// lib/controllers/splash_controller.dart
import 'package:get/get.dart';
import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_supportyou/views/main_screen/screen.dart';
import 'package:mobile_supportyou/views/login_screen/screen.dart';

class SplashController extends GetxController {
  final GetStorage box = GetStorage();

  @override
  void onInit() {
    startSplashScreen();
    super.onInit();
  }

  void startSplashScreen() {
    const duration = Duration(seconds: 3);
    Timer(duration, () {
      Get.offAll(
        box.read('tokens') != null
            ? const MainScreen()
            : const LoginScreen(),
      );
    });
  }
}