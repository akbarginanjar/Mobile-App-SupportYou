import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_supportyou/utils/base.dart';
import 'dart:convert';

class KomplainService extends GetConnect {
  final GetStorage _storage = GetStorage();
  
  String? _getToken() {
    try {
      final tokens = _storage.read('tokens');
      if (tokens != null && tokens is Map) {
        final token = tokens['token'] ?? tokens['access_token'];
        return token;
      } else if (tokens != null && tokens is String) {
        return tokens;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  Map<String, String> _getHeaders() {
    final token = _getToken();
    final headers = {
      'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
      'device': 'mobile',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null && token.isNotEmpty) {
      headers['author'] = 'Bearer $token';
    }
    
    return headers;
  }
  
  Future<Map<String, dynamic>?> submitRefund({
    required int transaksiId,
    required String kategoriRefund,
    required String alasan,
  }) async {
    final url = '${Base.url}v1/refund-transaksi';
    
    final Map<String, dynamic> payload = {
      "transaksi_id": transaksiId,
      "kategori_refund": kategoriRefund,
      "alasan": alasan,
    };
    
    debugPrint('📤 SUBMIT REFUND');
    debugPrint('URL: $url');
    debugPrint('Payload: $payload');
    
    try {
      final response = await post(
        url,
        jsonEncode(payload),
        headers: _getHeaders(),
      );
      
      debugPrint('📥 Response Status: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body is Map) {
          return response.body;
        } else if (response.body is String) {
          return json.decode(response.body);
        }
        return response.body;
      } else {
        debugPrint('❌ Submit refund failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Network Error: $e');
      return null;
    }
  }
  
  void saveRefundStatus(int transaksiId) {
    _storage.write('refund_status_$transaksiId', 'pending');
  }
  
  String? getRefundStatus(int transaksiId) {
    return _storage.read('refund_status_$transaksiId');
  }
  
  void clearRefundStatus(int transaksiId) {
    _storage.remove('refund_status_$transaksiId');
  }
}