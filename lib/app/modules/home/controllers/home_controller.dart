import 'package:get/get.dart';

class HomeController extends GetxController {
  List<ListItemModel> hourList = <ListItemModel>[
    ListItemModel(title: "40:00 Hours", subTitle: "Total Hours"),
    ListItemModel(title: "3:00 Hours", subTitle: "400 DKK"),
    ListItemModel(title: "150 Km", subTitle: "400 DKK"),
    ListItemModel(title: "0 Days", subTitle: "Leave"),
  ];
}

class ListItemModel {
  RxBool? isSelected;
  String? title;
  String? subTitle;

  ListItemModel({
    this.isSelected,
    this.title,
    this.subTitle,
  });

  ListItemModel.fromJson(Map<String, dynamic> json) {
    isSelected?.value =
        (json['isSelected'] != null) ? json['isSelected'] : false;
    title = json['title'];
    subTitle = json['subTitle'];
  }

  Map<String, dynamic> toJson() {
    return {
      'isSelected': isSelected,
      'title': title,
      'subTitle': subTitle,
    };
  }
}
