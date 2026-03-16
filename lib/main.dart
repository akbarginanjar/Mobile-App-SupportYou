import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_supportyou/config/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(const App());
}