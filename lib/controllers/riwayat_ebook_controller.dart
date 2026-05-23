// lib/controllers/riwayat_ebook_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/models/ebook_dibeli_model.dart';
import 'package:mobile_supportyou/services/riwayat_ebook_service.dart';
import 'package:mobile_supportyou/views/detail_ebook_dibeli/screen.dart';

class RiwayatEbookController extends GetxController {
  final RiwayatEbookService _riwayatService = RiwayatEbookService();
  
  final isLoading = false.obs;
  final ebookList = <EbookDibeli>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadEbookDibeli();
  }
  
  Future<void> loadEbookDibeli() async {
    try {
      isLoading.value = true;
      final result = await _riwayatService.getEbookDibeli();
      ebookList.assignAll(result);
      debugPrint('Loaded ${result.length} purchased ebooks');
    } catch (e) {
      debugPrint('Error loading ebooks: $e');
      ebookList.clear();
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> refreshData() async {
    await loadEbookDibeli();
  }
  
  void goToDetail(EbookDibeli ebook) {
    Get.to(() => DetailEbookDibeliScreen(ebook: ebook));
  }
  
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Berhasil',
      'Berhasil disalin',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}