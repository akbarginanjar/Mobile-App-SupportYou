import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // RxList<BannerModel> bannerList = <BannerModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBanner();
  }

  Future<void> loadBanner() async {
    isLoading.value = true;


    // try {
    //   final res = await HomeService().getBanner(params);
    //   if (res.statusCode == 200) {
    //     final List data = res.body['data'];
    //     bannerList.value = data.map((e) => BannerModel.fromJson(e)).toList();
    //   }
    // } finally {
    //   isLoading.value = false;
    // }
  }
}