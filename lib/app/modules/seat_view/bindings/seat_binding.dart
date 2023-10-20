import 'package:beauty_salons_owner/app/modules/seat_view/controllers/seat_controller.dart';
import 'package:get/get.dart';



class SeatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SeatController>(
          () => SeatController(),
    );
  }
}
