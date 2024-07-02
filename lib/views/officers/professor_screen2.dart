import 'dart:convert'; // Add this line at the beginning of your Dart file

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:vku_app/models/attendance_sheet.dart';
import 'package:vku_app/models/course.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:vku_app/models/detail_attendance.dart';
import 'package:vku_app/utils/api_consts.dart';
import 'package:vku_app/utils/data/shared_preferences_manager.dart';
import 'package:vku_app/views/QRCode/QRScannerScreen.dart';
import 'package:vku_app/views/attendance/AttendanceSheetForCourseScreen.dart';
import 'package:vku_app/views/officers/course_screen.dart';

Future<List<Course>> fetchProfessorCourses(String professorId) async {
  // Gọi API để lấy danh sách lớp học phần
  final courseListUrl = '$BASE_URL/officer/course/$professorId';
  final courseResponse = await http.get(Uri.parse(courseListUrl));

  final courseListData = utf8.decode(courseResponse.bodyBytes);
  final courseList = jsonDecode(courseListData) as List<dynamic>;

  // Tạo danh sách lớp học phần từ dữ liệu nhận được
  List<Course> professorCourses = [];
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
    professorCourses.add(course);
  }

  return professorCourses;
}

class ProfessorScreen2 extends StatefulWidget {
  const ProfessorScreen2({super.key});

  get attendanceSheet => null;

  @override
  _ProfessorScreenState createState() => _ProfessorScreenState();
}

class _ProfessorScreenState extends State<ProfessorScreen2> {
  List<Course> selectedCourses = [];

  get detailAttendances => null;

  String? professorId;
  @override
  void initState() {
    super.initState();
    initializeProfessorId();
    // selectedCourses = fetchProfessorCourses(professorId!);
  }

  Future<void> initializeProfessorId() async {
    professorId = await getSessionId();
    debugPrint('professorId: $professorId');
    selectedCourses = await fetchProfessorCourses(professorId!);
    debugPrint('courses: $selectedCourses');
    setState(() {
      selectedCourses = selectedCourses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giảng viên'),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.qr_code),
        //     onPressed: _scanQRCode,
        //     tooltip: '',
        //   ),
        // ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(' '),
            ),
            // ListTile(
            //   title: const Text('QR Scanner'),
            //   leading: const Icon(Icons.qr_code),
            //   onTap: _scanQRCode,
            // ),
            ListTile(
              title: const Text('Thông Tin Giảng Viên'),
              leading: const Icon(Icons.person),
              onTap: _showProfessorInfo,
            ),
            ListTile(
              title: const Text('Xem lịch dạy'),
              leading: const Icon(Icons.book),
              onTap: () {
                Navigator.pop(context);
                _manageCourses();
              },
            ),
            ListTile(
              title: const Text('Đăng xuất'), // Thêm ListTile "Đăng xuất"
              leading: const Icon(Icons.logout),
              onTap:
                  _logout, // Gọi phương thức _logout khi nhấn vào ListTile "Đăng xuất"
            ),
            // Các mục Drawer khác...
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Lịch dạy hôm nay:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: selectedCourses.length,
              separatorBuilder: (context, index) => const Divider(height: 0),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                        title: Text(selectedCourses[index].name),
                        onTap: () {
                          _showAttendanceSheetForCourse(selectedCourses[index]);
                        },
                        trailing: ElevatedButton(
                          onPressed: () {
                            _takeAttendance(selectedCourses[index]);
                          },
                          child: const Text('Điểm danh'),
                        )),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // _updateLectureContent();
              },
              tooltip: 'Update Lecture Content',
            ),
            IconButton(
              icon: const Icon(Icons.group),
              onPressed: () {
                // _updateAbsentStudentsList();
              },
              tooltip: 'Update Absent Students List',
            ),
            // Other IconButton widgets...
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // try {
          //   readQRCode();
          // } catch (e) {
          //   print('error Scan QR: ' + e.toString());
          // }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const QRScannerScreen(),
            ),
          );
        },
        tooltip: 'Scan QR Code',
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }

  void _logout() {
    saveSessionRole("");
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login', // Đường dẫn của màn hình đăng nhập
      (route) => false, // Xóa tất cả các màn hình khác trong stack
    );
  }

  void _generateAttendanceQR(Course course, String lessonContent) async {
    debugPrint('attendnaceQR: $lessonContent');
    try {
      final apiAttendanceQR =
          "$BASE_URL/officer/attendanceQR?courseId=${course.id}&lessonContent=$lessonContent";

      final response = await http.post(
        Uri.parse(apiAttendanceQR),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      debugPrint('Response status: ${response.statusCode}'
          ' Response body: ${response.body}');
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final attendanceId = jsonResponse['attendanceId'];
        final attendanceQRImageBase64 = jsonResponse['attendanceQRImageBase64'];

        debugPrint("QR Code generated successfully");
        debugPrint("Attendance ID: $attendanceId");
        // Use this encoded string as needed, e.g., storing in the database or sending via API
        debugPrint("Attendance QR Image Base64: $attendanceQRImageBase64");
        // Use this image as needed, e.g., displaying in an image widget
        final image = base64Decode(attendanceQRImageBase64);

        // show image to UI showdialog with image

        setState(() {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('QR Code Attendance'),
                    content: Image.memory(
                      image,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Send'),
                        onPressed: () async {
                          // Chuyển đến giao diện mới hàng đối tượng để thực hiện điểm danh điểm danh

                          debugPrint('QR Code saved successfully');
                          Navigator.of(context).pop();
                        },
                      )
                    ]);
              });

          // qrImage = image;
          // qrImageBase64 = attendanceQRImageBase64;
          // qrAttendanceId = attendanceId;
          // widget.createElement().inflateWidget( attendanceId , image);
        });
      } else if (response.statusCode == 500) {
        debugPrint("Failed to generate QR Code 112");
        _showErrorDialog(response.body);
      }
    } catch (e) {
      debugPrint("Error generating QR Code: $e");
    }
  }

  void _takeAttendance(Course course) {
    debugPrint(
        "Take attendance for course: ${course.id}"); // Print the course ID (assuming it's accessible in course)
    TextEditingController contentController = TextEditingController();
    // String courseId = course.id
    //     .toString(); // Assuming courseId is accessible in AttendanceSheet

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tạo nội dung buổi học'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: contentController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Nhập nội dung buổi học',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tạo QR điểm danh'),
              onPressed: () {
                Navigator.of(context).pop();
                //get hintText from TextField
                String lessonContent = contentController.text;
                _generateAttendanceQR(
                    course, lessonContent); // Pass course to generate QR
              },
            ),
            TextButton(
              child: const Text('Điểm danh'),
              onPressed: () {
                Navigator.of(context).pop();
                _recordNormalAttendance(course, contentController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void _recordNormalAttendance(Course course, String lessonContent) async {
    debugPrint('attendnaceQR: $lessonContent');
    try {
      final apiAttendanceQR =
          "$BASE_URL/officer/attendanceNormal?courseId=${course.id}&lessonContent=$lessonContent";

      final response = await http.post(
        Uri.parse(apiAttendanceQR),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      debugPrint('Response status: ${response.statusCode}'
          ' Response body: ${response.body}');
      if (response.statusCode == 200) {
        // show image to UI showdialog with image
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AttendanceSheetForCourseScreen(
              course: course,
              // studentList: studentList,
              // attendanceId: parsedAttendanceId,
            ),
          ),
        );
      } else {
        _showErrorDialog("Điểm danh thất bại");
      }
    } catch (e) {
      _showErrorDialog("Điểm danh thất bại ${e.toString()}");
    }
  }

// Function to display error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showProfessorInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông Tin Giảng Viên'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Professor ID: $professorId'),
                // Display other professor information here
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _manageCourses() {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CourseScreen(
            officerId: '1',
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error showing attendance sheet: $e');
      _showErrorDialog('Error showing attendance sheet: $e');
    }
  }

  void _showAttendanceSheetForCourse(Course course) async {
    // debugPrint('course: ');
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttendanceSheetForCourseScreen(
            course: course,
            // studentList: studentList,
            // attendanceId: parsedAttendanceId,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error showing attendance sheet: $e');
      _showErrorDialog('Error showing attendance sheet: $e');
    }
  }
}
