import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/services/pelatihan_service.dart';

class PelatihanSearchController extends GetxController {
  final PelatihanService _pelatihanService = PelatihanService();
  
  var isLoading = false.obs;
  var pelatihanList = <Pelatihan>[].obs;
  
  var searchQuery = ''.obs;
  var selectedSort = 'popular'.obs;
  var selectedKategoriId = Rx<int?>(null);
  var selectedModes = <String>[].obs;
  var selectedPrices = <String>[].obs;
  
  final List<String> sortOptions = [
    'popular',
    'newest',
    'price_asc',
    'price_desc',
  ];
  
  final List<String> modeOptions = [
    'online',
    'offline',
  ];
  
  final List<String> priceOptions = [
    'free',
    'paid',
  ];
  
  String getSortDisplayName(String sort) {
    switch (sort) {
      case 'popular':
        return 'Paling Populer';
      case 'newest':
        return 'Terbaru';
      case 'price_asc':
        return 'Harga Terendah';
      case 'price_desc':
        return 'Harga Tertinggi';
      default:
        return 'Paling Populer';
    }
  }
  
  String getModeDisplayName(String mode) {
    switch (mode) {
      case 'online':
        return 'Online';
      case 'offline':
        return 'Offline';
      default:
        return mode;
    }
  }
  
  String getPriceDisplayName(String price) {
    switch (price) {
      case 'free':
        return 'Gratis';
      case 'paid':
        return 'Berbayar';
      default:
        return price;
    }
  }
  
  void setSearchQuery(String query) {
    searchQuery.value = query;
  }
  
  void setSort(String sort) {
    selectedSort.value = sort;
  }
  
  void setKategoriId(int? id) {
    selectedKategoriId.value = id;
  }
  
  void toggleMode(String mode) {
    if (selectedModes.contains(mode)) {
      selectedModes.remove(mode);
    } else {
      selectedModes.add(mode);
    }
  }
  
  void togglePrice(String price) {
    if (selectedPrices.contains(price)) {
      selectedPrices.remove(price);
    } else {
      selectedPrices.add(price);
    }
  }
  
  void setModes(List<String> modes) {
    selectedModes.assignAll(modes);
  }
  
  void setPrices(List<String> prices) {
    selectedPrices.assignAll(prices);
  }
  
  void resetFilters() {
    selectedSort.value = 'popular';
    selectedKategoriId.value = null;
    selectedModes.clear();
    selectedPrices.clear();
    searchQuery.value = '';
  }
  
  Future<void> search() async {
    isLoading.value = true;
    
    try {
      final result = await _pelatihanService.getPelatihanWithFilters(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        sort: selectedSort.value,
        kategoriId: selectedKategoriId.value,
        modes: selectedModes.isEmpty ? null : selectedModes,
        prices: selectedPrices.isEmpty ? null : selectedPrices,
        start: 0,
        length: 50,
      );
      pelatihanList.value = result;
      debugPrint('🔍 Search completed - found ${result.length} items');
    } catch (e) {
      debugPrint('❌ Error searching: $e');
      pelatihanList.clear();
    } finally {
      isLoading.value = false;
    }
  }
  
  void clearSearch() {
    searchQuery.value = '';
    search();
  }
  
  void loadInitialData() {
    debugPrint('🔄 Loading initial data...');
    search();
  }
  Future<void> refreshWithCurrentFilters() async {
    debugPrint('🔄 Refreshing with current filters');
    await search();
  }
}