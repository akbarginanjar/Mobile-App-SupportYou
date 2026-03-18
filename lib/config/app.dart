import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/views/splash_screen/screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: defaultTheme(context),
      // darkTheme: ThemeData.dark(), // Tema gelap
      // theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'SupportYou',
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}