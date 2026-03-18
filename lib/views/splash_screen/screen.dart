import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme,
      body: GetBuilder<SplashController>(
        init: SplashController(),
        builder: (s) {
          return Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/logo/supportyou-logo-icon.png',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width / 2.0,
              ),
            ),
          );
        },
      ),
    );
  }
}
