import 'package:get/get.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';

class PelatihanService extends GetConnect {
  Future<List<Pelatihan>> getPelatihan({int start = 0, int length = 10}) async {
    final response = await get(
      'https://api-supportyou.kehosting.in/v1/pelatihan?start=$start&length=$length',
      headers: {
        'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
        'device': 'mobile',
      },
    );

    if (response.statusCode == 200) {
      final List result = response.body['data'];
      return result.map((e) => Pelatihan.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}