import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';

class AddHoursController extends GetxController {
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxList<ListItemModel> dayTypeList = <ListItemModel>[
    ListItemModel(isSelected: true.obs, title: "Full Day"),
    ListItemModel(isSelected: false.obs, title: "Sick"),
    ListItemModel(isSelected: false.obs, title: "Leave"),
  ].obs;
  Rx<DateTime> selectedTime = DateTime.now().obs;
  Rx<DateTime>? checkInTime;
  Rx<DateTime>? checkOutTime;
  RxString breakTime = "".obs;

  Rx<DateTime> breakSelectedTime = DateTime.parse("2021-08-16 00:00:00").obs;
  Rx<TextEditingController> descriptionController = TextEditingController().obs;
  RxString selectedDay = "Full Day".obs;
  RxList<String> attachmentsList = <String>[].obs;
  RxList<String> saveAttachmentsList = <String>[].obs;
  RxBool autoFillHours = false.obs;
}
