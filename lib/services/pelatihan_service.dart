// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:mobile_supportyou/utils/base.dart';

// class PelatihanService extends GetConnect {
//   final String tokens = GetStorage().read('tokens');

//   /// Ambil daftar pelatihan
// Future<Response> listPelatihan({int start = 0, int length = 10}) async {
//   final header = {
//     'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
//     'Authorization': 'bearer $tokens',
//     'device': 'mobile',
//   };

//   final response = await get(
//     '${Base.url}/v1/pelatihan?start=$start&length=$length',
//     headers: header,
//   );

//   // Print semua isi response untuk debugging
//   print("Status Code: ${response.statusCode}");
//   print("Response Body: ${response.body}");

//   return response;
// }

//   /// Cari pelatihan berdasarkan keyword
//   Future<Response> searchPelatihan(String keyword) {
//     final header = {
//       'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
//       'Authorization': 'bearer $tokens',
//       'device': 'mobile',
//     };

//     return get(
//       '${Base.url}/v1/pelatihan?search=$keyword',
//       headers: header,
//     );
//   }

//   /// Ambil detail pelatihan berdasarkan slug
//   Future<Response> detailPelatihan(String slug) {
//     final header = {
//       'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
//       'Authorization': 'bearer $tokens',
//       'device': 'mobile',
//     };

//     return get(
//       '${Base.url}/v1/pelatihan/$slug',
//       headers: header,
//     );
//   }
// }