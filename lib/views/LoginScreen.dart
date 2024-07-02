import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vku_app/enums/enums.dart';
import 'package:vku_app/models/student.dart';
import 'package:vku_app/services/students/StudentService.dart';
import 'package:vku_app/utils/NotificationUtils.dart';
import 'package:vku_app/utils/api_consts.dart';

import 'dart:convert';

import 'package:vku_app/utils/data/shared_preferences_manager.dart';
import 'package:vku_app/views/officers/professor_screen.dart';
import 'package:vku_app/views/students/student_screen2.dart';

final headers = {
  'Content-Type': 'application/json',
  // 'Access-Control-Allow-Origin': '*', // Cho phép truy cập từ mọi nguồn
  // 'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS', // Cho phép các phương thức
  // 'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization', // Cho phép các header
};

// Tạo class để gửi yêu cầu đăng nhập
class LoginRequest {
  String userID;
  String password;

  LoginRequest({
    required this.userID,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'password': password,
    };
  }
}

// Enum để xác định vai trò người dùng

class LoginScreen extends StatefulWidget {
  final Function loginSuccessCallback;

  const LoginScreen(this.loginSuccessCallback, {super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  UserRole? selectedRole;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange.shade900,
              Colors.orange.shade800,
              Colors.orange.shade400,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1300),
                    child: const Text(
                      "Welcome Back",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    FadeInUp(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: [
                              // ... other widgets
                              DropdownButtonFormField<UserRole>(
                                value: selectedRole,
                                onChanged: (UserRole? value) {
                                  setState(() {
                                    selectedRole = value;
                                  });
                                },
                                items: UserRole.values.map((UserRole role) {
                                  return DropdownMenuItem<UserRole>(
                                    value: role,
                                    child:
                                        Text(role.toString().split('.').last),
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  labelText: 'Select Role',
                                  labelStyle: TextStyle(
                                    color: Colors.orange.shade800,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.orange.shade800,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.orange.shade400,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.orange.shade900,
                                    ),
                                  ),
                                ),
                              ),
                              // ... other widgets
                            ],
                          ),
                        ),
                      ),
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1400),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(225, 95, 27, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                              ),
                              child: TextField(
                                controller: _userIDController,
                                decoration: const InputDecoration(
                                  hintText: "Email or Phone number",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                              ),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    isLoading
                        ? const CircularProgressIndicator()
                        : FadeInUp(
                            duration: const Duration(milliseconds: 1500),
                            child: GestureDetector(
                              onTap: _login,
                              child: Container(
                                height: 50,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.orange.shade900,
                                ),
                                child: const Center(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 40),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1600),
                      child: GestureDetector(
                        onTap: () {
                          // TODO: Implement forgot password logic
                        },
                        child:const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginFailedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Failed'),
        content: const Text('Invalid User ID or Password. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleRoleUndefined() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Role Undefined'),
        content: const Text('The role for this user is undefined.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (selectedRole == null) {
      // Hiển thị thông báo nếu người dùng không chọn role
      _handleRoleUndefined();
      return;
    }

    setState(() {
      isLoading = true;
    });

    String userID = _userIDController.text;
    String password = _passwordController.text;

    String apiUrl = selectedRole == UserRole.student
        ? '$BASE_URL/students/login'
        : selectedRole == UserRole.professor
            ? '$BASE_URL/officers/login'
            : '';

    if (apiUrl.isEmpty) {
      // Hiện thị sẽ báo nếu người dùng không chọn role

      // Hiển thị thông báo nếu role không được xác định
      _handleRoleUndefined();
      return;
    }

    try {
      debugPrint('API URL is  $apiUrl');
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode({
          'username': userID,
          'password': password,
        }),
      );
      debugPrint(
          'Login response: ${response.body} - User ID: $userID - Password: $password');
      debugPrint('Login status code: ${response.statusCode}');
      // Student student = loginStudent(userID,)
      if (response.statusCode == 200) {
        // final json = jsonDecode(response.body);
        
        // Đăng nhập thành công, chuyển hướng đến màn hình tương ứng
        if (selectedRole == UserRole.student) {
          saveSessionRole(UserRole.student.name);
          debugPrint("Session role: ${UserRole.student.name}");
          final responseData = jsonDecode(response.body);
          debugPrint("Response data: $responseData ");
          final id = responseData['studentCode'].toString();
          saveSessionId(id);
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              // builder: (context) =>const StudentDetailsScreen(student: studentD,),
              builder: (context) =>  StudentScreen2(),
            ),
          );
        } else if (selectedRole == UserRole.professor) {
          saveSessionRole(UserRole.professor.name);
          // Lấy dữ liệu từ response
          final responseData = jsonDecode(response.body);
          final id = responseData['id'].toString();

          // Lưu id vào session
          saveSessionId(id);

          // Gọi API để lấy danh sách lớp học phần

          // String loggedInProfessorId = id;
          // Create a list of AttendanceSheet objects for professor courses

          // Chuyển hướng đến màn hình ProfessorScreen và truyền danh sách lớp học phần
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfessorScreen(),
            ),
          );
        }
      } else {
        // Đăng nhập thất bại, hiển thị thông báo lỗi
        _showLoginFailedDialog();
        // NotificationUtils.showNotificationDialog(context, "Lỗi login");
      }
    } catch (e) {
      // Xử lý exception và hiển thị thông báo lỗi
      debugPrint('Error logging in: $e');
      // NotificationUtils.showNotificationDialog(context, "Lỗi login");
      _showLoginFailedDialog();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
