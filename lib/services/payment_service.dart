import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/utils/base.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class PaymentService extends GetConnect {
  final GetStorage _storage = GetStorage();
  
  @override
  void onInit() {
    super.onInit();
    httpClient.timeout = const Duration(seconds: 60);
    httpClient.defaultContentType = "application/json";
    
    httpClient.addRequestModifier<void>((request) {
      debugPrint('🔧 REQUEST MODIFIER - URL: ${request.url}');
      debugPrint('🔧 REQUEST MODIFIER - Headers: ${request.headers}');
      return request;
    });
    
    httpClient.addResponseModifier((request, response) {
      debugPrint('🔧 RESPONSE MODIFIER - URL: ${request.url}');
      debugPrint('🔧 RESPONSE MODIFIER - Status: ${response.statusCode}');
      debugPrint('🔧 RESPONSE MODIFIER - Body: ${response.bodyString}');
      return response;
    });
  }
  
  String? _getToken() {
    try {
      final tokens = _storage.read('tokens');
      debugPrint('🔑 Raw tokens from storage: ${tokens != null ? tokens.toString().substring(0, 50) + "..." : "null"}');
      
      if (tokens != null && tokens is Map) {
        final token = tokens['token'] ?? tokens['access_token'];
        debugPrint('🔑 Extracted token from Map');
        return token;
      } else if (tokens != null && tokens is String) {
        debugPrint('🔑 Token from String');
        return tokens;
      }
      debugPrint('🔑 No token found');
      return null;
    } catch (e) {
      debugPrint('🔑 Error getting token: $e');
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
      debugPrint('🔑 Token added to headers');
    } else {
      debugPrint('⚠️ No token available for headers');
    }
    
    return headers;
  }
  
  Future<dynamic> getPaymentMethods() async {
    try {
      final url = '${Base.url}v1/p-method';
      debugPrint('📤 GET Payment Methods: $url');
      
      final response = await get(
        url,
        headers: _getHeaders(),
      );
      
      debugPrint('📥 RESPONSE: Payment Methods');
      debugPrint('Status Code: ${response.statusCode}');
      
      return response.body;
    } catch (e) {
      debugPrint('❌ Error loading payment methods: $e');
      throw Exception('Failed to load payment methods: $e');
    }
  }
  
  Future<dynamic> getTransactionFees() async {
    try {
      final url = '${Base.url}v1/get-transaction-fee';
      debugPrint('📤 GET Transaction Fees: $url');
      
      final response = await get(
        url,
        headers: _getHeaders(),
      );
      
      debugPrint('📥 RESPONSE: Transaction Fees');
      debugPrint('Status Code: ${response.statusCode}');
      
      return response.body;
    } catch (e) {
      debugPrint('❌ Error loading transaction fees: $e');
      throw Exception('Failed to load transaction fees: $e');
    }
  }
  
  Future<dynamic> getAvailableDiscounts() async {
    try {
      final url = '${Base.url}v1/get-available-discounts';
      debugPrint('📤 GET Available Discounts: $url');
      
      final response = await get(
        url,
        headers: _getHeaders(),
      );
      
      debugPrint('📥 RESPONSE: Available Discounts');
      debugPrint('Status Code: ${response.statusCode}');
      
      return response.body;
    } catch (e) {
      debugPrint('❌ Error loading discounts: $e');
      return [];
    }
  }
  
  Future<dynamic> getInvoice(int id) async {
    try {
      final url = '${Base.url}v1/view-invoice/$id';
      debugPrint('📤 GET Invoice: $url');
      
      final response = await get(
        url,
        headers: _getHeaders(),
      );
      
      debugPrint('📥 RESPONSE: Invoice');
      debugPrint('Status Code: ${response.statusCode}');
      
      return response.body;
    } catch (e) {
      debugPrint('❌ Error getInvoice: $e');
      throw Exception('Failed to load invoice: $e');
    }
  }
  
  Future<Map<String, dynamic>?> createCheckout(Map<String, dynamic> data) async {
    int retryCount = 0;
    const maxRetries = 3;
    
    while (retryCount < maxRetries) {
      try {
        final url = '${Base.url}v1/checkout';
        final jsonBody = jsonEncode(data);
        
        debugPrint('═══════════════════════════════════════════════════════════');
        debugPrint('📤 CREATE CHECKOUT REQUEST (Attempt ${retryCount + 1}/$maxRetries)');
        debugPrint('URL: $url');
        debugPrint('Body: $jsonBody');
        debugPrint('═══════════════════════════════════════════════════════════');
        
        final response = await post(
          url,
          jsonBody,
          headers: _getHeaders(),
        ).timeout(const Duration(seconds: 30));
        
        debugPrint('═══════════════════════════════════════════════════════════');
        debugPrint('📥 CREATE CHECKOUT RESPONSE');
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Body: ${response.body}');
        debugPrint('Has Error: ${response.hasError}');
        debugPrint('═══════════════════════════════════════════════════════════');
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (response.body is Map) {
            return response.body;
          } else if (response.body is String) {
            return json.decode(response.body);
          }
          return response.body;
        } else {
          throw Exception('Failed to create checkout: ${response.statusCode} - ${response.body}');
        }
        
      } catch (e) {
        retryCount++;
        debugPrint('❌ CreateCheckout error (Attempt $retryCount/$maxRetries): $e');
        
        if (retryCount >= maxRetries) {
          debugPrint('❌ Max retries reached. Giving up.');
          rethrow;
        }
        
        debugPrint('⏳ Waiting 2 seconds before retry...');
        await Future.delayed(const Duration(seconds: 2));
      }
    }
    
    throw Exception('Failed to create checkout after $maxRetries attempts');
  }
  
  Future<dynamic> batalkanPesanan(String noInvoice) async {
    try {
      final token = _getToken();
      
      final uri = Uri.parse('${Base.url}v1/transaksi-online/cancel');
      
      final request = http.MultipartRequest('POST', uri);
      
      request.headers.addAll({
        'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
        'author': 'Bearer $token',
        'device': 'mobile',
      });
      
      request.fields['no_invoice'] = noInvoice;
      
      debugPrint('📥 Batalkan Pesanan Request:');
      debugPrint('URL: $uri');
      debugPrint('Fields: ${request.fields}');
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      debugPrint('📥 Batalkan Pesanan Response Status: ${response.statusCode}');
      debugPrint('📥 Batalkan Pesanan Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        try {
          return json.decode(response.body);
        } catch (e) {
          debugPrint('Response body is not JSON, returning empty map');
          return {'status': true, 'message': 'Pesanan berhasil dibatalkan'};
        }
      } else {
        throw Exception('Failed to cancel order: ${response.statusCode}');
      }
      
    } catch (e) {
      debugPrint('❌ Error in batalkanPesanan: $e');
      rethrow;
    }
  }
}