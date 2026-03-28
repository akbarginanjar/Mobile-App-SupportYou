import 'package:get/get.dart';
import 'package:mobile_supportyou/models/ebook_model.dart';
import 'package:mobile_supportyou/services/ebook_service.dart';

class EbookController extends GetxController {
  // List utama
  var ebookList = <Ebook>[].obs;

  // State loading
  var isLoadingHome = false.obs;
  var isLoadingAll = false.obs;
  var isMoreLoadingAll = false.obs;

  // Konfigurasi untuk home
  int lengthHome = 10;
  int startHome = 0;

  // Konfigurasi untuk semua e-book (lazy load)
  int lengthAll = 10;
  int startAll = 0;
  bool hasMoreAll = true;

  final EbookService _service = EbookService();

  @override
  void onInit() {
    super.onInit();
    loadEbookHome();
  }

  /// 🔹 Load untuk Home (hanya sejumlah tertentu)
  Future<void> loadEbookHome() async {
    isLoadingHome.value = true;
    startHome = 0;
    try {
      final result = await _service.getEbook(start: startHome, length: lengthHome);
      ebookList.assignAll(result);
    } catch (e) {
      print("Error fetch ebook home: $e");
    } finally {
      isLoadingHome.value = false;
    }
  }

  /// 🔹 Load untuk Semua E-book (initial)
  Future<void> loadEbookAll() async {
    isLoadingAll.value = true;
    startAll = 0;
    try {
      final result = await _service.getEbook(start: startAll, length: lengthAll);
      ebookList.assignAll(result);
      hasMoreAll = result.length == lengthAll;
    } catch (e) {
      print("Error fetch ebook all: $e");
    } finally {
      isLoadingAll.value = false;
    }
  }

  /// 🔹 Lazy load untuk Semua E-book
  Future<void> loadMoreEbookAll() async {
    if (isMoreLoadingAll.value || !hasMoreAll) return;

    isMoreLoadingAll.value = true;
    startAll += lengthAll;

    try {
      final result = await _service.getEbook(start: startAll, length: lengthAll);
      if (result.isEmpty) {
        hasMoreAll = false;
      } else {
        ebookList.addAll(result);
      }
    } catch (e) {
      print("Error load more ebook all: $e");
    } finally {
      isMoreLoadingAll.value = false;
    }
  }
}
