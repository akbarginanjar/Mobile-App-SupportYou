// lib/controllers/transaksi_pelatihan_controller.dart
import 'package:get/get.dart';
import 'package:mobile_supportyou/models/transaksi_model.dart';
import 'package:mobile_supportyou/services/transaksi_pelatihan_service.dart';

class TransaksiPelatihanController extends GetxController {
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
    print('🔄 Loading pending transactions...');
    try {
      isLoadingPending.value = true;
      errorPending.value = '';
      final result = await _service.getTransaksiPelatihanByStatus("pending");
      print('✅ Pending transactions loaded: ${result.length}');
      transaksiPending.assignAll(result);
    } catch (e) {
      print('❌ Error loading pending: $e');
      errorPending.value = e.toString();
    } finally {
      isLoadingPending.value = false;
    }
  }

  Future<void> loadExpired() async {
    print('🔄 Loading expired transactions...');
    try {
      isLoadingExpired.value = true;
      errorExpired.value = '';
      final result = await _service.getTransaksiPelatihanByStatus("expired");
      print('✅ Expired transactions loaded: ${result.length}');
      transaksiExpired.assignAll(result);
    } catch (e) {
      print('❌ Error loading expired: $e');
      errorExpired.value = e.toString();
    } finally {
      isLoadingExpired.value = false;
    }
  }

  Future<void> loadSelesai() async {
    print('🔄 Loading selesai transactions...');
    try {
      isLoadingSelesai.value = true;
      errorSelesai.value = '';
      final result = await _service.getTransaksiPelatihanByStatus("selesai");
      print('✅ Selesai transactions loaded: ${result.length}');
      transaksiSelesai.assignAll(result);
    } catch (e) {
      print('❌ Error loading selesai: $e');
      errorSelesai.value = e.toString();
    } finally {
      isLoadingSelesai.value = false;
    }
  }

  Future<void> loadDibatalkan() async {
    print('🔄 Loading dibatalkan transactions...');
    try {
      isLoadingDibatalkan.value = true;
      errorDibatalkan.value = '';
      final result = await _service.getTransaksiPelatihanByStatus("dibatalkan");
      print('✅ Dibatalkan transactions loaded: ${result.length}');
      transaksiDibatalkan.assignAll(result);
    } catch (e) {
      print('❌ Error loading dibatalkan: $e');
      errorDibatalkan.value = e.toString();
    } finally {
      isLoadingDibatalkan.value = false;
    }
  }
  
  void refreshAll() {
    print('🔄 Refreshing all transactions...');
    loadPending();
    loadExpired();
    loadSelesai();
    loadDibatalkan();
  }
  
  @override
  void onInit() {
    super.onInit();
    print('🚀 TransaksiPelatihanController initialized');
    loadPending();
    loadExpired();
    loadSelesai();
    loadDibatalkan();
  }
}