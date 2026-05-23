// lib/controllers/transaksi_ebook_controller.dart
import 'package:get/get.dart';
import 'package:mobile_supportyou/models/transaksi_model.dart';
import 'package:mobile_supportyou/services/transaksi_pelatihan_service.dart';

class TransaksiEbookController extends GetxController {
  final TransaksiPelatihanService _service = TransaksiPelatihanService();

  var transaksiPending = <Transaksi>[].obs;
  var transaksiExpired = <Transaksi>[].obs;
  var transaksiSelesai = <Transaksi>[].obs;
  var transaksiDibatalkan = <Transaksi>[].obs;

  var isLoadingPending = false.obs;
  var isLoadingExpired = false.obs;
  var isLoadingSelesai = false.obs;
  var isLoadingDibatalkan = false.obs;
  
  var errorPending = ''.obs;
  var errorExpired = ''.obs;
  var errorSelesai = ''.obs;
  var errorDibatalkan = ''.obs;

  Future<void> loadPending() async {
    print('🔄 Loading pending ebook transactions...');
    try {
      isLoadingPending.value = true;
      errorPending.value = '';
      final result = await _service.getTransaksiPelatihanByStatus("pending");
      final filteredResult = result.where((t) => t.transactionType == 'barang').toList();
      print('✅ Pending ebook transactions loaded: ${filteredResult.length}');
      transaksiPending.assignAll(filteredResult);
    } catch (e) {
      print('❌ Error loading pending: $e');
      errorPending.value = e.toString();
    } finally {
      isLoadingPending.value = false;
    }
  }

  Future<void> loadExpired() async {
    print('🔄 Loading expired ebook transactions...');
    try {
      isLoadingExpired.value = true;
      errorExpired.value = '';
      final result = await _service.getTransaksiPelatihanByStatus("expired");
      final filteredResult = result.where((t) => t.transactionType == 'barang').toList();
      print('✅ Expired ebook transactions loaded: ${filteredResult.length}');
      transaksiExpired.assignAll(filteredResult);
    } catch (e) {
      print('❌ Error loading expired: $e');
      errorExpired.value = e.toString();
    } finally {
      isLoadingExpired.value = false;
    }
  }

  Future<void> loadSelesai() async {
    print('🔄 Loading selesai ebook transactions...');
    try {
      isLoadingSelesai.value = true;
      errorSelesai.value = '';
      final result = await _service.getTransaksiPelatihanByStatus("selesai");
      final filteredResult = result.where((t) => t.transactionType == 'barang').toList();
      print('✅ Selesai ebook transactions loaded: ${filteredResult.length}');
      transaksiSelesai.assignAll(filteredResult);
    } catch (e) {
      print('❌ Error loading selesai: $e');
      errorSelesai.value = e.toString();
    } finally {
      isLoadingSelesai.value = false;
    }
  }

  Future<void> loadDibatalkan() async {
    print('🔄 Loading dibatalkan ebook transactions...');
    try {
      isLoadingDibatalkan.value = true;
      errorDibatalkan.value = '';
      final result = await _service.getTransaksiPelatihanByStatus("dibatalkan");
      final filteredResult = result.where((t) => t.transactionType == 'barang').toList();
      print('✅ Dibatalkan ebook transactions loaded: ${filteredResult.length}');
      transaksiDibatalkan.assignAll(filteredResult);
    } catch (e) {
      print('❌ Error loading dibatalkan: $e');
      errorDibatalkan.value = e.toString();
    } finally {
      isLoadingDibatalkan.value = false;
    }
  }
  
  void refreshAll() {
    print('🔄 Refreshing all ebook transactions...');
    loadPending();
    loadExpired();
    loadSelesai();
    loadDibatalkan();
  }
  
  void refreshPending() {
    loadPending();
  }
  
  void refreshExpired() {
    loadExpired();
  }
  
  void refreshSelesai() {
    loadSelesai();
  }
  
  void refreshDibatalkan() {
    loadDibatalkan();
  }
  
  @override
  void onInit() {
    super.onInit();
    print('🚀 TransaksiEbookController initialized');
    loadPending();
    loadExpired();
    loadSelesai();
    loadDibatalkan();
  }
}