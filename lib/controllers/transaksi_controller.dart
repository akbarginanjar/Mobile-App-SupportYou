// lib/controllers/transaksi_controller.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_supportyou/services/payment_service.dart';

class TransaksiController extends GetxController {
  final PaymentService _paymentService = PaymentService();
  
  final isLoading = true.obs;
  final isError = false.obs;
  final invoiceData = Rx<Map<String, dynamic>?>(null);
  
  // Countdown timer
  final countdown = ''.obs;
  Timer? _timer; // 🔥 Tambahkan Timer untuk bisa dihentikan
  
  // Upload bukti transfer
  final selectedImage = Rx<File?>(null);
  final isUploading = false.obs;
  
  @override
  void onClose() {
    _timer?.cancel(); // 🔥 Hentikan timer saat controller ditutup
    super.onClose();
  }
  
  Future<void> getInvoice(int? idTransaksi) async {
    if (idTransaksi == null) return;
    
    isLoading.value = true;
    isError.value = false;
    
    // 🔥 Hentikan timer lama jika ada
    _timer?.cancel();
    countdown.value = '';
    
    try {
      final response = await _paymentService.getInvoice(idTransaksi);
      
      print('📥 getInvoice response: $response');
      
      if (response != null && response['id'] != null) {
        invoiceData.value = response;
        
        // 🔥 Hanya start countdown jika status_bayar belum lunas 
        // dan status bukan 'dibatalkan' atau 'expired'
        final status = response['status'];
        final statusBayar = response['status_bayar'];
        
        if (statusBayar == 'belum_lunas' && 
            status != 'dibatalkan' && 
            status != 'expired' &&
            response['expire_time'] != null) {
          startCountdown(response['expire_time']);
        }
      } else {
        isError.value = true;
      }
    } catch (e) {
      print('Error getting invoice: $e');
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
  
  void startCountdown(String expireTime) {
    // 🔥 Hentikan timer lama
    _timer?.cancel();
    
    final expireDateTime = DateTime.parse(expireTime);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final difference = expireDateTime.difference(now);
      
      if (difference.isNegative) {
        countdown.value = '00:00:00';
        timer.cancel();
        // Refresh invoice data after expired
        getInvoice(invoiceData.value?['id']);
        return;
      }
      
      final days = difference.inDays;
      final hours = difference.inHours.remainder(24);
      final minutes = difference.inMinutes.remainder(60);
      final seconds = difference.inSeconds.remainder(60);
      
      if (days > 0) {
        countdown.value = '$days hari, $hours jam, $minutes menit, $seconds detik';
      } else {
        countdown.value = '$hours jam, $minutes menit, $seconds detik';
      }
    });
  }
  
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Berhasil',
      'Berhasil disalin',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }
  
  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memilih gambar: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  void clearImage() {
    selectedImage.value = null;
  }
  
  Future<void> batalkanPesanan(String noInvoice) async {
    try {
      final response = await _paymentService.batalkanPesanan(noInvoice);
      
      if (response['status'] == true) {
        Get.snackbar(
          'Sukses',
          'Pesanan berhasil dibatalkan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        getInvoice(invoiceData.value?['id']);
      } else {
        Get.snackbar(
          'Gagal',
          response['message'] ?? 'Gagal membatalkan pesanan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}