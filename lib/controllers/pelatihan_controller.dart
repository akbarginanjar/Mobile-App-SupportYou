// lib/controllers/pelatihan_controller.dart (perbarui)
import 'package:get/get.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/services/pelatihan_service.dart';
import 'package:mobile_supportyou/services/riwayat_pelatihan_service.dart';
import 'package:mobile_supportyou/controllers/purchased_batch_controller.dart';

class PelatihanController extends GetxController {
  final PelatihanService _pelatihanService = PelatihanService();
  final RiwayatPelatihanService _riwayatService = RiwayatPelatihanService();
  final PurchasedBatchController _purchasedBatchController = Get.find<PurchasedBatchController>();
  
  final isLoadingHome = true.obs;
  final pelatihanListHome = <Pelatihan>[].obs;
  
  final isLoadingAll = true.obs;
  final isMoreLoadingAll = false.obs;
  final pelatihanListAll = <Pelatihan>[].obs;
  var currentStartAll = 0;
  var hasMoreDataAll = true;
  
  final isLoadingDetail = true.obs;
  final detailPelatihan = Rx<Pelatihan?>(null);
  
  final isLoadingKategori = false.obs;
  final pelatihanByKategori = <Pelatihan>[].obs;
  
  final isSearching = false.obs;
  final searchResult = <Pelatihan>[].obs;

  final hasAccess = false.obs;
  final purchasedPelatihanIds = <int>[].obs;
  final purchasedBatchIds = <int>{}.obs;
  
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
  
  Future<void> loadPurchasedPelatihanIds() async {
    try {
      final purchased = await _riwayatService.getPelatihanDibeli();
      purchasedPelatihanIds.assignAll(purchased.map((e) => e.id));
    } catch (e) {
      print('Error loading purchased pelatihan: $e');
      purchasedPelatihanIds.clear();
    }
  }
  
  Future<void> loadDetailPelatihan(String slug) async {
    try {
      isLoadingDetail.value = true;
      await loadPurchasedPelatihanIds();
      final result = await _pelatihanService.getDetailPelatihan(slug);
      detailPelatihan.value = result;
      if (result != null) {
        hasAccess.value = purchasedPelatihanIds.contains(result.id);
        await _purchasedBatchController.loadPurchasedBatchesForPelatihan(result.id);
        purchasedBatchIds.assignAll(_purchasedBatchController.getPurchasedBatchIds(result.id));
      }
    } catch (e) {
      print('Error loading detail pelatihan: $e');
      detailPelatihan.value = null;
    } finally {
      isLoadingDetail.value = false;
    }
  }
  
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