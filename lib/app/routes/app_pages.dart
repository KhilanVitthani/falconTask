import 'package:get/get.dart';

import '../modules/addHours/bindings/add_hours_binding.dart';
import '../modules/addHours/views/add_hours_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADD_HOURS,
      page: () => const AddHoursView(),
      binding: AddHoursBinding(),
    ),
  ];
}
