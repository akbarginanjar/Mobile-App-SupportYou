// lib/controllers/pelatihan_controller.dart
import 'package:get/get.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/services/pelatihan_service.dart';

class PelatihanController extends GetxController {
  final PelatihanService _pelatihanService = PelatihanService();
  
  // Untuk Home
  final isLoadingHome = true.obs;
  final pelatihanListHome = <Pelatihan>[].obs;
  
  // Untuk Semua Pelatihan
  final isLoadingAll = true.obs;
  final isMoreLoadingAll = false.obs;
  final pelatihanListAll = <Pelatihan>[].obs;
  var currentStartAll = 0;
  var hasMoreDataAll = true;
  
  // Untuk Detail
  final isLoadingDetail = true.obs;
  final detailPelatihan = Rx<Pelatihan?>(null);
  
  // Untuk Kategori
  final isLoadingKategori = false.obs;
  final pelatihanByKategori = <Pelatihan>[].obs;
  
  // Untuk Search
  final isSearching = false.obs;
  final searchResult = <Pelatihan>[].obs;
  
  // ==================== HOME ====================
  Future<void> loadPelatihanHome() async {
    try {
      isLoadingHome.value = true;
      final result = await _pelatihanService.getPelatihanHome();
      pelatihanListHome.assignAll(result);
    } catch (e) {
      print('Error loading home pelatihan: $e');
    } finally {
      isLoadingHome.value = false;
    }
  }
  
  // ==================== SEMUA PELATIHAN ====================
  Future<void> loadPelatihanAll({bool reset = true}) async {
    if (reset) {
      currentStartAll = 0;
      hasMoreDataAll = true;
      pelatihanListAll.clear();
      isLoadingAll.value = true;
    }
    
    try {
      final result = await _pelatihanService.getPelatihanAll(
        start: currentStartAll,
        length: 10,
      );
      
      if (result.isEmpty) {
        hasMoreDataAll = false;
      } else {
        if (reset) {
          pelatihanListAll.assignAll(result);
        } else {
          pelatihanListAll.addAll(result);
        }
        currentStartAll += result.length;
        hasMoreDataAll = result.length >= 10;
      }
    } catch (e) {
      print('Error loading all pelatihan: $e');
    } finally {
      if (reset) {
        isLoadingAll.value = false;
      }
    }
  }
  
  Future<void> loadMorePelatihanAll() async {
    if (!isMoreLoadingAll.value && hasMoreDataAll) {
      isMoreLoadingAll.value = true;
      await loadPelatihanAll(reset: false);
      isMoreLoadingAll.value = false;
    }
  }
  
  // ==================== DETAIL ====================
  Future<void> loadDetailPelatihan(String slug) async {
    try {
      isLoadingDetail.value = true;
      final result = await _pelatihanService.getDetailPelatihan(slug);
      detailPelatihan.value = result;
    } catch (e) {
      print('Error loading detail pelatihan: $e');
      detailPelatihan.value = null;
    } finally {
      isLoadingDetail.value = false;
    }
  }
  
  // ==================== KATEGORI ====================
  Future<void> loadPelatihanByKategori(int kategoriId) async {
    try {
      isLoadingKategori.value = true;
      final result = await _pelatihanService.getPelatihanByKategori(kategoriId);
      pelatihanByKategori.assignAll(result);
    } catch (e) {
      print('Error loading pelatihan by kategori: $e');
      pelatihanByKategori.clear();
    } finally {
      isLoadingKategori.value = false;
    }
  }
  
  // ==================== SEARCH ====================
  Future<void> searchPelatihanAll(String query) async {
    if (query.isEmpty) {
      isSearching.value = false;
      searchResult.clear();
      return;
    }
    
    try {
      isSearching.value = true;
      final result = await _pelatihanService.searchPelatihan(query);
      searchResult.assignAll(result);
    } catch (e) {
      print('Error searching pelatihan: $e');
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
      loadPelatihanHome(),
      loadPelatihanAll(),
    ]);
  }
  
  Future<void> refreshHome() async {
    await loadPelatihanHome();
  }
  
  Future<void> refreshAllPelatihan() async {
    await loadPelatihanAll();
  }
}