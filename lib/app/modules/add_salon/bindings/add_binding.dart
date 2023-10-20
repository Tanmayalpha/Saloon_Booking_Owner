import 'package:get/get.dart';

import '../controllers/add_controller.dart';

class AddSalonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddSalonController>(
      () => AddSalonController(),
    );
  }
}
