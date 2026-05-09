// import 'dart:io';
// import 'package:dio/dio.dart' as dio;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class ImageSaver {
//   static get GallerySaver => null;

//   static Future<bool> saveImageToGallery(String imageUrl, {String? fileName}) async {
//     try {
//       // Request permission
//       final hasPermission = await _requestStoragePermission();
//       if (!hasPermission) {
//         Get.snackbar(
//           'Izin diperlukan',
//           'Aplikasi memerlukan izin untuk menyimpan gambar',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.orange,
//           colorText: Colors.white,
//           duration: const Duration(seconds: 3),
//         );
//         return false;
//       }

//       // Show loading dialog
//       Get.dialog(
//         barrierDismissible: false,
//         const Center(
//           child: Card(
//             child: Padding(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 12),
//                   Text('Menyimpan QR Code...'),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );

//       // Download image to temporary file
//       final dioClient = dio.Dio();
//       final response = await dioClient.get(
//         imageUrl,
//         options: dio.Options(responseType: dio.ResponseType.bytes),
//       );

//       if (response.statusCode == 200) {
//         // Save to temporary file
//         final tempDir = await getTemporaryDirectory();
//         final file = File('${tempDir.path}/${fileName ?? 'qris_${DateTime.now().millisecondsSinceEpoch}'}.png');
//         await file.writeAsBytes(response.data);

//         // Save to gallery using gallery_saver
//         final result = await GallerySaver.saveImage(file.path);

//         Get.back(); // Close loading dialog

//         if (result == true) {
//           Get.snackbar(
//             'Berhasil',
//             'QR Code berhasil disimpan ke galeri',
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.green,
//             colorText: Colors.white,
//             duration: const Duration(seconds: 2),
//           );
          
//           // Delete temporary file
//           await file.delete();
//           return true;
//         } else {
//           throw Exception('Gagal menyimpan ke galeri');
//         }
//       } else {
//         throw Exception('Gagal mengunduh gambar');
//       }
//     } catch (e) {
//       Get.back(); // Close loading dialog if still open
//       Get.snackbar(
//         'Gagal',
//         'Gagal menyimpan gambar: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//       );
//       return false;
//     }
//   }

//   static Future<bool> saveNetworkImageToGallery(String imageUrl, {String? fileName}) async {
//     try {
//       final hasPermission = await _requestStoragePermission();
//       if (!hasPermission) {
//         return false;
//       }

//       Get.dialog(
//         barrierDismissible: false,
//         const Center(
//           child: Card(
//             child: Padding(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 12),
//                   Text('Menyimpan gambar...'),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );

//       final result = await GallerySaver.saveImage(imageUrl, 
//         albumName: 'SupportYou QR Codes',
//         fileName: fileName ?? 'qris_${DateTime.now().millisecondsSinceEpoch}'
//       );

//       Get.back();

//       if (result == true) {
//         Get.snackbar(
//           'Berhasil',
//           'Gambar berhasil disimpan ke galeri',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//         return true;
//       } else {
//         throw Exception('Gagal menyimpan');
//       }
//     } catch (e) {
//       Get.back();
//       Get.snackbar(
//         'Gagal',
//         'Gagal menyimpan: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return false;
//     }
//   }

//   static Future<bool> _requestStoragePermission() async {
//     if (Platform.isAndroid) {
//       // For Android 13+ (API 33+)
//       if (await Permission.photos.isGranted) {
//         return true;
//       }
      
//       // For Android 12 and below
//       if (await Permission.storage.isGranted) {
//         return true;
//       }
      
//       // Request permission based on SDK version
//       if (await Permission.photos.request().isGranted) {
//         return true;
//       }
      
//       if (await Permission.storage.request().isGranted) {
//         return true;
//       }
      
//       return false;
//     } else if (Platform.isIOS) {
//       final status = await Permission.photos.request();
//       return status.isGranted;
//     }
//     return true;
//   }
// }