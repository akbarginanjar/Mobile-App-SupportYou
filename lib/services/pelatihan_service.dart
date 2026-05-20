import 'package:get/get.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/utils/base.dart';

class PelatihanService extends GetConnect {
  
  Future<List<Pelatihan>> getPelatihanHome() async {
    final response = await get(
      '${Base.url}/v1/pelatihan?is_published=1&start=0&length=6&type=pelatihan',
      headers: {
        'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
        'device': 'mobile',
      },
    );

    if (response.statusCode == 200) {
      final List result = response.body['data'];
      return result.map((e) => Pelatihan.fromJson(e)).toList();
    } else {
      print("Error getPelatihanHome: ${response.statusCode} - ${response.body}");
      return [];
    }
  }

  Future<List<Pelatihan>> getPelatihanAll({int start = 0, int length = 10}) async {
    final response = await get(
      '${Base.url}/v1/pelatihan?is_published=1&start=$start&length=$length&type=pelatihan',
      headers: {
        'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
        'device': 'mobile',
      },
    );

    if (response.statusCode == 200) {
      final List result = response.body['data'];
      return result.map((e) => Pelatihan.fromJson(e)).toList();
    } else {
      print("Error getPelatihanAll: ${response.statusCode} - ${response.body}");
      return [];
    }
  }

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

  Future<List<Pelatihan>> searchPelatihan(String query, {int start = 0, int length = 10}) async {
    final response = await get(
      '${Base.url}/v1/pelatihan?is_published=1&search=$query&start=$start&length=$length&type=pelatihan',
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

  Future<List<Pelatihan>> getPelatihanByKategori(int kategoriId) async {
    final response = await get(
      '${Base.url}/v1/pelatihan?is_published=1&kategori_id=$kategoriId&type=pelatihan',
      headers: {
        'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
        'device': 'mobile',
      },
    );

    if (response.statusCode == 200) {
      final List result = response.body['data'];
      return result.map((e) => Pelatihan.fromJson(e)).toList();
    } else {
      print("Error getPelatihanByKategori: ${response.statusCode} - ${response.body}");
      return [];
    }
  }
}