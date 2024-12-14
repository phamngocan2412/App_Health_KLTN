import 'package:get/get.dart';
import 'package:vlu_project_1/core/utils/network.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
  }
}
