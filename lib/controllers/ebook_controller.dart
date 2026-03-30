import 'package:get/get.dart';
import 'package:mobile_supportyou/models/ebook_model.dart';
import 'package:mobile_supportyou/services/ebook_service.dart';

class EbookController extends GetxController {
  final EbookService _service = EbookService();

  // 🔹 Home
  var ebookListHome = <Ebook>[].obs;
  var isLoadingHome = false.obs;
  int lengthHome = 10;
  int startHome = 0;

  // 🔹 Semua e-book
  var ebookListAll = <Ebook>[].obs;
  var isLoadingAll = false.obs;
  var isMoreLoadingAll = false.obs;
  int lengthAll = 10;
  int startAll = 0;
  bool hasMoreAll = true;

  // 🔹 Detail e-book
  var detailEbook = Rxn<Ebook>();
  var isLoadingDetail = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadEbookHome();
  }

  /// 🔹 Home: hanya load 10 item
  Future<void> loadEbookHome() async {
    isLoadingHome.value = true;
    startHome = 0;
    try {
      final result = await _service.getEbook(start: startHome, length: lengthHome);
      ebookListHome.assignAll(result);
    } catch (e) {
      print("Error loadEbookHome: $e");
    } finally {
      isLoadingHome.value = false;
    }
  }

  /// 🔹 Semua e-book: initial load
  Future<void> loadEbookAll() async {
    isLoadingAll.value = true;
    startAll = 0;
    try {
      final result = await _service.getEbook(start: startAll, length: lengthAll);
      ebookListAll.assignAll(result);
      hasMoreAll = result.length == lengthAll;
    } catch (e) {
      print("Error loadEbookAll: $e");
    } finally {
      isLoadingAll.value = false;
    }
  }

  /// 🔹 Semua e-book: lazy load
  Future<void> loadMoreEbookAll() async {
    if (isMoreLoadingAll.value || !hasMoreAll) return;
    isMoreLoadingAll.value = true;
    startAll += lengthAll;
    try {
      final result = await _service.getEbook(start: startAll, length: lengthAll);
      if (result.isEmpty) {
        hasMoreAll = false;
      } else {
        ebookListAll.addAll(result);
      }
    } catch (e) {
      print("Error loadMoreEbookAll: $e");
    } finally {
      isMoreLoadingAll.value = false;
    }
  }

  /// 🔹 Semua e-book: pencarian
  Future<void> searchEbookAll(String query) async {
    isLoadingAll.value = true;
    startAll = 0;
    try {
      final result = await _service.searchEbook(query, start: startAll, length: lengthAll);
      ebookListAll.assignAll(result);
      hasMoreAll = result.length == lengthAll;
    } catch (e) {
      print("Error searchEbookAll: $e");
    } finally {
      isLoadingAll.value = false;
    }
  }

  /// 🔹 Refresh semua e-book
  Future<void> refreshAll() async {
    ebookListAll.clear();
    await loadEbookAll();
  }

Future<void> loadDetailEbook(String id) async {
  isLoadingDetail.value = true;
  try {
    final result = await _service.getDetailEbook(id);
    detailEbook.value = result;
  } catch (e) {
    print("Error loadDetailEbook: $e");
    detailEbook.value = null;
  } finally {
    isLoadingDetail.value = false;
  }
}

}
