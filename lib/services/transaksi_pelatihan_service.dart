// lib/services/transaksi_pelatihan_service.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_supportyou/models/transaksi_model.dart';
import 'package:mobile_supportyou/utils/base.dart';

class TransaksiPelatihanService extends GetConnect {
  Future<List<Transaksi>> getTransaksiPelatihanByStatus(String status) async {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📤 GET Transaksi Pelatihan');
    print('Status: $status');
    
    final GetStorage storage = GetStorage();
    final String? tokens = storage.read('tokens');
    final int? memberId = storage.read('member_id');
    
    print('Member ID: $memberId');
    print('Tokens exists: ${tokens != null}');
    
    if (tokens == null) {
      print('❌ Token not found!');
      Get.snackbar('Error', 'Sesi login tidak ditemukan. Silakan login kembali.');
      throw Exception('Sesi login tidak ditemukan.');
    }
    
    final url = '${Base.url}v1/transaksi-online?konsumen_member_id=$memberId&show_bukti_tf=1&status=$status&view_as_invoice=1&start=0&length=20&transaction_type=pelatihan';
    
    print('URL: $url');
    
    final headers = {
      'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
      'author': 'bearer $tokens',
      'device': 'mobile',
    };
    
    print('Headers: $headers');
    
    Response conn;
    try {
      conn = await get(url, headers: headers);
      print('Response Status Code: ${conn.statusCode}');
      print('Response Body: ${conn.body}');
    } catch (e) {
      print('❌ Network error: $e');
      Get.snackbar('Error Transaksi Pelatihan $status', 'Koneksi error: $e');
      rethrow;
    }
    
    if (conn.statusCode == 200) {
      final body = conn.body;
      List result = [];
      
      if (body is List) {
        result = body;
        print('Response is List, length: ${result.length}');
      } else if (body is Map && body['data'] is List) {
        result = body['data'];
        print('Response has data array, length: ${result.length}');
      } else {
        print('⚠️ Unexpected response format: ${body.runtimeType}');
        result = [];
      }
      
      final typed = result.whereType<Map<String, dynamic>>().toList();
      final transaksi = typed.map((json) => Transaksi.fromJson(json)).toList();
      print('✅ Parsed ${transaksi.length} transactions for status: $status');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      return transaksi;
    } else {
      String errorMessage;
      if (conn.body is Map && (conn.body as Map)['message'] != null) {
        errorMessage = (conn.body as Map)['message'].toString();
      } else {
        errorMessage = 'HTTP ${conn.statusCode}: Terjadi kesalahan pada server';
      }
      print('❌ HTTP Error ${conn.statusCode}: $errorMessage');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      
      throw Exception(errorMessage);
    }
  }
}