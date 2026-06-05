import 'dart:io';
import 'dart:convert';
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
        return token?.toString();
      } else if (tokens != null && tokens is String) {
        return tokens;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  int? _getMemberId() {
    final id = _storage.read('member_id');
    return id != null ? int.tryParse(id.toString()) : null;
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

    try {
      final response = await get(url, headers: _getHeaders());
      if (response.statusCode == 200) {
        final body = response.body;
        List result = [];
        if (body is List) {
          result = body;
        } else if (body is Map && body['data'] is List) {
          result = body['data'];
        }
        return result
            .whereType<Map<String, dynamic>>()
            .map((json) => Transaksi.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('❌ Network Error: $e');
      return [];
    }
  }

  Future<dynamic> getUserDetail() async {
    final memberId = _getMemberId();
    if (memberId == null || memberId == 0) return null;

    try {
      final response = await get(
        '${Base.url}v1/affiliator/member-public/$memberId',
        headers: _getHeaders(),
      );
      debugPrint('📥 getUserDetail response status: ${response.statusCode}');
      debugPrint('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body is Map) {
          return response.body;
        } else if (response.body is String) {
          final decoded = json.decode(response.body);
          if (decoded is Map) return decoded;
        }
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error getting user detail: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateProfile({
    required String namaLengkap,
    required String email,
    required String noHp,
  }) async {
    final memberId = _getMemberId();
    if (memberId == null || memberId == 0) return null;

    final payload = {
      "nama_lengkap": namaLengkap,
      "member_id": memberId,
      "email": email,
      "no_hp": noHp,
    };

    try {
      final response = await post(
        '${Base.url}v1/affiliator/update-member',
        payload,
        headers: _getHeaders(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      }
      return null;
    } catch (e) {
      debugPrint('❌ Update profile error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final payload = {
      "current_password": currentPassword,
      "password": newPassword,
      "password_confirmation": newPassword,
    };

    try {
      final response = await post(
        '${Base.url}v1/auth/change-password',
        payload,
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        return response.body;
      }
      return null;
    } catch (e) {
      debugPrint('❌ Change password error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> uploadPhoto(File imageFile) async {
    final memberId = _getMemberId();
    if (memberId == null || memberId == 0) return null;

    final String mimeType = imageFile.path.toLowerCase().endsWith('.png')
        ? 'image/png'
        : 'image/jpeg';

    final formData = FormData({
      'member_id': memberId.toString(),
      'nama_lengkap': _storage.read('nama_lengkap') ?? '',
      'email': _storage.read('email') ?? '',
      'no_hp': _storage.read('no_hp') ?? '',
      'photo': MultipartFile(
        imageFile,
        filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
        contentType: mimeType,
      ),
    });

    debugPrint('📤 UPLOAD PHOTO (multipart)');
    debugPrint('URL: ${Base.url}v1/affiliator/update-member');

    try {
      final response = await post(
        '${Base.url}v1/affiliator/update-member',
        formData,
        headers: _getHeaders(),
      );
      debugPrint('📥 Response Status: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        debugPrint('❌ Upload photo failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Network Error: $e');
      return null;
    }
  }
}