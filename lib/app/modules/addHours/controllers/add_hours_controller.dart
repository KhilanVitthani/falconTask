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
  RxString noteString = "".obs;
  RxList<String> attachmentsList = <String>[].obs;
  RxList<String> saveAttachmentsList = <String>[].obs;
  RxBool autoFillHours = false.obs;
  RxBool showCalculate = false.obs;
  RxString totalWorkingHours = "0".obs;
  RxDouble totalAmount = 0.0.obs;
  RxDouble totalHours = 0.0.obs;

  amountCalculation({
    required DateTime checkIn,
    required DateTime checkOut,
    required DateTime breakTime,
  }) {
    showCalculate.value = true;
    Duration totalWorkingHour = checkOut.difference(checkIn);
    totalWorkingHour = totalWorkingHour -
        Duration(hours: breakTime.hour, minutes: breakTime.minute, seconds: 0);
    totalWorkingHours.value = format(totalWorkingHour);
    List<String> parts = totalWorkingHour.toString().split(':');
    int hours = int.tryParse(parts[0]) ?? 0;
    int minutes = int.tryParse(parts[1]) ?? 0;
    double seconds = double.tryParse(parts[2]) ?? 0.0;
    double total = hours + (minutes / 60.0) + (seconds / 3600.0);
    totalHours.value = total;
    double salary = totalHours * 100;
    totalAmount.value = salary;
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
}
