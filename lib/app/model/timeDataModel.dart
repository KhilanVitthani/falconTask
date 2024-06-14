class TimeDataModel {
  String? date;
  String? dayType;
  String? checkInTime;
  String? checkOutTime;
  String? brakeTime;
  String? totalWorkingHour;
  String? note;
  String? attachments;

  TimeDataModel(
      {this.date,
      this.dayType,
      this.checkInTime,
      this.checkOutTime,
      this.brakeTime,
      this.totalWorkingHour,
      this.note,
      this.attachments});

  TimeDataModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    dayType = json['dayType'];
    checkInTime = json['checkInTime'];
    checkOutTime = json['checkOutTime'];
    brakeTime = json['brakeTime'];
    totalWorkingHour = json['totalWorkingHour'];
    note = json['note'];
    attachments = json['attachments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['dayType'] = dayType;
    data['checkInTime'] = checkInTime;
    data['checkOutTime'] = checkOutTime;
    data['brakeTime'] = brakeTime;
    data['totalWorkingHour'] = totalWorkingHour;
    data['note'] = note;
    data['attachments'] = attachments;
    return data;
  }
}
