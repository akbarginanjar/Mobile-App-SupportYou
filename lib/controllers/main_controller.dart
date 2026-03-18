import 'package:get/get.dart';

class MainController extends GetxController {
  int index = 0;

  void changeIndex(int value) {
    index = value;
    update();
  }
}