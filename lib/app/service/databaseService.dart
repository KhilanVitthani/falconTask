import 'package:falcon_task/app/constant/sizeConstant.dart';
import 'package:falcon_task/app/model/timeDataModel.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseService {
  static Database? _db;
  static const int _versoin = 1;
  static const String _table = "timeData";

  Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String path = "${await getDatabasesPath()}$_table.db";
      _db = await openDatabase(
        path,
        version: _versoin,
        onCreate: (db, version) {
          // print("Create a new one");
          db
              .execute(
                "CREATE TABLE $_table("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "date STRING,dayType STRING,checkInTime STRING,checkOutTime STRING,brakeTime STRING,totalWorkingHour STRING,note STRING,attachments STRING)",
              )
              .then((value) {})
              .catchError((error) {});
        },
      );

      // print(_dbAttendance);
    } catch (e) {
      // print(e);
    }
  }

  Future<int> insert(TimeDataModel? task) async {
    return await _db?.insert(_table, task!.toJson()).then((value) {
          getSnackBar(
            context: Get.context!,
            text: 'Data Added Successfully',
          );
          return value;
        }).catchError((error) {
          getSnackBar(
            context: Get.context!,
            text: 'Something went wrong',
          );
        }) ??
        1;
  }
}
