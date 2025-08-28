import 'package:get/get.dart';
class IdempiereHomeController extends GetxController {


  var currentIndex = 0.obs;


  void changePageIndex(int index, int lastIndex) {
    //print('index: $index');
    currentIndex.value = index;

    update();
  }



}