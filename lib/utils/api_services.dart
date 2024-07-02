import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vku_app/utils/api_consts.dart';

// Future<void> saveSessionId(String sessionId) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setString('sessionId', sessionId);
// }

// // Lấy session ID hoặc token từ shared preferences
// Future<String?> getSessionId() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('sessionId');
// }

// Future<void> saveSessionRole(String role) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setString('role', role);
//   // await prefs.setString('role', "Professor");
// }
// Future<String?> getSessionRole() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('role');
// }

class APIServices {

  static Future<List<dynamic>> getData(
      {required String target, String? limit}) async {
    try {
      var uri = Uri.http(
          BASE_URL,
          "/$target",
          target == "products"
              ? {
                  "offset": "0",
                  "limit": limit,
                }
              : {});
      var response = await http.get(uri);

      // print("response ${jsonDecode(response.body)}");
      var data = jsonDecode(response.body);
      List tempList = [];
      if (response.statusCode != 200) {
        throw data["message"];
      }
      for (var v in data) {
        tempList.add(v);
        // print("V $v \n\n");
      }
      return tempList;
    } catch (error) {
      print("An error occured $error");
      throw error.toString();
    }
  }
  static Future<bool> loginWithStudentID(String studentID) async {
    const url = 'https://your-api-url/login'; // Thay đổi URL API đăng nhập tại đây
    final response = await http.post(
      Uri.parse(url),
      body: {'userID': studentID}, // Gửi mã sinh viên đến API

    );

    if (response.statusCode == 200) {
      // Đăng nhập thành công, API trả về mã trạng thái 200
      // Xử lý logic sau khi đăng nhập thành công
      return true;
    } else {
      // Xử lý logic khi đăng nhập không thành công
      return false;
    }
  }


}
