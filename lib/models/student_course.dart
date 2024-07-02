class StudentCourse {
  final String id;
  final String className;
  final String name;
  late bool present;
  final int absenceCount;
  final String attendanceId;

  StudentCourse({
    required this.id,
    required this.className,
    required this.name,
    this.present = false,
    required this.absenceCount,
    required this.attendanceId,
  });
}

//   factory StudentCourse.fromJson(Map<String, dynamic> json) {
//     return StudentCourse(
//       id: json['id'],
//       studentCode: json['studentCode'],
//       courseId: json['courseId'],
//       extraSheet: json['extraSheet'],
//       status: json['status'],
//       createTime: DateTime.parse(json['createTime']),
//       updateTime: DateTime.parse(json['updateTime']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'studentCode': studentCode,
//       'courseId': courseId,
//       'extraSheet': extraSheet,
//       'status': status,
//       'createTime': createTime.toString(),
//       'updateTime': updateTime.toString(),
//     };
//   }
// }
