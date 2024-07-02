import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vku_app/enums/enums.dart';
import 'package:vku_app/utils/data/shared_preferences_manager.dart';
import 'package:vku_app/views/LoginScreen.dart';
import 'package:vku_app/views/officers/professor_screen.dart';
import 'package:vku_app/views/students/StudentProfilePage.dart';
import 'package:vku_app/views/students/student_screen2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Your App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: const MaterialColor(0xFF0D7A51, {
          50: Color.fromRGBO(13, 162, 81, 0.1),
          100: Color.fromRGBO(13, 162, 81, 0.2),
          200: Color.fromRGBO(13, 162, 81, 0.3),
          300: Color.fromRGBO(13, 162, 81, 0.4),
          400: Color.fromRGBO(13, 162, 81, 0.5),
          500: Color.fromRGBO(13, 162, 81, 0.6),
          600: Color.fromRGBO(13, 162, 81, 0.7),
          700: Color.fromRGBO(13, 162, 81, 0.8),
          800: Color.fromRGBO(13, 162, 81, 0.9),
          900: Color.fromRGBO(13, 162, 81, 1),
        }),
      ),
      initialRoute: '/',
      getPages: [
        // GetPage(name: '/', page: () =>  StudentScreen2()),
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const LoginScreen(loginSuccess)),
        GetPage(name: '/student', page: () => StudentScreen2()),
        GetPage(name: '/professor', page: () => const ProfessorScreen()),
      ],
    );
  }
}

void loginSuccess(String userRole) {
  // Xử lý logic khi đăng nhập thành công
  // ...
  if (userRole == 'Student') {
    Get.toNamed('/student');
  } else if (userRole == 'Professor') {
    Get.toNamed('/professor');
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Hiển thị splash screen khi ứng dụng khởi chạy
    // Kiểm tra session ở đây
    getSessionRole().then((role) {
      debugPrint("Session role in splashScreen: $role");
      if (role == UserRole.student.name) {
        Get.toNamed('/student');
        // return StudentScreen();
      } else if (role == UserRole.professor.name) {
        // return ProfessorScreen()
        Get.toNamed('professor');
      } else {
        debugPrint("No session found $role");
        Get.toNamed('/login');
      }
    }).catchError((error) {
      // Xử lý lỗi ở đây
      debugPrint("Error occurred: $error");
      // Hiển thị màn hình lỗi hoặc thông báo lỗi
      Get.toNamed('/error');
    });

    // Mặc định trả về SplashScreen cho đến khi kiểm tra session hoặc xử lý lỗi hoàn thành
    // return LoginScreen(loginSuccess);
    return Container();
  }
}



// class AuthenticationWrapper extends StatefulWidget {
//   @override
//   _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
// }

// class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  // String? role;

//   void loginSuccess(String userRole) {
//     setState(() {
//       role = userRole;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // get sessionId from shared preferences
    
    

//     if (role == null) {
//       // return LoginScreen(loginSuccess);
//       return LoginScreen(loginSuccess);
//     } else if (role == 'Student') {
//       return StudentScreen();
//     } else if (role == 'Professor') {      
//         // return LoginScreen(loginSuccess);
//       return ProfessorScreen();

//     } else {
//       return LoginScreen(loginSuccess);
//     }
//   }
// }