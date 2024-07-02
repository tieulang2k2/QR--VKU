import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Assuming this is the path to the Student model
import 'package:sidebarx/sidebarx.dart';
import 'package:vku_app/models/guest.dart';
import 'package:vku_app/models/student_course.dart';
import 'package:vku_app/services/students/StudentService.dart';
import 'package:vku_app/utils/api_consts.dart';
import 'package:vku_app/utils/data/shared_preferences_manager.dart';
import 'package:vku_app/views/LoginScreen.dart';
import 'package:vku_app/views/attendance/AttendanceSheetForCourseScreen.dart';
import 'package:vku_app/views/guests/GuestScreen.dart';
import 'package:vku_app/views/QRCode/QRScannerScreen.dart';
import 'package:vku_app/views/students/course_screen_student.dart';
import 'package:vku_app/views/students/StudentProfilePage.dart';
import 'package:http/http.dart' as http;

class StudentScreen2 extends StatefulWidget {
  StudentScreen2({super.key});
  @override
  _StudentScreen2State createState() => _StudentScreen2State();

  static void _logout() {}
}

class _StudentScreen2State extends State<StudentScreen2> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();
  String? studentCode;
  dynamic student;

  @override
  void initState(){
    initialize();
    super.initState();
  }

    Future<void> initialize() async {
    studentCode = await getSessionId();
    debugPrint('studentCode: $studentCode');
    setState(() {
      student = getStudentByStudentCode(studentCode!);
      // selectedCourses = selectedCourses;
    });
    // debugPrint("Student:  ${student.name}" );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: white,
        canvasColor: canvasColor,
        // scaffoldBackgroundColor: scaffoldBackgroundColor,
        scaffoldBackgroundColor: white,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 46,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      home: Builder(
        builder: (context) {
          final isSmallScreen = MediaQuery.of(context).size.width < 600;
          return Scaffold(
            key: _key,
            appBar: isSmallScreen
                ? AppBar(
                    backgroundColor: canvasColor,
                    title: Text(_getTitleByIndex(_controller.selectedIndex)),
                    leading: IconButton(
                      onPressed: () {
                        // if (!Platform.isAndroid && !Platform.isIOS) {
                        //   _controller.setExtended(true);
                        // }
                        _key.currentState?.openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    ),
                    actions: <Widget>[
                      IconButton(
                          icon: const Icon(Icons.qr_code),
                          onPressed: () {
                            // Get.toNamed('/QRscanner');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const QRScannerScreen(),
                              ),
                            );
                          })
                    ],
                  )
                : null,
            drawer: ExampleSidebarX(controller: _controller),
            body: Row(
              children: [
                if (!isSmallScreen) ExampleSidebarX(controller: _controller),
                Expanded(
                  child: Center(
                    child:  _ScreensExample(
                      controller: _controller,
                      studentCode:  studentCode,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static void _logout() {
    saveSessionRole("");
    debugPrint('logout success with role: ${getSessionRole()}');
    Navigator.pushNamedAndRemoveUntil(
      Get.context!,
      '/login', // Đường dẫn của màn hình đăng nhập
      (route) => false, // Xóa tất cả các màn hình khác trong stack
    );
  }
}

void loginSuccess(String userRole) {
  // Xử lý logic khi đăng nhập thành công
  // ...
  if (userRole == 'Student') {
    Get.toNamed('student');
  } else if (userRole == 'Professor') {
    Get.toNamed('professor');
  }
}

class ExampleSidebarX extends StatelessWidget {
   ExampleSidebarX({
    super.key,
    required SidebarXController controller,
  }) : _controller = controller;
  Future<String> weekF = getCurrentWeek();
  int week = getCurrentWeekI();
  // getCurrentWeek().then((value) => week = value);
  final SidebarXController _controller;
  void initState() {
    // super.initState();
    // week = '48';
  }

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: scaffoldBackgroundColor,
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        hoverTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      footerDivider: divider,
     headerBuilder: (context, extended) {
  return Container(
    height: 100,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Image.network(
            'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
            // fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Xin chào, ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Tuần học thứ $week',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
},
      items: [
        SidebarXItem(
          icon: Icons.people,
          label: 'Thời khóa biểu',
          onTap: () {
            debugPrint('Home');
          },
        ),
        const SidebarXItem(
          icon: Icons.calendar_today,
          label: 'Lý lịch sinh viên',
        ),
        const SidebarXItem(
          icon: Icons.class_outlined,
          label: 'QR của tôi',
        ),
        // const SidebarXItem(
        //   icon: Icons.flight_class,
        //   label: 'Điểm danh',
        // ),
        SidebarXItem(
            // ignore: deprecated_member_use
            icon: Icons.logout,
            label: 'Đăng xuất',
            onTap: () {
              _StudentScreen2State._logout();
            }),
      ],
    );
  }
}

int getCurrentWeekI() {
  return 47;
}


Future<String>  getCurrentWeek() async {
  final response = await http.get(Uri.parse('$BASE_URL/getCurrentWeek'));
  if (response.statusCode == 200) {
    final weekData = jsonDecode(response.body);
    debugPrint('response.body: ${response.body}');
    return response.body;
  } else {
    throw Exception('Failed to fetch current week data');
  }
}

class _ScreensExample extends StatelessWidget {
  final studentCode;

  const _ScreensExample({
    super.key,
    required this.controller,
    required  this.studentCode,
  });
  final SidebarXController controller;
  

// void loginSuccess(String userRole) {
//     // Xử lý logic khi đăng nhập thành công
//     // ...
//     if (userRole == 'Student') {
//       Get.toNamed('student');
//     } else if (userRole == 'Professor') {
//       Get.toNamed('professor');
//     }
//   }
  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    return  AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // final pageTitle = _getTitleByIndex(controller.selectedIndex);
        switch (controller.selectedIndex) {
          case 0:
           if (studentCode != null) {
            return CourseScreenStudent(studentCode: studentCode);
          } else {
            // Xử lý trường hợp studentCode không có giá trị
            return Center(
              child: Text('Không có dữ liệu sinh viên'),
            );
          }
            debugPrint('studentCode in class ScreenExample: $studentCode');
          // return ListView.builder(
          //   padding: const EdgeInsets.only(top: 10),
          //   itemBuilder: (context, index) => Container(
          //     height: 100,
          //     width: double.infinity,
          //     margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
          //     // decoration: BoxDecoration(
          //     //   borderRadius: BorderRadius.circular(20),
          //     //   color: Theme.of(context).canvasColor,
          //     //   boxShadow: const [BoxShadow()],
          //     // ),
          //   ),
          // );
          case 1:
            return  StudentProfilePage(studentCode);
            // return const LoginScreen(loginSuccess);
          case 2:
            // return AttendanceSheetForCourseScreen(course: course);
          // case 2:
          //   return FutureBuilder<Guest>(
          //     future: fetchGuestData(),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasData) {
          //         final guest = snapshot.data!;
          //         return GuestScreen(guest: guest);
          //       } else if (snapshot.hasError) {
          //         return Text('Error: ${snapshot.error}');
          //       } else {
          //         return CircularProgressIndicator();
          //       }
          //     },
          //   );
          default:
            return const LoginScreen(loginSuccess);
          // default:
          //   return Text(
          //     pageTitle,
          //     style: theme.textTheme.headlineSmall,
          //   );
        }
      },
    );
  }

  Future<Guest> fetchGuestData() async {
    String url =
        '$BASE_URL/guests/scanQR'; // Thay đổi URL thành URL thực tế của API
    String qrData = '1';
    // final response = await http.post(Uri.parse('API_URL'));
    var response = await http.post(Uri.parse(url), body: {'guestQR': qrData});

    if (response.statusCode == 200) {
      Guest guest = Guest.fromJson(jsonDecode(response.body));
      return guest;
    } else {
      throw Exception('Failed to fetch guest data');
    }
  }
}

// void loginSuccess(String userRole) {
//     // Xử lý logic khi đăng nhập thành công
//     // ...
//     if (userRole == 'Student') {
//       Get.toNamed('student');
//     } else if (userRole == 'Professor') {
//       Get.toNamed('professor');
//     }
//   }
String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Home';
    case 1:
      return 'Search';
    case 2:
      return 'People';
    case 3:
      return 'Favorites';
    case 4:
      return 'Custom iconWidget';
    case 5:
      return 'Profile';
    case 6:
      return 'Settings';
    default:
      return 'Not found page';
  }
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);
