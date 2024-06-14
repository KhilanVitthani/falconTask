import 'dart:io';

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:falcon_task/app/constant/sizeConstant.dart';
import 'package:falcon_task/app/model/timeDataModel.dart';
import 'package:falcon_task/app/modules/home/controllers/home_controller.dart';
import 'package:falcon_task/app/service/CameraService.dart';
import 'package:falcon_task/app/service/databaseService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scroll_time_picker/scroll_time_picker.dart';

import '../../../../main.dart';
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
                                DateTime now = DateTime.now();
                                controller.checkInTime = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  7,
                                ).obs;
                                controller.checkOutTime = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  16,
                                ).obs;
                                controller.breakTime.value = '01:00';
                                DateTime checkIn = DateFormat('HH:mm').parse(
                                  DateFormat('HH:mm')
                                      .format(controller.checkInTime!.value),
                                );
                                DateTime checkOut = DateFormat('HH:mm').parse(
                                  DateFormat('HH:mm')
                                      .format(controller.checkOutTime!.value),
                                );
                                DateTime breakTime = DateFormat('HH:mm')
                                    .parse(controller.breakTime.value);
                                controller.amountCalculation(
                                    checkIn: checkIn,
                                    checkOut: checkOut,
                                    breakTime: breakTime);
                              } else {
                                controller.showCalculate.value = false;
                                controller.checkInTime = null;
                                controller.checkOutTime = null;
                                controller.breakTime.value = '';
                                controller.totalWorkingHours.value = '0';
                                controller.totalAmount.value = 0.0;
                                controller.totalHours.value = 0.0;
                              }
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
                      subTitle: (isNullEmptyOrFalse(controller.breakTime.value))
                          ? "-"
                          : controller.breakTime.value,
                      autoFillHours: controller.autoFillHours.value,
                      icon: Icons.pause,
                      onTap: () {
                        if (isNullEmptyOrFalse(controller.checkInTime)) {
                          getSnackBar(
                            context: context,
                            text: 'Please select Check In Time first',
                          );
                        } else {
                          customBottomSheet(
                            context: context,
                            title: 'Break Time',
                            widget: selectTimePicker(
                              context: context,
                              selectedTime: controller.breakSelectedTime,
                              onPressed: () {
                                controller.breakTime.value = DateFormat('HH:mm')
                                    .format(controller.breakSelectedTime.value);
                                if (!isNullEmptyOrFalse(
                                    controller.checkOutTime)) {
                                  DateTime checkIn = DateFormat('HH:mm a')
                                      .parse(DateFormat('HH:mm a').format(
                                          controller.checkInTime!.value));
                                  String checkOutTime = DateFormat('HH:mm a')
                                      .format(controller.checkOutTime!.value);
                                  DateTime checkOut =
                                      DateFormat('HH:mm a').parse(checkOutTime);
                                  DateTime breakTime = DateFormat('HH:mm')
                                      .parse(controller.breakTime.value);
                                  DateTime totalCheckInAndBreakTime =
                                      checkIn.add(Duration(
                                          hours: breakTime.hour,
                                          minutes: breakTime.minute));
                                  if (totalCheckInAndBreakTime
                                      .isBefore(checkOut)) {
                                    controller.breakTime.refresh();
                                    controller.amountCalculation(
                                      checkIn: checkIn,
                                      checkOut: checkOut,
                                      breakTime: breakTime,
                                    );
                                  } else {
                                    getSnackBar(
                                      context: context,
                                      text:
                                          'Your break time is more than your working hours',
                                    );
                                  }
                                }
                                Get.back();
                              },
                            ),
                          );
                        }
                      },
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
                    Spacing.height(20),
                    customWidget(
                      title: 'Note (Optional)',
                      subTitle: controller.noteString.value,
                      icon: Icons.note_add,
                      onTap: () {
                        customBottomSheet(
                          context: context,
                          title: 'Note',
                          widget: Column(
                            children: [
                              TextField(
                                controller:
                                    controller.descriptionController.value,
                                maxLines: 3,
                                minLines: 1,
                                decoration: InputDecoration(
                                  hintText: 'Enter your note here',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color:
                                              Colors.yellow.withOpacity(0.7))),
                                ),
                              ),
                              Spacing.height(20),
                              InkWell(
                                onTap: () {
                                  controller.noteString.value = controller
                                      .descriptionController.value.text;
                                  Get.back();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    width: double.infinity,
                                    child: Text(
                                      "Done",
                                      style: TextStyle(
                                        fontSize: MySize.getHeight(16),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                    customWidget(
                      title: 'Attachment (Optional)',
                      subTitle: (controller.saveAttachmentsList.isEmpty)
                          ? "-"
                          : '${controller.saveAttachmentsList.length} File',
                      icon: Icons.attach_file,
                      onTap: () {
                        controller.attachmentsList.clear();
                        controller.attachmentsList
                            .addAll(controller.saveAttachmentsList);
                        customBottomSheet(
                          context: context,
                          title: 'Attachments',
                          widget: Column(
                            children: [
                              Obx(() {
                                return SizedBox(
                                  height: MySize.getHeight(100),
                                  width: MySize.safeWidth,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Row(
                                            children: List.generate(
                                                controller.attachmentsList
                                                    .length, (index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Stack(
                                              alignment: Alignment.topRight,
                                              children: [
                                                Container(
                                                  height: MySize.getHeight(100),
                                                  width: MySize.getHeight(100),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: Colors.grey.shade200,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: Image.file(
                                                      File(controller
                                                              .attachmentsList[
                                                          index]),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    child: InkWell(
                                                  onTap: () {
                                                    controller.attachmentsList
                                                        .removeAt(index);
                                                    controller.attachmentsList
                                                        .refresh();
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      color: Colors.grey,
                                                    ),
                                                    child: Icon(
                                                      Icons.close_sharp,
                                                      color: Colors.white,
                                                      size:
                                                          MySize.getHeight(15),
                                                    ),
                                                  ),
                                                )),
                                              ],
                                            ),
                                          );
                                        })),
                                        InkWell(
                                          onTap: () {
                                            showCupertinoModalPopup(
                                              barrierDismissible: true,
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CupertinoActionSheet(
                                                actions: <CupertinoActionSheetAction>[
                                                  CupertinoActionSheetAction(
                                                    child: const Text('Camera',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors
                                                                .blueAccent)),
                                                    onPressed: () {
                                                      openCamera()
                                                          .then((value) {
                                                        if (value != null) {
                                                          controller
                                                              .attachmentsList
                                                              .add(value.path);
                                                          controller
                                                              .attachmentsList
                                                              .refresh();
                                                        }
                                                      });
                                                      Navigator.pop(context);
                                                      // Perform action 1
                                                    },
                                                  ),
                                                  CupertinoActionSheetAction(
                                                    child: const Text('Photos',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors
                                                                .blueAccent)),
                                                    onPressed: () {
                                                      openGallery()
                                                          .then((value) {
                                                        if (value != null) {
                                                          controller
                                                              .attachmentsList
                                                              .add(value.path);
                                                          controller
                                                              .attachmentsList
                                                              .refresh();
                                                        }
                                                      });
                                                      Navigator.pop(context);
                                                      // Perform action 2
                                                    },
                                                  ),
                                                ],
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: const Text('Cancel',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .blueAccent)),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: MySize.getHeight(100),
                                            width: MySize.getHeight(100),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.grey,
                                              size: MySize.getHeight(30),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              Spacing.height(20),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Colors.yellow,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      onPressed: () {
                                        controller.saveAttachmentsList.clear();
                                        controller.saveAttachmentsList
                                            .addAll(controller.attachmentsList);
                                        Get.back();
                                      },
                                      child: Text('Save Attachments',
                                          style: TextStyle(
                                            fontSize: MySize.getHeight(16),
                                            color: Colors.black,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Obx(() {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                (controller.showCalculate.value == true)
                    ? Row(
                        children: [
                          const Spacer(),
                          Column(
                            children: [
                              Text(
                                'Hours',
                                style: TextStyle(
                                  fontSize: MySize.getHeight(14),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                controller.totalWorkingHours.value,
                                style: TextStyle(
                                  fontSize: MySize.getHeight(16),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              Text(
                                'Amount',
                                style: TextStyle(
                                  fontSize: MySize.getHeight(14),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '${controller.totalAmount.value.toStringAsFixed(0)} DKK',
                                style: TextStyle(
                                  fontSize: MySize.getHeight(16),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      )
                    : Container(),
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
                        onPressed: () {
                          if (isNullEmptyOrFalse(controller.checkInTime) &&
                              isNullEmptyOrFalse(controller.checkOutTime)) {
                            getSnackBar(
                                context: context,
                                text:
                                    'Please select Check In - Check Out Time');
                          } else if (isNullEmptyOrFalse(
                              controller.checkInTime)) {
                            getSnackBar(
                                context: context,
                                text: 'Please select Check In Time');
                          } else if (isNullEmptyOrFalse(
                              controller.checkOutTime)) {
                            getSnackBar(
                                context: context,
                                text: 'Please select Check out Time');
                          } else {
                            DateTime checkIn = DateFormat('HH:mm a').parse(
                                DateFormat('HH:mm a')
                                    .format(controller.checkInTime!.value));

                            DateTime checkOut = DateFormat('HH:mm a').parse(
                                DateFormat('HH:mm a')
                                    .format(controller.checkOutTime!.value));
                            DateTime breakTime = DateFormat('HH:mm a').parse(
                                DateFormat('HH:mm a').format(
                                    controller.breakSelectedTime.value));
                            if (checkIn.isAfter(checkOut)) {
                              getSnackBar(
                                context: context,
                                text:
                                    'Check In time should be before Check Out time',
                              );
                            } else {
                              controller.amountCalculation(
                                checkIn: checkIn,
                                checkOut: checkOut,
                                breakTime: breakTime,
                              );
                              TimeDataModel checkOutModel = TimeDataModel(
                                date: controller.selectedDate.value.toString(),
                                dayType: controller.selectedDay.value,
                                checkInTime: DateFormat('HH:mm a')
                                    .format(controller.checkInTime!.value),
                                brakeTime: controller.breakTime.value,
                                checkOutTime: DateFormat('HH:mm a')
                                    .format(controller.checkOutTime!.value),
                                note: controller.noteString.value,
                                attachments:
                                    controller.saveAttachmentsList.join(","),
                                totalWorkingHour: controller.totalHours.value
                                    .toStringAsFixed(2),
                              );
                              getIt<DataBaseService>().insert(checkOutModel);
                            }
                          }
                        },
                        child: Text('Save Hours',
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
          }),
        ),
      ),
    );
  }

  Widget _checkInAndOutWidget(
      {required BuildContext context,
      required String title,
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
        if (isFromCheckOut) {
          if (isNullEmptyOrFalse(controller.checkInTime)) {
            getSnackBar(
              context: context,
              text: 'Please select Check In Time first',
            );
            return;
          }
        }
        if (isFromCheckOut) {
          if (isNullEmptyOrFalse(controller.breakTime.value)) {
            getSnackBar(
              context: context,
              text: 'Please select break Time first',
            );
            return;
          }
        }
        customBottomSheet(
          context: context,
          title: '$title Time',
          widget: selectTimePicker(
            context: context,
            selectedTime: controller.selectedTime,
            onPressed: () {
              if (isFromCheckOut) {
                String checkOutTime =
                    DateFormat('HH:mm a').format(controller.selectedTime.value);
                DateTime checkIn = DateFormat('HH:mm a').parse(
                    DateFormat('HH:mm a')
                        .format(controller.checkInTime!.value));
                DateTime checkOut = DateFormat('HH:mm a').parse(checkOutTime);
                if (checkIn.isAfter(checkOut) ||
                    checkIn.isAtSameMomentAs(checkOut)) {
                  getSnackBar(
                    context: context,
                    text: 'Check In time should be before Check Out time',
                  );
                } else {
                  if (!isNullEmptyOrFalse(controller.breakTime.value)) {
                    DateTime checkIn = DateFormat('HH:mm a').parse(
                        DateFormat('HH:mm a')
                            .format(controller.checkInTime!.value));
                    String checkOutTime = DateFormat('HH:mm a')
                        .format(controller.selectedTime.value);
                    DateTime checkOut =
                        DateFormat('HH:mm a').parse(checkOutTime);
                    DateTime breakTime =
                        DateFormat('HH:mm').parse(controller.breakTime.value);
                    DateTime totalCheckInAndBreakTime = checkIn.add(Duration(
                        hours: breakTime.hour, minutes: breakTime.minute));
                    if (totalCheckInAndBreakTime.isBefore(checkOut)) {
                      controller.checkOutTime =
                          controller.selectedTime.value.obs;
                      controller.amountCalculation(
                          checkIn: checkIn,
                          checkOut: checkOut,
                          breakTime: breakTime);
                    } else {
                      getSnackBar(
                        context: context,
                        text:
                            'you can not check out because your break time is more than your working hours',
                      );
                    }
                  } else {
                    DateTime breakTime =
                        DateFormat('HH:mm').parse(controller.breakTime.value);
                    controller.amountCalculation(
                      checkIn: checkIn,
                      checkOut: checkOut,
                      breakTime: breakTime,
                    );
                    controller.checkOutTime = controller.selectedTime.value.obs;
                  }
                }
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
                    DateTime breakTime =
                        DateFormat('HH:mm').parse(controller.breakTime.value);
                    controller.amountCalculation(
                      checkIn: checkIn,
                      checkOut: checkOut,
                      breakTime: breakTime,
                    );
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
