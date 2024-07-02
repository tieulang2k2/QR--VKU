// class Course {
//   final String courseID;
//   final String courseName;
//   final String courseTime;
//   final String professorID;
//   final String schedule;
//   final String description;


//   Course({
//     required this.courseID,
//     required this.courseName,
//     required this.courseTime,
//     required this.professorID,
//     required this.schedule,
//     required this.description,

//   });
// }
class Course {
  final int id;
  final String courseCode;
  final String name;
  final String week;
  final String room;
  final String dayOfWeek;
  final String schoolYear;
  final String semester;
  final String period;
  final int professorId;
  final bool status;

  Course({
    required this.id,
    required this.courseCode,
    required this.name,
    required this.week,
    required this.room,
    required this.dayOfWeek,
    required this.schoolYear,
    required this.semester,
    required this.period,
    required this.professorId,
    required this.status,

  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseCode': courseCode,
      'name': name,
      'professorId': professorId,
      'schoolYear': schoolYear,
      'semester': semester,
      'status': status
    }; 
    }
  
}
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class Course {
//   final int id;
//   final String courseCode;
//   final String name;
//   final String week;
//   final String room;
//   final String dayOfWeek;
//   final SchoolYearSemester schoolYearSemester;
//   final int semester;
//   final String period;
//   final bool status;
//   final Officer officer;
//   final DateTime createTime;
//   final DateTime updateTime;

//   Course({
//     required this.id,
//     required this.courseCode,
//     required this.name,
//     required this.week,
//     required this.room,
//     required this.dayOfWeek,
//     required this.schoolYearSemester,
//     required this.semester,
//     required this.period,
//     required this.status,
//     required this.officer,
//     required this.createTime,
//     required this.updateTime,
//   });

//   factory Course.fromJson(Map<String, dynamic> json) {
//     return Course(
//       id: json['id'],
//       courseCode: json['courseCode'],
//       name: json['name'],
//       week: json['week'],
//       room: json['room'],
//       dayOfWeek: json['dayOfWeek'],
//       schoolYearSemester: SchoolYearSemester.fromJson(json['schoolYearSemester']),
//       semester: json['semester'],
//       period: json['period'],
//       status: json['status'],
//       officer: Officer.fromJson(json['officer']),
//       createTime: DateTime.parse(json['createTime']),
//       updateTime: DateTime.parse(json['updateTime']),
//     );
//   }
// }
// class SchoolYearSemester {
//   final int id;
//   final String schoolYear;
//   final String semester;
//   final String startTime;
//   final String? endTime;
//   final String schoolYearStartDate;
//   final bool current;
//   final bool status;
//   final DateTime createTime;
//   final DateTime updateTime;

//   SchoolYearSemester({
//     required this.id,
//     required this.schoolYear,
//     required this.semester,
//     required this.startTime,
//     this.endTime,
//     required this.schoolYearStartDate,
//     required this.current,
//     required this.status,
//     required this.createTime,
//     required this.updateTime,
//   });

//   factory SchoolYearSemester.fromJson(Map<String, dynamic> json) {
//     return SchoolYearSemester(
//       id: json['id'],
//       schoolYear: json['schoolYear'],
//       semester: json['semester'],
//       startTime: json['startTime'],
//       endTime: json['endTime'],
//       schoolYearStartDate: json['schoolYearStartDate'],
//       current: json['current'],
//       status: json['status'],
//       createTime: DateTime.parse(json['createTime']),
//       updateTime: DateTime.parse(json['updateTime']),
//     );
//   }
// }

// class Officer {
//   final int id;
//   final String officerCode;
//   final String password;
//   final String name;
//   final String email;
//   final String cccd;
//   final String? phoneNumber;
//   final Position position;
//   final dynamic degree;
//   final dynamic salary;
//   final dynamic allowance;
//   final bool status;
//   final DateTime createTime;
//   final DateTime updateTime;
//   final dynamic qrcodeImage;

//   Officer({
//     required this.id,
//     required this.officerCode,
//     required this.password,
//     required this.name,
//     required this.email,
//     required this.cccd,
//     this.phoneNumber,
//     required this.position,
//     this.degree,
//     this.salary,
//     this.allowance,
//     required this.status,
//     required this.createTime,
//     required this.updateTime,
//     this.qrcodeImage,
//   });

//   factory Officer.fromJson(Map<String, dynamic> json) {
//     return Officer(
//       id: json['id'],
//       officerCode: json['officerCode'],
//       password: json['password'],
//       name: json['name'],
//       email: json['email'],
//       cccd: json['cccd'],
//       phoneNumber: json['phoneNumber'],
//       position: Position.fromJson(json['position']),
//       degree: json['degree'],
//       salary: json['salary'],
//       allowance: json['allowance'],
//       status: json['status'],
//       createTime: DateTime.parse(json['createTime']),
//       updateTime: DateTime.parse(json['updateTime']),
//       qrcodeImage: json['qrcodeImage'],
//     );
//   }
// }

// class Position {
//   final int id;
//   final String positionCode;
//   final String name;
//   final bool status;
//   final DateTime createTime;
//   final DateTime updateTime;

//   Position({
//     required this.id,
//     required this.positionCode,
//     required this.name,
//     required this.status,
//     required this.createTime,
//     required this.updateTime,
//   });

//   factory Position.fromJson(Map<String, dynamic> json) {
//     return Position(
//       id: json['id'],
//       positionCode: json['positionCode'],
//       name: json['name'],
//       status: json['status'],
//       createTime: DateTime.parse(json['createTime']),
//       updateTime: DateTime.parse(json['updateTime']),
//     );
//   }
// }

// Future<Course> getCourseData() async {
//   final response = await http.get(Uri.parse('https://your-api-endpoint.com/courses/1'));
//   if (response.statusCode == 200) {
//     return Course.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception('Failed to fetch course data');
//   }
// }