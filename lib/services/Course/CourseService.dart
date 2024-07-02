import 'dart:convert';
import 'package:vku_app/models/course.dart';
import 'package:vku_app/utils/api_consts.dart';
import 'package:http/http.dart' as http;

Future<List<Course>> fetchStudentCourses(String studentCode,
    {bool isToday = false}) async {
  // Gọi API để lấy danh sách lớp học phần
  // studentCode = '1';
  var courseListUrl = '';
  if (isToday) {
    courseListUrl = '$BASE_URL/student/getCurrentSchedule/$studentCode';
    // Kiểm tra ngày hiện tại có trùng với ngày của lớp học không
  } else {
    courseListUrl = '$BASE_URL/student/getCourses/$studentCode';
  }
  final courseResponse = await http.get(Uri.parse(courseListUrl));

  final courseListData = utf8.decode(courseResponse.bodyBytes);
  final courseList = jsonDecode(courseListData) as List<dynamic>;

  // Tạo danh sách lớp học phần từ dữ liệu nhận được
  List<Course> courses = [];
  for (var courseData in courseList) {
    final courseId = courseData['id'] as int;
    final courseCode = courseData['courseCode'] as String;
    final courseName = courseData['name'] as String;
    final week = courseData['week'].toString();
    final room = courseData['room'] as String;
    final dayOfWeek = courseData['dayOfWeek'].toString();
    final schoolYear = courseData['schoolYearSemester']['schoolYear'] as String;
    final semester = courseData['semester'].toString();
    final period = courseData['period'].toString();
    final professorId = courseData['officer']['id'] as int;
    final status = courseData['status'] as bool;

    Course course = Course(
      id: courseId,
      courseCode: courseCode,
      name: courseName,
      week: week,
      room: room,
      dayOfWeek: dayOfWeek,
      schoolYear: schoolYear,
      semester: semester,
      period: period,
      professorId: professorId,
      status: status,
    );
    courses.add(course);
  }

  return courses;
}
