import 'package:get/get.dart';
import 'package:mobile_supportyou/services/pelatihan_service.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';

class PelatihanController extends GetxController {
  final PelatihanService _service = PelatihanService();

  // 🔹 Home
  var pelatihanListHome = <Pelatihan>[].obs;
  var isLoadingHome = false.obs;
  int lengthHome = 10;
  int startHome = 0;

  // 🔹 Semua pelatihan
  var pelatihanListAll = <Pelatihan>[].obs;
  var isLoadingAll = false.obs;
  var isMoreLoadingAll = false.obs;
  int lengthAll = 5;
  int startAll = 0;
  bool hasMoreAll = true;

  // 🔹 Detail pelatihan
  var detailPelatihan = Rxn<Pelatihan>();
  var isLoadingDetail = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPelatihanHome();
  }

  /// 🔹 Home: hanya load 10 item
  Future<void> loadPelatihanHome() async {
    isLoadingHome.value = true;
    startHome = 0;
    try {
      final result = await _service.getPelatihan(start: startHome, length: lengthHome);
      pelatihanListHome.assignAll(result);
    } catch (e) {
      print("Error loadPelatihanHome: $e");
    } finally {
      isLoadingHome.value = false;
    }
  }

  /// 🔹 Semua pelatihan: initial load
  Future<void> loadPelatihanAll() async {
    isLoadingAll.value = true;
    startAll = 0;
    try {
      final result = await _service.getPelatihan(start: startAll, length: lengthAll);
      pelatihanListAll.assignAll(result);
      hasMoreAll = result.length == lengthAll;
    } catch (e) {
      print("Error loadPelatihanAll: $e");
    } finally {
      isLoadingAll.value = false;
    }
  }

  /// 🔹 Semua pelatihan: lazy load
  Future<void> loadMorePelatihanAll() async {
    if (isMoreLoadingAll.value || !hasMoreAll) return;
    isMoreLoadingAll.value = true;
    startAll += lengthAll;
    try {
      final result = await _service.getPelatihan(start: startAll, length: lengthAll);
      if (result.isEmpty) {
        hasMoreAll = false;
      } else {
        pelatihanListAll.addAll(result);
      }
    } catch (e) {
      print("Error loadMorePelatihanAll: $e");
    } finally {
      isMoreLoadingAll.value = false;
    }
  }

  /// 🔹 Semua pelatihan: pencarian
  Future<void> searchPelatihanAll(String query) async {
    isLoadingAll.value = true;
    startAll = 0;
    try {
      final result = await _service.searchPelatihan(query, start: startAll, length: lengthAll);
      pelatihanListAll.assignAll(result);
      hasMoreAll = result.length == lengthAll;
    } catch (e) {
      print("Error searchPelatihanAll: $e");
    } finally {
      isLoadingAll.value = false;
    }
  }

  /// 🔹 Refresh semua pelatihan
  Future<void> refreshAll() async {
    pelatihanListAll.clear();
    await loadPelatihanAll();
  }

  /// 🔹 Detail pelatihan
  Future<void> loadDetailPelatihan(String id) async {
    isLoadingDetail.value = true;
    try {
      final result = await _service.getDetailPelatihan(id);
      detailPelatihan.value = result;
    } catch (e) {
      print("Error loadDetailPelatihan: $e");
      detailPelatihan.value = null;
    } finally {
      isLoadingDetail.value = false;
    }
  }
}