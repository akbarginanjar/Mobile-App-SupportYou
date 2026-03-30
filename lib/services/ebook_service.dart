import 'package:get/get.dart';
import 'package:mobile_supportyou/models/ebook_model.dart';
import 'package:mobile_supportyou/utils/base.dart';

class EbookService extends GetConnect {
  // 🔹 Ambil list e-book
  Future<List<Ebook>> getEbook({int start = 0, int length = 10}) async {
    final response = await get(
      '${Base.url}/v1/pelatihan?start=$start&length=$length&type=ebook',
      headers: {
        'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
        'device': 'mobile',
      },
    );

    if (response.statusCode == 200) {
      final List result = response.body['data'];
      return result.map((e) => Ebook.fromJson(e)).toList();
    } else {
      print("Error getEbook: ${response.statusCode} - ${response.body}");
      return [];
    }
  }

Future<Ebook?> getDetailEbook(String id) async {
  final response = await get(
    '${Base.url}/v1/pelatihan/$id?type=ebook',
    headers: {
      'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
      'device': 'mobile',
    },
  );

  if (response.statusCode == 200) {
    return Ebook.fromJson(response.body['data']);
  } else {
    print("Error getDetailEbook: ${response.statusCode} - ${response.body}");
    return null;
  }
}


  // 🔹 Search e-book
  Future<List<Ebook>> searchEbook(String query, {int start = 0, int length = 10}) async {
    final response = await get(
      '${Base.url}/v1/pelatihan?search=$query&start=$start&length=$length&type=ebook',
      headers: {
        'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
        'device': 'mobile',
      },
    );

    if (response.statusCode == 200) {
      final List result = response.body['data'];
      return result.map((e) => Ebook.fromJson(e)).toList();
    } else {
      print("Error searchEbook: ${response.statusCode} - ${response.body}");
      return [];
    }
  }
}
