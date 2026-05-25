import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/models/ebook_dibeli_model.dart';
import 'package:mobile_supportyou/services/riwayat_ebook_service.dart';
import 'package:mobile_supportyou/views/detail_ebook_dibeli/screen.dart';

class RiwayatEbookController extends GetxController {
  final RiwayatEbookService _riwayatService = RiwayatEbookService();
  
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final ebookList = <EbookDibeli>[].obs;
  var currentPage = 0;
  var hasMoreData = true;
  final int limit = 10;

  @override
  void onInit() {
    super.onInit();
    loadEbookDibeli();
  }
  
  Future<void> loadEbookDibeli({bool reset = true}) async {
    if (reset) {
      currentPage = 0;
      hasMoreData = true;
      ebookList.clear();
      isLoading.value = true;
    }
    
    try {
      final result = await _riwayatService.getEbookDibeliPaginated(
        start: currentPage * limit,
        length: limit,
      );
      
      if (result.isEmpty) {
        hasMoreData = false;
      } else {
        if (reset) {
          ebookList.assignAll(result);
        } else {
          ebookList.addAll(result);
        }
        currentPage++;
        hasMoreData = result.length >= limit;
      }
      debugPrint('Loaded ${ebookList.length} purchased ebooks');
    } catch (e) {
      debugPrint('Error loading ebooks: $e');
      if (reset) ebookList.clear();
    } finally {
      if (reset) isLoading.value = false;
    }
  }
  
  Future<void> loadMore() async {
    if (!isLoadingMore.value && hasMoreData && !isLoading.value) {
      isLoadingMore.value = true;
      await loadEbookDibeli(reset: false);
      isLoadingMore.value = false;
    }
  }
  
  Future<void> refreshData() async {
    await loadEbookDibeli();
  }
  
  void goToDetail(EbookDibeli ebook) {
    Get.to(() => DetailEbookDibeliScreen(ebook: ebook));
  }
}