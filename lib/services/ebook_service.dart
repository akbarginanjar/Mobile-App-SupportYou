import 'package:get/get.dart';
import 'package:mobile_supportyou/models/ebook_model.dart';
import 'package:mobile_supportyou/utils/base.dart';

class EbookService extends GetConnect {
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
}
