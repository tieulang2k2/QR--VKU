import 'dart:convert'; // Add this line at the beginning of your Dart file
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vku_app/models/course.dart';
import 'package:vku_app/services/officers/LectureService.dart';
import 'package:vku_app/utils/api_consts.dart';
import 'package:vku_app/views/attendance/AttendanceSheetForCourseScreen.dart';

class CourseScreen extends StatefulWidget {
  final String officerId;
  const CourseScreen({super.key, required this.officerId});

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late Future<List<Course>> allCourses; // Danh sách sinh viên từ API
  late Future<List<Course>> todayCourses; // Danh sách sinh viên từ API
  late Future<Tuple2<List<Course>, List<Course>>> objects;
  @override
  void initState() {
    super.initState();
    todayCourses = fetchProfessorCourses(widget.officerId, isToday: true);
    allCourses = fetchProfessorCourses(widget.officerId);
    objects = Future.wait([todayCourses, allCourses]).then((values) {
    return Tuple2(values[0], values[1]);
  });
    // studentListFuture = getCourses(officerId);
  }

// API call to save attendance data
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch dạy hôm nay'),
        backgroundColor: Color.fromARGB(96, 16, 155, 109),
      ),
       body: FutureBuilder<Tuple2<List<Course>, List<Course>>>(
      // future: Future.wait([todayCourses, allCourses]).then((values) {
      //   return Tuple2(values[0], values[1]);
      // }),
      future: objects,
      builder: (context, snapshot) {
          if (snapshot.hasData) {
            // final currentCoures = snapshot.data!;
            final currentCoures = snapshot.data!.item1;
          final allCourses = snapshot.data!.item2;
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  // Set alignment to top left to make the view scroll to the top

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      //   // margin: const EdgeInsets.all(16.0),
                      //   decoration: BoxDecoration(
                      //     color: Color.fromARGB(87, 49, 187, 111), // màu xanh cây nhợt
                      //     border: Border.all(
                      //       color:const Color.fromARGB(31, 241, 241, 241),
                      //       width: 1.0,
                      //     ),
                      //   ),
                      //   child: const Row(
                      //     children: [
                      //        Text(
                      //         'Lịch dạy hôm nay',
                      //         style: TextStyle(
                      //           fontSize: 20,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: constraints.maxWidth),
                          child: DataTable(
                            columnSpacing: 16, // Khoảng cách giữa các cột

                            columns: const [
                              DataColumn(label: Text('STT')),
                              DataColumn(label: Text('Học phần')),
                              DataColumn(label: Text('Tuần')),
                              DataColumn(label: Text('Phòng')),
                              DataColumn(label: Text('Thứ / Tiết')),
                              DataColumn(label: Text('#')),
                            ],
                            rows: List.generate(
                              currentCoures.length,
                              (index) {
                                Course course = currentCoures[index];
                                return DataRow(
                                  color:
                                      MaterialStateColor.resolveWith((states) {
                                    if (index % 2 == 0) {
                                      return Colors.grey.withOpacity(
                                          0.1); // Màu nền xen kẻ hàng
                                    } else {
                                      return Colors.white;
                                    }
                                  }),
                                  cells: [
                                    DataCell(Text('${index + 1}')),
                                    DataCell(
                                      TextButton(
                                        onPressed: () {
                                          _showAttendanceSheetForCourse(course);
                                        },
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.black),
                                        ),
                                        child: Text(course.name),
                                      ),
                                      // Text(course.name)
                                    ),
                                    DataCell(Text(course.week)),
                                    DataCell(Text(course.room)),
                                    DataCell(Text(
                                        '${getDayOfWeek(int.parse(course.dayOfWeek))}/ ${course.period}')),
                                    DataCell(
                                      ElevatedButton(
                                        onPressed: () async {
                                          _takeAttendance(course);
                                        },
                                        style: ButtonStyle(backgroundColor:
                                            MaterialStateColor.resolveWith(
                                                (states) {
                                          return const Color.fromARGB(
                                              255, 73, 194, 157);
                                        })),
                                        child: const Text('Điểm danh'),
                                      ),
                                    ), // Trạng thái
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 16.0),
                        // margin: const EdgeInsets.all(16.0),
                        // decoration: BoxDecoration(
                        //   color: Color.fromARGB(87, 49, 187, 111), // màu xanh cây nhợt
                        //   border: Border.all(
                        //     color:const Color.fromARGB(31, 241, 241, 241),
                        //     width: 1.0,
                        //   ),
                        // ),
                        child: const Row(
                          children: [
                            Text(
                              '',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 16.0),
                        // margin: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(
                              86, 240, 167, 59), // màu xanh cây nhợt
                          border: Border.all(
                            color: const Color.fromARGB(31, 241, 241, 241),
                            width: 1.0,
                          ),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'Lịch dạy khác',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minWidth: constraints.maxWidth),
                              child: DataTable(
                                columnSpacing: 16, // Khoảng cách giữa các cột
                                columns: const [
                                  DataColumn(label: Text('STT')),
                                  DataColumn(label: Text('Học phần')),
                                  DataColumn(label: Text('Tuần')),
                                  DataColumn(label: Text('Phần')),
                                  DataColumn(label: Text('Thứ / Tiết')),
                                  DataColumn(label: Text('#')),
                                ],
                                // List<Course>
                                rows: List.generate(
                                  allCourses.length,
                                  (index) {
                                    Course course = allCourses[index];
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
                                        DataCell(
                                          TextButton(
                                            onPressed: () {
                                              _showAttendanceSheetForCourse(
                                                  course);
                                            },
                                            style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.black),
                                            ),
                                            child: Text(course.name),
                                          ),
                                          // Text(course.name)
                                        ),
                                        DataCell(Text(course.week)),
                                        DataCell(Text(course.room)),
                                        DataCell(Text(
                                            '${getDayOfWeek(int.parse(course.dayOfWeek))}/ ${course.period}')),
                                        DataCell(
                                          ElevatedButton(
                                            onPressed: () async {
                                              _takeAttendance(course);
                                            },
                                            style: ButtonStyle(backgroundColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) {
                                              return const Color.fromARGB(
                                                  255, 73, 194, 157);
                                            })),
                                            child: const Text('Điểm danh'),
                                          ),
                                        ), // Trạng thái
                                      ],
                                    );
                                  },
                                ),
                              ))),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
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
      // _showErrorDialog('Error showing attendance sheet: $e');
    }
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
}

class Tuple2<T1, T2> {
  final T1 item1;
  final T2 item2;

  Tuple2(this.item1, this.item2);
}

String getDayOfWeek(int dayOfWeek) {
  switch (dayOfWeek) {
    case 1:
      return 'Hai';
    case 2:
      return 'Ba';
    case 3:
      return 'Tư';
    case 4:
      return 'Năm';
    case 5:
      return 'Sáu';
    case 6:
      return 'Bảy';
    case 7:
      return 'Chủ Nhật';
    default:
      return '';
  }
}
