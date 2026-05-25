import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_supportyou/models/riwayat_pelatihan_model.dart';
import 'package:mobile_supportyou/utils/base.dart';

class RiwayatPelatihanService extends GetConnect {
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
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
  
  Future<List<PelatihanDibeli>> getPelatihanDibeli() async {
    final memberId = _getMemberId();
    
    if (memberId == null || memberId == 0) {
      debugPrint('Member ID not found');
      return [];
    }
    
    final url = '${Base.url}v1/pelatihan/pelatihan-dibeli?konsumen_member_id=$memberId';
    
    debugPrint('GET Pelatihan Dibeli: $url');
    
    try {
      final response = await get(url, headers: _getHeaders());
      
      debugPrint('Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final body = response.body;
        List result = [];
        
        if (body is Map && body['data'] is List) {
          result = body['data'];
        } else if (body is List) {
          result = body;
        }
        
        final pelatihanDibeli = result
            .whereType<Map<String, dynamic>>()
            .map((json) => PelatihanDibeli.fromJson(json['data']))
            .toList();
        
        debugPrint('Loaded ${pelatihanDibeli.length} purchased items');
        return pelatihanDibeli;
      } else {
        debugPrint('HTTP Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Network Error: $e');
      return [];
    }
  }

  Future<List<PelatihanDibeli>> getPelatihanDibeliPaginated({
    int start = 0,
    int length = 10,
  }) async {
    final memberId = _getMemberId();
    
    if (memberId == null || memberId == 0) {
      debugPrint('Member ID not found');
      return [];
    }
    
    final url = '${Base.url}v1/pelatihan/pelatihan-dibeli?konsumen_member_id=$memberId&start=$start&length=$length';
    
    debugPrint('GET Pelatihan Dibeli Paginated: $url');
    
    try {
      final response = await get(url, headers: _getHeaders());
      
      if (response.statusCode == 200) {
        final body = response.body;
        List result = [];
        
        if (body is Map && body['data'] is List) {
          result = body['data'];
        } else if (body is List) {
          result = body;
        }
        
        final pelatihanDibeli = result
            .whereType<Map<String, dynamic>>()
            .map((json) => PelatihanDibeli.fromJson(json['data']))
            .toList();
        
        return pelatihanDibeli;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Network Error: $e');
      return [];
    }
  }
}