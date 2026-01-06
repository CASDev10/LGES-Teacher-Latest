import 'dart:convert';

List<StudentModel> studentModelFromJson(List<dynamic> json) =>
    List<StudentModel>.from(json.map((x) => StudentModel.fromJson(x)));

String studentModelToJson(List<StudentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentModel {
  String fileNo;
  String studentName;
  String fatherName;

  String english;
  String urdu;
  String mathematics;
  String islamiyat;
  String wa;
  String computer;

  String totalObtained;
  String total;
  String percentage;

  StudentModel({
    required this.fileNo,
    required this.studentName,
    required this.fatherName,
    required this.english,
    required this.urdu,
    required this.mathematics,
    required this.islamiyat,
    required this.wa,
    required this.computer,
    required this.totalObtained,
    required this.total,
    required this.percentage,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      fileNo: json['FileNumber']?.toString() ?? '',
      studentName: json['StudentName']?.toString() ?? '',
      fatherName: json['FatherName']?.toString() ?? '',

      english: json['English']?.toString() ?? '0',
      urdu: json['Urdu']?.toString() ?? '0',
      mathematics: json['Mathematics']?.toString() ?? '0',
      islamiyat: json['Islamiyat']?.toString() ?? '0',
      wa: json['WA']?.toString() ?? '0',
      computer: json['Computer']?.toString() ?? '0',

      totalObtained: json['TotalObtained']?.toString() ?? '0',
      total: json['Total']?.toString() ?? '0',
      percentage: json['Percentage']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() => {
    'FileNumber': fileNo,
    'StudentName': studentName,
    'FatherName': fatherName,
    'English': english,
    'Urdu': urdu,
    'Mathematics': mathematics,
    'Islamiyat': islamiyat,
    'WA': wa,
    'Computer': computer,
    'TotalObtained': totalObtained,
    'Total': total,
    'Percentage': percentage,
  };
}
