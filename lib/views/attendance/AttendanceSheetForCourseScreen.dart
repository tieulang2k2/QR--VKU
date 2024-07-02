import 'dart:convert'; // Add this line at the beginning of your Dart file
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vku_app/models/course.dart';
import 'package:vku_app/models/student_course.dart';
import 'package:vku_app/utils/NotificationUtils.dart';
import 'package:vku_app/utils/api_consts.dart';

class AttendanceSheetForCourseScreen extends StatefulWidget {
  final Course course;
  const AttendanceSheetForCourseScreen({super.key, required this.course});

  @override
  _AttendanceSheetForCourseScreenState createState() =>
      _AttendanceSheetForCourseScreenState();
}

Future<List<StudentCourse>> getAttendanceSheetForCourse(Course course) async {
  try {
    // Gọi API để lấy danh sách sinh viên dựa trên course ID
    debugPrint('course.id: ${course.id}');
    final studentListUrl =
        '$BASE_URL/officer/getStudentAttendanceForCourseId/${course.id}';
    final studentListResponse = await http.get(Uri.parse(studentListUrl));

    final studentListUft8 = utf8.decode(studentListResponse.bodyBytes);
    final studentListData = jsonDecode(studentListUft8);
    debugPrint('studentListData: $studentListData');
    // print('Operating System: $operatingSystem');

    // Chuyển đổi dữ liệu từ API thành danh sách sinh viên
    List<StudentCourse> studentList = [];
    for (var studentData in studentListData) {
      StudentCourse student = StudentCourse(
        id: studentData['studentCode'],
        className: studentData['nameClass'],
        name: studentData['nameStudent'],
        present: studentData['present'],
        // absenceCount: int.tryParse(studentData['absenceCount']) ?? 0,
        absenceCount: 0,
        attendanceId: "3", //chưa dùng đến attendanceId
      );
      studentList.add(student);
    }

    return studentList;
  } catch (e) {
    // Handle any errors that occur during the API call
    return []; // Return an empty list on error
  }
}

class _AttendanceSheetForCourseScreenState
    extends State<AttendanceSheetForCourseScreen> {
  late Future<List<StudentCourse>>
      studentListFuture; // Danh sách sinh viên từ API
  bool saveAttendanceSuccess = false;

  @override
  void initState() {
    super.initState();
    studentListFuture = getAttendanceSheetForCourse(widget.course);
  }
// API call to save attendance data

  @override
  Widget build(BuildContext context) {
    // Phần giao diện của màn hình AttendanceSheetForCourseScreen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách điểm danh'),
      ),
      body: FutureBuilder<List<StudentCourse>>(
          future: studentListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for the API response, show a loading indicator
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // If an error occurred during the API call, show an error message
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // If the API call was successful, retrieve the studentList
              final studentList = snapshot.data ?? [];
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: constraints.maxWidth),
                            child: DataTable(
                              columnSpacing: 16, // Khoảng cách giữa các cột
                              columns: const [
                                DataColumn(label: Text('STT')), // Cột STT
                                DataColumn(
                                    label: Text(
                                        'Mã sinh viên')), // Cột Mã sinh viên
                                DataColumn(label: Text('Tên')), // Cột Tên
                                DataColumn(label: Text('Lớp')), // Cột Lớp
                                DataColumn(
                                    label:
                                        Text('Trạng thái')), // Cột Trạng thái
                              ],
                              rows: List.generate(
                                studentList.length,
                                (index) {
                                  StudentCourse student = studentList[index];
                                  return DataRow(
                                    color: MaterialStateColor.resolveWith(
                                        (states) {
                                      if (index % 2 == 0) {
                                        return Colors.grey.withOpacity(
                                            0.1); // Màu nền xen kẻ hàng
                                      } else {
                                        return Colors.white;
                                      }
                                    }),
                                    cells: [
                                      DataCell(Text('${index + 1}')),
                                      DataCell(Text(student.id)),
                                      DataCell(Text(student.name)),
                                      DataCell(Text(student.className)),
                                      DataCell(
                                        ElevatedButton(
                                          onPressed: () async {
                                            final bool success =
                                                await attendancePerStudent(
                                                    widget.course.id,
                                                    student.id);

                                            if (success) {
                                              setState(() {
                                                student.present =
                                                    !student.present;
                                              });
                                            } else {
                                              // showDialog(
                                              //   context: context,
                                              //   builder:
                                              //       (BuildContext context) {
                                              //     return AlertDialog(
                                              //       title: Text('Error'),
                                              //       content: Text(
                                              //           'Failed to mark attendance.'),
                                              //       actions: [
                                              //         TextButton(
                                              //           child: Text('OK'),
                                              //           onPressed: () {
                                              //             Navigator.of(context)
                                              //                 .pop();
                                              //           },
                                              //         ),
                                              //       ],
                                              //     );
                                              //   },
                                              // );
                                            }

                                            // Xử lý khi nhấn nút
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) {
                                              return student.present
                                                  ? Colors.green
                                                  : Colors.red;
                                            }),
                                          ),
                                          child: Text(student.present
                                              ? 'Có mặt'
                                              : '  Vắng '),
                                        ),
                                      ), // Trạng thái
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Truy xuất giá trị 'attendanceId'
                            _saveAttendance(widget.course.id);
                            // Xử lý khi nhấn nút "Lưu điểm danh"
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateColor.resolveWith((states) {
                              return Colors.blue;
                            }),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(16)),
                          ),
                          child: const Text('Lưu điểm danh'),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }),
    );
  }

  void _saveAttendance(int courseId) async {
    String apiUrl = '';
    if (!saveAttendanceSuccess) {
      debugPrint('Save attendance data');
      apiUrl = '$BASE_URL/officer/saveAttendance';
      debugPrint('apiUrl: $apiUrl');
      saveAttendanceSuccess = true;
    } else {
      apiUrl = '$BASE_URL/officer/updateAttendance';
      debugPrint('Update attendance data - apiUrl: $apiUrl');
    }
    try {
      // final response = await http.post(
      //   Uri.parse(apiUrl),
      //   body: {'courseId': courseId},
      //   headers: {"Content-Type": "application/json"},
      // );
      final response = await http
          .post(Uri.parse(apiUrl), body: {'courseId': courseId.toString()});
      if (response.statusCode == 200) {
        NotificationUtils.showNotificationDialog(context, "Đã điểm danh");
        // Handle successful response if needed
      } else {
        // Handle error for unsuccessful response
        // _showErrorDialog('Failed to save attendance data.');
        NotificationUtils.showNotificationDialog(context, "Điểm danh thất bại");
      }
    } catch (e) {
      e.printError();
      // Handle network error when making the request
      // _showErrorDialog('Network error occurred while saving attendance.');
    }
  }
}

Future<bool> attendancePerStudent(int courseId, String studentCode) async {
  try {
    String apiUrl = '$BASE_URL/officer/attendancePerStudent';
    final response = await http.put(Uri.parse(apiUrl), body: {
      'courseId': courseId.toString(),
      'studentCode': studentCode,
    });
    debugPrint(
        'AttendanceSheetForCourseScreen: courseId: $courseId studentCode: $studentCode - attendancePerStudent: ${response.body}');
    if (response.statusCode == 200) {
      final bool success = jsonDecode(response.body);
      return success;
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}
