// lib/services/kategori_service.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_supportyou/models/kategori_model.dart';
import 'package:mobile_supportyou/utils/base.dart';

class KategoriService extends GetConnect {
  Future<List<KategoriModel>> getKategori() async {
    final String? tokens = GetStorage().read('tokens');
    
    final headers = {
      'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
      'author': 'bearer $tokens',
      'device': 'mobile',
      'Content-Type': 'application/json',
    };
    
    try {
      final response = await get('${Base.url}v1/kategori-pelatihan', headers: headers);
      
      if (response.statusCode == 200 && response.body['status'] == true) {
        final List data = response.body['data'];
        return data.map((json) => KategoriModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error loading categories: $e');
      return [];
    }
  }
}