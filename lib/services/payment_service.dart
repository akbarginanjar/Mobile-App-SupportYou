// lib/services/payment_service.dart
import 'package:get/get.dart';
import 'package:mobile_supportyou/utils/base.dart';

class PaymentService extends GetConnect {
  // 🔹 Ambil metode pembayaran
  Future<dynamic> getPaymentMethods() async {
    final response = await get(
      '${Base.url}v1/p-method',
      headers: {
        'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
        'device': 'mobile',
      },
    );

    if (response.statusCode == 200) {
      print("✅ getPaymentMethods success: ${response.statusCode}");
      return response.body;
    } else {
      print("❌ Error getPaymentMethods: ${response.statusCode} - ${response.body}");
      throw Exception('Failed to load payment methods: ${response.statusCode}');
    }
  }

  // 🔹 Ambil biaya transaksi
  Future<dynamic> getTransactionFees() async {
    final response = await get(
      '${Base.url}v1/get-transaction-fee',
      headers: {
        'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
        'device': 'mobile',
      },
    );

    if (response.statusCode == 200) {
      print("✅ getTransactionFees success: ${response.statusCode}");
      return response.body;
    } else {
      print("❌ Error getTransactionFees: ${response.statusCode} - ${response.body}");
      throw Exception('Failed to load transaction fees: ${response.statusCode}');
    }
  }

  // 🔹 Ambil daftar diskon yang tersedia
  Future<dynamic> getAvailableDiscounts() async {
    final response = await get(
      '${Base.url}v1/get-available-discounts',
      headers: {
        'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
        'device': 'mobile',
      },
    );

    if (response.statusCode == 200) {
      print("✅ getAvailableDiscounts success: ${response.statusCode}");
      return response.body;
    } else {
      print("❌ Error getAvailableDiscounts: ${response.statusCode} - ${response.body}");
      return []; // Return empty list instead of throwing
    }
  }

  // 🔹 Buat checkout / pesanan
  Future<dynamic> createCheckout(Map<String, dynamic> data) async {
    final response = await post(
      '${Base.url}v1/checkout',
      data,
      headers: {
        'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
        'device': 'mobile',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ createCheckout success: ${response.statusCode}");
      return response.body;
    } else {
      print("❌ Error createCheckout: ${response.statusCode} - ${response.body}");
      throw Exception('Failed to create checkout: ${response.statusCode}');
    }
  }
}