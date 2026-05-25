import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/models/riwayat_pelatihan_model.dart';
import 'package:mobile_supportyou/services/riwayat_pelatihan_service.dart';
import 'package:mobile_supportyou/views/detail_pelatihan_dibeli/screen.dart';

class RiwayatPelatihanController extends GetxController {
  final RiwayatPelatihanService _riwayatService = RiwayatPelatihanService();
  
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final pelatihanList = <PelatihanDibeli>[].obs;
  var currentPage = 0;
  var hasMoreData = true;
  final int limit = 10;
  
  final currentTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadPelatihanDibeli();
  }
  
  Future<void> loadPelatihanDibeli({bool reset = true}) async {
    if (reset) {
      currentPage = 0;
      hasMoreData = true;
      pelatihanList.clear();
      isLoading.value = true;
    }
    
    try {
      final result = await _riwayatService.getPelatihanDibeliPaginated(
        start: currentPage * limit,
        length: limit,
      );
      
      if (result.isEmpty) {
        hasMoreData = false;
      } else {
        if (reset) {
          pelatihanList.assignAll(result);
        } else {
          pelatihanList.addAll(result);
        }
        currentPage++;
        hasMoreData = result.length >= limit;
      }
      debugPrint('Loaded ${pelatihanList.length} purchased pelatihan');
    } catch (e) {
      debugPrint('Error loading pelatihan: $e');
      if (reset) pelatihanList.clear();
    } finally {
      if (reset) isLoading.value = false;
    }
  }
  
  Future<void> loadMore() async {
    if (!isLoadingMore.value && hasMoreData && !isLoading.value) {
      isLoadingMore.value = true;
      await loadPelatihanDibeli(reset: false);
      isLoadingMore.value = false;
    }
  }
  
  void changeTab(int index) {
    currentTab.value = index;
  }
  
  Future<void> refreshData() async {
    await loadPelatihanDibeli();
  }
  
  void goToDetail(PelatihanDibeli pelatihan) {
    Get.to(() => DetailPelatihanDibeliScreen(pelatihan: pelatihan));
  }
  
  void showKodeAksesDialog(String kodeAkses, String namaPelatihan) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Kode Akses',
          style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Kode akses untuk pelatihan:',
              style: Get.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              namaPelatihan,
              style: Get.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.withValues(alpha: 0.2)),
              ),
              child: SelectableText(
                kodeAkses,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _copyToClipboard(kodeAkses);
            },
            style: ElevatedButton.styleFrom(backgroundColor: primary),
            child: const Text('Salin'),
          ),
        ],
      ),
    );
  }
  
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Berhasil',
      'Kode akses disalin',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: success,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}