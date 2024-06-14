import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:falcon_task/app/constant/sizeConstant.dart';
import 'package:falcon_task/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scroll_time_picker/scroll_time_picker.dart';
import '../../home/views/home_view.dart';
import '../controllers/add_hours_controller.dart';

class AddHoursView extends GetView<AddHoursController> {
  const AddHoursView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Add Hours'),
        ),
        body: Column(
          children: [
            _datePickerWidget(),
            Spacing.height(10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _dayTypeWidget(context: context),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Auto Fill hours',
                            style: TextStyle(
                              fontSize: MySize.getHeight(16),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          CupertinoSwitch(
                            value: controller.autoFillHours.value,
                            onChanged: (value) {
                              controller.autoFillHours.value = value;
                              if (value == true) {
                              } else {}
                            },
                            activeColor: Colors.yellow,
                          ),
                        ],
                      ),
                    ),
                    _checkInAndOutWidget(
                      context: context,
                      title: "Check In",
                      isFromCheckOut: false,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                    customWidget(
                      title: 'Break',
                      subTitle: "-",
                      autoFillHours: controller.autoFillHours.value,
                      icon: Icons.pause,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                    _checkInAndOutWidget(
                      context: context,
                      title: "Check Out",
                      isFromCheckOut: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkInAndOutWidget(
      {required BuildContext context,
      required String title,
      VoidCallback? onTap,
      bool isFromCheckOut = false}) {
    return customWidget(
      title: title,
      subTitle: (isNullEmptyOrFalse(!isFromCheckOut
              ? controller.checkInTime
              : controller.checkOutTime))
          ? "-"
          : DateFormat('hh:mm a').format(!isFromCheckOut
              ? controller.checkInTime!.value
              : controller.checkOutTime!.value),
      icon: Icons.access_time_rounded,
      autoFillHours: controller.autoFillHours.value,
      onTap: () {
        customBottomSheet(
          context: context,
          title: '$title Time',
          widget: selectTimePicker(
            context: context,
            selectedTime: controller.selectedTime,
            onPressed: () {
              if (isFromCheckOut) {
                controller.checkOutTime = controller.selectedTime.value.obs;
              } else {
                if (!isNullEmptyOrFalse(controller.checkOutTime)) {
                  DateTime checkOut = DateFormat('hh:mm a').parse(
                      DateFormat('hh:mm a')
                          .format(controller.checkOutTime!.value));
                  DateTime checkIn = DateFormat('hh:mm a').parse(
                      DateFormat('hh:mm a')
                          .format(controller.selectedTime.value));
                  if (checkOut.isBefore(checkIn) ||
                      checkOut.isAtSameMomentAs(checkIn)) {
                    getSnackBar(
                      context: context,
                      text: "Check In time should be before Check Out time",
                      duration: 1000,
                    );
                  } else {
                    controller.checkInTime = controller.selectedTime.value.obs;
                  }
                } else {
                  controller.checkInTime = controller.selectedTime.value.obs;
                }
              }
              controller.checkInTime?.refresh();
              controller.checkOutTime?.refresh();
              controller.selectedDate.refresh();
              controller.update();
              Get.back();
            },
          ),
        );
      },
    );
  }

  Widget _dayTypeWidget({required BuildContext context}) {
    return customWidget(
      title: 'Day Type',
      subTitle: controller.selectedDay.value,
      icon: Icons.calendar_month,
      onTap: () {
        customBottomSheet(
          context: context,
          title: "Day Type",
          widget: Column(
            children: List.generate(controller.dayTypeList.length, (index) {
              ListItemModel dayType = controller.dayTypeList[index];
              return Obx(
                () => InkWell(
                  onTap: () {
                    for (var element in controller.dayTypeList) {
                      element.isSelected!.value = false;
                    }
                    dayType.isSelected!.value = true;
                    controller.selectedDay.value = dayType.title!;
                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: (dayType.isSelected!.value)
                          ? Colors.yellow.withOpacity(0.7)
                          : Colors.transparent,
                    ),
                    child: ListTile(
                      title: Text(
                        dayType.title!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      trailing: !isNullEmptyOrFalse(dayType.isSelected!.value)
                          ? const Icon(
                              Icons.check,
                              color: Colors.black,
                            )
                          : null,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _datePickerWidget() {
    return Container(
      color: Colors.white,
      child: EasyInfiniteDateTimeLine(
        selectionMode: const SelectionMode.autoCenter(),
        firstDate: DateTime(2024),
        focusDate: controller.selectedDate.value,
        lastDate: DateTime(2024, 12, 31),
        onDateChange: (selectedDate) {
          controller.selectedDate.value = selectedDate;
        },
        headerBuilder: (context, date) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${EasyDateFormatter.fullMonthName(date, "en_US")} ${date.year}",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
        itemBuilder: (
          BuildContext context,
          DateTime date,
          bool isSelected,
          VoidCallback onTap,
        ) {
          return InkWell(
            onTap: onTap,
            child: CircleAvatar(
              backgroundColor: (isSelected)
                  ? Colors.yellow.withOpacity(0.7)
                  : Colors.transparent,
              radius: 25.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      EasyDateFormatter.shortDayName(date, "en_US"),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      date.day.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void customBottomSheet(
      {required BuildContext context,
      required String title,
      required Widget widget}) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      elevation: 0,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Spacing.height(20),
                widget,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget selectTimePicker(
      {required BuildContext context,
      required Rx<DateTime> selectedTime,
      required void Function()? onPressed}) {
    return Column(
      children: [
        SizedBox(
          height: MySize.getHeight(200),
          child: ScrollTimePicker(
            selectedTime: selectedTime.value,
            viewType: const [
              TimePickerViewType.hour,
              TimePickerViewType.minute,
            ],
            onDateTimeChanged: (DateTime value) {
              selectedTime.value = value;
            },
          ),
        ),
        Spacing.height(20),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: onPressed,
                child: Text('Save Time',
                    style: TextStyle(
                      fontSize: MySize.getHeight(16),
                      color: Colors.black,
                    )),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
