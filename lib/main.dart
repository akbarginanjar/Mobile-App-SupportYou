import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:mobile_supportyou/services/pelatihan_service.dart';
import 'package:mobile_supportyou/config/app.dart';
import 'package:mobile_supportyou/controllers/purchased_batch_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  Get.put(PurchasedBatchController());
  // await GetStorage.init(); // pastikan storage siap

  // // Tes service sebelum runApp
  // final service = PelatihanService();
  // final response = await service.listPelatihan(start: 0, length: 10);

  // print("Status Code: ${response.statusCode}");
  // print("Response Body: ${response.body}");

  runApp(const App());
}