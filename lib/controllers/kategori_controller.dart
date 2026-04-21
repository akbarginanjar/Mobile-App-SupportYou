// lib/controllers/kategori_controller.dart
import 'package:get/get.dart';
import 'package:mobile_supportyou/models/kategori_model.dart';
import 'package:mobile_supportyou/services/kategori_service.dart';

class KategoriController extends GetxController {
  final KategoriService _service = KategoriService();
  
  final isLoading = true.obs;
  final kategoriList = <KategoriModel>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadKategori();
  }
  
  Future<void> loadKategori() async {
    try {
      isLoading.value = true;
      final result = await _service.getKategori();
      kategoriList.assignAll(result);
    } catch (e) {
      print('Error loading categories: $e');
    } finally {
      isLoading.value = false;
    }
  }
}