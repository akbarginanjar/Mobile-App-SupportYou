import 'package:get/get.dart';
import 'package:mobile_supportyou/services/pelatihan_service.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';

class PelatihanController extends GetxController {
  final PelatihanService service = PelatihanService();

  var pelatihanList = <Pelatihan>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPelatihan();
  }

  void fetchPelatihan() async {
    isLoading.value = true;
    final result = await service.getPelatihan();
      for (var p in result) {
        print("DEBUG: id=${p.id}, nama=${p.nama}, deskripsi=${p.deskripsi}, cover=${p.cover}");
      }
    pelatihanList.assignAll(result);
    isLoading.value = false;
  }
}