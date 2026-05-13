import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class QRSaver {
  static Future<void> saveToGallery(String qrisUrl) async {
    try {
      final hasPermission = await _checkPermission();
      if (!hasPermission) {
        Get.snackbar(
          'Izin Diperlukan',
          'Aplikasi memerlukan izin untuk menyimpan ke galeri',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      Get.dialog(
        barrierDismissible: false,
        const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Menyimpan QR Code...'),
                ],
              ),
            ),
          ),
        ),
      );

      final response = await Dio().get(
        qrisUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        final Uint8List imageBytes = Uint8List.fromList(response.data);
        final String imageName = 'qris_${DateTime.now().millisecondsSinceEpoch}.png';

        final SaveResult result = await SaverGallery.saveImage(
          imageBytes,
          quality: 100,
          fileName: imageName,
          androidRelativePath: 'Pictures/SupportYou',
          skipIfExists: false,
        );

        Get.back();

        if (result.isSuccess) {
          Get.snackbar(
            'Berhasil',
            'QR Code berhasil disimpan ke galeri',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        } else {
          throw Exception('Gagal menyimpan ke galeri: ${result.errorMessage}');
        }
      } else {
        throw Exception('Gagal mengunduh QR Code');
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Gagal',
        'Gagal menyimpan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  static Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;

      if (sdkInt >= 33) {
        return await Permission.photos.request().isGranted;
      } else if (sdkInt >= 29) {
        return true;
      } else {
        return await Permission.storage.request().isGranted;
      }
    } else if (Platform.isIOS) {
      return await Permission.photosAddOnly.request().isGranted;
    }
    return false;
  }
}