import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Assuming this is the path to the Student model
import 'package:sidebarx/sidebarx.dart';
import 'package:vku_app/models/course.dart';
import 'package:vku_app/models/guest.dart';
import 'package:vku_app/services/officers/LectureService.dart';
import 'package:vku_app/utils/api_consts.dart';
import 'package:vku_app/utils/data/shared_preferences_manager.dart';
import 'package:vku_app/views/LoginScreen.dart';
import 'package:vku_app/views/guests/GuestScreen.dart';
import 'package:vku_app/views/QRCode/QRScannerScreen.dart';
import 'package:vku_app/views/officers/course_screen.dart';
import 'package:vku_app/views/officers/professor_screen2.dart';
import 'package:http/http.dart' as http;
import 'package:vku_app/views/students/edit.dart';

class ProfessorScreen extends StatefulWidget {
  const ProfessorScreen({super.key});

  get attendanceSheet => null;

  @override
  _ProfessorScreenState createState() => _ProfessorScreenState();
}

class _ProfessorScreenState extends State<ProfessorScreen> {
  List<Course> selectedCourses = [];

  get detailAttendances => null;

  String? professorId;

  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lecture Profile',
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
            drawer: OfficerSidebarX(controller: _controller),
            body: Row(
              children: [
                if (!isSmallScreen) OfficerSidebarX(controller: _controller),
                Expanded(
                  child: Center(
                    child: _ScreensExample(
                      controller: _controller,
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

class OfficerSidebarX extends StatelessWidget {
  const OfficerSidebarX({
    super.key,
    required SidebarXController controller,
  }) : _controller = controller;

  final SidebarXController _controller;

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
        return SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.network(
                'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.people,
          label: 'Thông tin giản viên',
          onTap: () {
            debugPrint('Home');
          },
        ),
        const SidebarXItem(
          icon: Icons.calendar_today,
          label: 'Xem lịch dạy',
        ),
        const SidebarXItem(
          icon: Icons.class_outlined,
          label: 'Học phần',
        ),
        const SidebarXItem(
          icon: Icons.flight_class,
          label: 'Điểm danh',
        ),
        SidebarXItem(
            // ignore: deprecated_member_use
            icon: Icons.logout,
            label: 'Đăng xuất',
            onTap: () {
              _ProfessorScreenState._logout();
            }),
      ],
    );
  }
}

class _ScreensExample extends StatelessWidget {

  const _ScreensExample({
    super.key,
    required this.controller,
  });
  final SidebarXController controller;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final pageTitle = _getTitleByIndex(controller.selectedIndex);
        debugPrint('selectedIndex: ${controller.selectedIndex} -   pageTitle: $pageTitle');
        switch (controller.selectedIndex) {
          case 0:
            return CourseScreen(officerId: '1');
           

          case 1:
            return const ProfessorScreen2();
          case 2:
            return FutureBuilder<Guest>(
              future: fetchGuestData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final guest = snapshot.data!;
                  return GuestScreen(guest: guest);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            );
          case 3:
            return EditProfilePage();
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
