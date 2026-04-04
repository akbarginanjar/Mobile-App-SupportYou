import 'package:get/get.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/utils/base.dart';

class PelatihanService extends GetConnect {
  // 🔹 Ambil list pelatihan
  Future<List<Pelatihan>> getPelatihan({int start = 0, int length = 10}) async {
    final response = await get(
      '${Base.url}/v1/pelatihan?start=$start&length=$length&type=pelatihan',
      headers: {
        'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
        'device': 'mobile',
      },
    );

    if (response.statusCode == 200) {
      final List result = response.body['data'];
      return result.map((e) => Pelatihan.fromJson(e)).toList();
    } else {
      print("Error getPelatihan: ${response.statusCode} - ${response.body}");
      return [];
    }
  }

  // 🔹 Ambil detail pelatihan
  Future<Pelatihan?> getDetailPelatihan(String id) async {
    final response = await get(
      '${Base.url}/v1/pelatihan/$id?type=pelatihan',
      headers: {
        'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
        'device': 'mobile',
      },
    );

    if (response.statusCode == 200) {
      return Pelatihan.fromJson(response.body['data']);
    } else {
      print("Error getDetailPelatihan: ${response.statusCode} - ${response.body}");
      return null;
    }
  }

  // 🔹 Search pelatihan
  Future<List<Pelatihan>> searchPelatihan(String query, {int start = 0, int length = 10}) async {
    final response = await get(
      '${Base.url}/v1/pelatihan?search=$query&start=$start&length=$length&type=pelatihan',
      headers: {
        'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
        'device': 'mobile',
      },
    );

    if (response.statusCode == 200) {
      final List result = response.body['data'];
      return result.map((e) => Pelatihan.fromJson(e)).toList();
    } else {
      print("Error searchPelatihan: ${response.statusCode} - ${response.body}");
      return [];
    }
  }
}