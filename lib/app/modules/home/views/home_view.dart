import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/sizeConstant.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetWidget<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MySize.getHeight(230),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: CustomAppBar(),
          child: Container(
            height: MySize.getHeight(450),
            width: MediaQuery.of(context).size.width,
            color: Colors.yellow.withOpacity(0.7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacing.height(50),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.account_circle,
                            size: MySize.getHeight(20),
                          ),
                        ),
                      ),
                      SizedBox(width: MySize.getWidth(20)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, Pratik',
                            style: TextStyle(
                              fontSize: MySize.getHeight(16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '26 Feb 2024 - 3 May 2024',
                            style: TextStyle(
                              fontSize: MySize.getHeight(16),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.yellow[100],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.notifications_none,
                            size: MySize.getHeight(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacing.height(20),
                Text(
                  '1000 DKK',
                  style: TextStyle(
                    fontSize: MySize.getHeight(25),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Income this week',
                  style: TextStyle(
                    fontSize: MySize.getHeight(15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: controller.hourList.length,
        itemBuilder: (context, index) {
          ListItemModel item = controller.hourList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: customWidget(
                titleFontWeight: FontWeight.bold,
                subTitleFontWeight: FontWeight.w400,
                title: item.title.toString(),
                subTitle: item.subTitle.toString(),
                icon: Icons.access_time_outlined,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.yellow.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          openBottomSheet(context: context);
        },
        //params
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        height: MySize.getHeight(100),
        icons: const [
          Icons.apps,
          Icons.calendar_today_rounded,
          Icons.access_time_outlined,
          Icons.calendar_month_rounded,
        ],
        activeIndex: 0,

        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index) {},
        //other params
      ),
    );
  }

  openBottomSheet({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add New Entry",
                    style: TextStyle(
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
              ListTile(
                title: const Text('Hours'),
                leading: const Icon(Icons.access_time_outlined),
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.ADD_HOURS);
                },
              ),
              Divider(
                height: 1,
                color: Colors.grey.shade100,
              ),
              ListTile(
                title: const Text('Leave'),
                leading: const Icon(Icons.logout),
                onTap: () {
                  Get.back();
                },
              ),
              Divider(
                height: 1,
                color: Colors.grey.shade100,
              ),
              ListTile(
                title: const Text('Mileage'),
                leading: const Icon(Icons.directions_car),
                onTap: () {
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomAppBar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 70);
    path.quadraticBezierTo(width / 2, height, width, height - 70);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

Widget customWidget(
    {required String title,
    required String subTitle,
    FontWeight? titleFontWeight,
    FontWeight? subTitleFontWeight,
    required IconData? icon,
    bool autoFillHours = false,
    void Function()? onTap}) {
  return InkWell(
    onTap: (autoFillHours) ? null : onTap,
    child: Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade200,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                icon,
                color: Colors.grey,
                size: MySize.getHeight(30),
              ),
            ),
          ),
          Spacing.width(20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: MySize.getHeight(16),
                    fontWeight: titleFontWeight ?? FontWeight.w400,
                  ),
                ),
                Text(
                  subTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: MySize.getHeight(16),
                    fontWeight: subTitleFontWeight ?? FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          (!isNullEmptyOrFalse(autoFillHours))
              ? Container()
              : Icon(
                  Icons.keyboard_arrow_right_outlined,
                  size: MySize.getHeight(30),
                ),
        ],
      ),
    ),
  );
}
