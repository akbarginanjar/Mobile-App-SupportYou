// lib/controllers/ebook_controller.dart
import 'package:get/get.dart';
import 'package:mobile_supportyou/models/ebook_model.dart';
import 'package:mobile_supportyou/services/ebook_service.dart';

class EbookController extends GetxController {
  final EbookService _ebookService = EbookService();
  
  // Untuk Home
  final isLoadingHome = true.obs;
  final ebookListHome = <Ebook>[].obs;
  
  // Untuk Semua Ebook
  final isLoadingAll = true.obs;
  final isMoreLoadingAll = false.obs;
  final ebookListAll = <Ebook>[].obs;
  var currentStartAll = 0;
  var hasMoreDataAll = true;
  
  // Untuk Detail
  final isLoadingDetail = true.obs;
  final detailEbook = Rx<Ebook?>(null);
  
  // Untuk Search
  final isSearching = false.obs;
  final searchResult = <Ebook>[].obs;
  
  // ==================== HOME ====================
  Future<void> loadEbookHome() async {
    try {
      isLoadingHome.value = true;
      final result = await _ebookService.getEbook(start: 0, length: 10);
      ebookListHome.assignAll(result);
    } catch (e) {
      print('Error loading home ebook: $e');
    } finally {
      isLoadingHome.value = false;
    }
  }
  
  // ==================== SEMUA EBOOK ====================
  Future<void> loadEbookAll({bool reset = true}) async {
    if (reset) {
      currentStartAll = 0;
      hasMoreDataAll = true;
      ebookListAll.clear();
      isLoadingAll.value = true;
    }
    
    try {
      final result = await _ebookService.getEbook(
        start: currentStartAll,
        length: 10,
      );
      
      if (result.isEmpty) {
        hasMoreDataAll = false;
      } else {
        if (reset) {
          ebookListAll.assignAll(result);
        } else {
          ebookListAll.addAll(result);
        }
        currentStartAll += result.length;
        hasMoreDataAll = result.length >= 10;
      }
    } catch (e) {
      print('Error loading all ebook: $e');
    } finally {
      if (reset) {
        isLoadingAll.value = false;
      }
    }
  }
  
  Future<void> loadMoreEbookAll() async {
    if (!isMoreLoadingAll.value && hasMoreDataAll) {
      isMoreLoadingAll.value = true;
      await loadEbookAll(reset: false);
      isMoreLoadingAll.value = false;
    }
  }
  
  // ==================== DETAIL ====================
  Future<void> loadDetailEbook(String slug) async {
    try {
      isLoadingDetail.value = true;
      final result = await _ebookService.getDetailEbook(slug);
      detailEbook.value = result;
    } catch (e) {
      print('Error loading detail ebook: $e');
      detailEbook.value = null;
    } finally {
      isLoadingDetail.value = false;
    }
  }
  
  // ==================== SEARCH ====================
  Future<void> searchEbookAll(String query) async {
    if (query.isEmpty) {
      isSearching.value = false;
      searchResult.clear();
      return;
    }
    
    try {
      isSearching.value = true;
      final result = await _ebookService.searchEbook(query);
      searchResult.assignAll(result);
    } catch (e) {
      print('Error searching ebook: $e');
      searchResult.clear();
    } finally {
      isSearching.value = false;
    }
  }
  
  void clearSearch() {
    searchResult.clear();
    isSearching.value = false;
  }
  
  // ==================== REFRESH ====================
  Future<void> refreshAll() async {
    await Future.wait([
      loadEbookHome(),
      loadEbookAll(),
    ]);
  }
  
  Future<void> refreshHome() async {
    await loadEbookHome();
  }
  
  Future<void> refreshAllEbook() async {
    await loadEbookAll();
  }
}