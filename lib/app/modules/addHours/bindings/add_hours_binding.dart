import 'package:get/get.dart';

import '../controllers/add_hours_controller.dart';

class AddHoursBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddHoursController>(
      () => AddHoursController(),
    );
  }
}
