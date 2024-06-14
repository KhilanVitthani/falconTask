import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../constant/sizeConstant.dart';

getImage() {}
final imgPicker = ImagePicker();

Future<File?> openCamera() async {
  Rx<File>? imgFile;
  Rx<File?>? profile;
  String? imgCamera;
  await imgPicker.pickImage(source: ImageSource.camera).then((value) {
    imgCamera = value!.path;
    print(imgCamera);
    imgFile = File(imgCamera!).obs;
    return imgFile!.value;
  }).catchError((error) {
    print(error);
  });

  return (isNullEmptyOrFalse(imgFile!.value)) ? null : imgFile!.value;
}

Future<File?> openGallery() async {
  Rx<File>? imgFile;
  Rx<File?>? profile;
  String? imgGallery;
  await imgPicker.pickImage(source: ImageSource.gallery).then((value) {
    imgGallery = value!.path;

    imgFile = File(imgGallery!).obs;
    print(imgFile);
    imgFile!.refresh();
  });

  return (isNullEmptyOrFalse(imgFile!.value)) ? null : imgFile!.value;
}
