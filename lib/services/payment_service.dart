// lib/services/payment_service.dart
import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:mobile_supportyou/utils/base.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class PaymentService extends GetConnect {
  final GetStorage _storage = GetStorage();
  
  @override
  void onInit() {
    super.onInit();
    httpClient.timeout = const Duration(seconds: 30);
    httpClient.defaultContentType = "application/json";
  }
  
  // Helper untuk mendapatkan token
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
  
  // Helper untuk headers
  Map<String, String> _getHeaders() {
    final token = _getToken();
    final headers = {
      'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
      'device': 'mobile',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null && token.isNotEmpty) {
      headers['author'] = 'bearer $token';
    }
    
    return headers;
  }
  
  // ==================== GET REQUESTS ====================
  
  // 🔹 Ambil metode pembayaran
  Future<dynamic> getPaymentMethods() async {
    try {
      final response = await get(
        '${Base.url}v1/p-method',
        headers: _getHeaders(),
      );
      return response.body;
    } catch (e) {
      throw Exception('Failed to load payment methods: $e');
    }
  }
  
  // 🔹 Ambil biaya transaksi
  Future<dynamic> getTransactionFees() async {
    try {
      final response = await get(
        '${Base.url}v1/get-transaction-fee',
        headers: _getHeaders(),
      );
      return response.body;
    } catch (e) {
      throw Exception('Failed to load transaction fees: $e');
    }
  }
  
  // 🔹 Ambil daftar diskon yang tersedia
  Future<dynamic> getAvailableDiscounts() async {
    try {
      final response = await get(
        '${Base.url}v1/get-available-discounts',
        headers: _getHeaders(),
      );
      return response.body;
    } catch (e) {
      return [];
    }
  }
  
  // 🔹 Ambil detail invoice berdasarkan ID transaksi
  Future<dynamic> getInvoice(int id) async {
    try {
      final response = await get(
        '${Base.url}v1/view-invoice/$id',
        headers: _getHeaders(),
      );
      
      print('📥 RESPONSE: Invoice');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');
      
      return response.body;
    } catch (e) {
      print('❌ Error getInvoice: $e');
      throw Exception('Failed to load invoice: $e');
    }
  }
  
  // ==================== POST REQUESTS ====================
  
  // 🔹 Buat checkout / pesanan
  Future<dynamic> createCheckout(Map<String, dynamic> data) async {
    try {
      final response = await post(
        '${Base.url}v1/checkout',
        data,
        headers: _getHeaders(),
      );
      
      print('📥 RESPONSE: Checkout');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        throw Exception('Failed to create checkout: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
  
  // 🔹 Batalkan pesanan
  Future<dynamic> batalkanPesanan(String noInvoice) async {
    try {
      final response = await post(
        '${Base.url}v1/batalkan-pesanan',
        {'no_invoice': noInvoice},
        headers: _getHeaders(),
      );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }
}