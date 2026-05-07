// lib/services/profil_service.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_supportyou/models/transaksi_model.dart';
import 'package:mobile_supportyou/utils/base.dart';

class ProfilService extends GetConnect {
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
  
  int? _getMemberId() {
    return _storage.read('member_id');
  }
  
  Map<String, String> _getHeaders() {
    final token = _getToken();
    final headers = {
      'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
      'device': 'mobile',
    };
    
    if (token != null && token.isNotEmpty) {
      headers['author'] = 'Bearer $token';
    }
    
    return headers;
  }
  
  Future<List<Transaksi>> getTransactions({
    String status = 'pending',
    int start = 0,
    int length = 20,
  }) async {
    final memberId = _getMemberId();
    
    if (memberId == null || memberId == 0) {
      debugPrint('❌ Member ID not found');
      return [];
    }
    
    final url = '${Base.url}v1/transaksi-online'
        '?konsumen_member_id=$memberId'
        '&show_bukti_tf=1'
        '&status=$status'
        '&view_as_invoice=1'
        '&start=$start'
        '&length=$length';
    
    debugPrint('📤 GET Transactions: $url');
    
    try {
      final response = await get(url, headers: _getHeaders());
      
      debugPrint('📥 Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final body = response.body;
        List result = [];
        
        if (body is List) {
          result = body;
        } else if (body is Map && body['data'] is List) {
          result = body['data'];
        }
        
        final transactions = result
            .whereType<Map<String, dynamic>>()
            .map((json) => Transaksi.fromJson(json))
            .toList();
        
        debugPrint('✅ Loaded ${transactions.length} transactions');
        return transactions;
      } else {
        debugPrint('❌ HTTP Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ Network Error: $e');
      return [];
    }
  }
  
  Future<Map<String, dynamic>?> getUserDetail() async {
    final memberId = _getMemberId();
    
    if (memberId == null || memberId == 0) {
      return null;
    }
    
    try {
      final response = await get(
        '${Base.url}v1/member/$memberId',
        headers: _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        return response.body['data'];
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error getting user detail: $e');
      return null;
    }
  }

  /// 🔥 UPDATE PROFIL - Menggunakan endpoint yang sama dengan web
  Future<Map<String, dynamic>?> updateProfile({
    required String namaLengkap,
    required String email,
    required String noHp,
  }) async {
    final memberId = _getMemberId();
    
    if (memberId == null || memberId == 0) {
      debugPrint('❌ Member ID not found');
      return null;
    }
    
    final Map<String, dynamic> payload = {
      "nama_lengkap": namaLengkap,
      "member_id": memberId,
      "email": email,
      "no_hp": noHp,
    };
    
    debugPrint('📤 UPDATE PROFILE');
    debugPrint('URL: ${Base.url}v1/affiliator/update-member');
    debugPrint('Payload: $payload');
    
    try {
      final response = await post(
        '${Base.url}v1/affiliator/update-member',
        payload,
        headers: _getHeaders(),
      );
      
      debugPrint('📥 Response Status: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        debugPrint('❌ Update failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Network Error: $e');
      return null;
    }
  }

  /// 🔥 CHANGE PASSWORD
  Future<Map<String, dynamic>?> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final memberId = _getMemberId();
    
    final Map<String, dynamic> payload = {
      "current_password": currentPassword,
      "password": newPassword,
      "password_confirmation": newPassword,
    };
    
    debugPrint('📤 CHANGE PASSWORD');
    debugPrint('URL: ${Base.url}v1/auth/change-password');
    
    try {
      final response = await post(
        '${Base.url}v1/auth/change-password',
        payload,
        headers: _getHeaders(),
      );
      
      debugPrint('📥 Response Status: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        return response.body;
      } else {
        debugPrint('❌ Change password failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Network Error: $e');
      return null;
    }
  }
}