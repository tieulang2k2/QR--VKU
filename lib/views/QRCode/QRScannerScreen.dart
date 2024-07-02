import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:vku_app/enums/enums.dart';
import 'package:vku_app/models/guest.dart';
import 'package:vku_app/utils/NotificationUtils.dart';
import 'package:vku_app/utils/api_consts.dart';
import 'package:vku_app/utils/data/shared_preferences_manager.dart';
import 'package:vku_app/views/guests/GuestScreen.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  late final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  String scannedData = 'Chưa quét được dữ liệu';

  @override
  void dispose() {
    debugPrint('QRScannerScreen dispose');
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(child: Text(' $scannedData ')),
          ),
          const Expanded(
            flex: 1,
            child: Center(
              child: Text('Đặt mã QR trong phạm vi quét.'),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      // Xử lý dữ liệu quét được từ mã QR ở đây (scanData)
      debugPrint('Scanned data: ${scanData.code}');

      controller.pauseCamera();
      // checkQRCode("1");
      setState(() {
        scannedData = scanData.code.toString();
        handleApiResponse(scannedData);
      });
      if (await canLaunchUrl(scannedData as Uri)) {
        await launchUrl(scannedData as Uri);
      } else {
        // Copy thông tin
        Clipboard.setData(ClipboardData(text: scannedData));
        // Hiển thị thông báo hoặc thực hiện hành động khác tùy thuộc vào yêu cầu của bạn
      }
    });
  }

  Future<void> handleApiResponse(String scannedData) async {
    String? role = await getSessionRole();
    debugPrint('role in handleApiResponse: $role');
    var dataSplited = scannedData.split('||');
    if (dataSplited.length > 1) {
      // if (true) {
      dynamic param = scannedData.split('||')[0];
      // final jsonData = jsonDecode(response.body);
      // final responseObj = Response.fromJson(jsonData);
      debugPrint('param: $param');
      // param = QR_Parameters.ATTENDANCE_QR.name;
      if (param == QR_Parameters.ATTENDANCE_QR.name && role == UserRole.student.name) {
        String? studentCode = await getSessionId();

        debugPrint('Phản hồi có giá trị msg là SCAN_ATTENDANCE.');
        debugPrint('studentCode: $studentCode');
        scanAttendanceQRCode(studentCode, dataSplited[1]);
      } else if (param == QR_Parameters.GUEST.name) {
        debugPrint('Phản hồi có giá trị msg là GUEST. $param - QR: ${dataSplited[1]}');
        checkQRCode(dataSplited[1]);
      } else if (param == QR_Parameters.STUDENT.name) {
        scanStudent( dataSplited[1]);
        param = QR_Parameters.STUDENT;
      } else {
        debugPrint('Lỗi xảy ra với param: $param');
      }
    } else {
      debugPrint('Lỗi trong quá trình gọi API: ${scannedData}');
    }
    controller.resumeCamera();
  }

  Future<void> scanAttendanceQRCode(
      String? studentCode, String qrCodeInfo) async {
    try {
      String url = '$BASE_URL/student/scanAttendanceQR';
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'studentCode': studentCode,
          'qrCodeInfo': qrCodeInfo,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                NotificationScreen(message: 'Đã điểm danh thành công'),
          ),
        );
        debugPrint('Đã điểm danh thành công');
        // Hiển thị thông báo "Đã điểm danh thành công" tại đây
      } else {
        NotificationUtils.showNotificationDialog(context ,response.body.toString());
        debugPrint('Lỗi trong quá trình gọi API: ${response.body}');
        // Hiển thị thông báo lỗi tại đây
      }
    } catch (error) {
      debugPrint('Lỗi trong quá trình gọi API: $error');
      // Hiển thị thông báo lỗi tại đây
    }
  }
  void scanStudent(String qrData)  {

    // String url = '$BASE_URL/student/';
    // var response = await http.get(
    //   Uri.parse(url),
    //   headers: {'Content-Type': 'application/json'},
    // );
    NotificationUtils.showNotificationDialog(context, "Đang quét sinh viên với mã : $qrData");
  }
  void checkQRCode(String qrData) async {
    String url =
        '$BASE_URL/guests/scanQR'; // Thay đổi URL thành URL thực tế của API

    try {
      debugPrint('url: $url');
      var response = await http.post(Uri.parse(url), body: {'guestQR': qrData});
      debugPrint(
          'response: ${response.body} - ${response.statusCode} - ${response.body.toString()}');
      if (response.statusCode == 200) {
        // Nếu respone trả về status == 200
        // Chuyển sang màn hình GuestScreen và truyền dữ liệu guest (response.body) qua màn hình mới
        debugPrint('dk if: response.body: ${response.body}');
        Guest guest = Guest.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        debugPrint('guest: $guest');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GuestScreen(guest: guest),
          ),
        );
      } else if (response.statusCode == 404) {
        NotificationUtils.showNotificationDialog(
            context, 'Không tìm thấy khách mời');
        // Nếu respone trả về status == 404
        // Hiển thị thông báo lỗi
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: Text('Lỗi'),
        //     content: Text('Không tìm thấy khách mời.'),
        //     actions: [
        //       TextButton(
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //         child: Text('Đóng'),
        //       ),
        //     ],
        //   ),
        // );
      } else {
        // Nếu respone trả về status khác 200 và 404
        // Hiển thị thông báo lỗi
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: Text('Lỗi'),
        //     content: Text('Đã xảy ra lỗi khi gọi API.'),
        //     actions: [
        //       TextButton(
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //         child: Text('Đóng'),
        //       ),
        //     ],
        //   ),
        // );
        NotificationUtils.showNotificationDialog(
            context, 'Đã xảy ra lỗi khi gọi API');
      }
    } catch (e) {
      // Nếu có lỗi trong quá trình gọi API
      // Hiển thị thông báo lỗi
      e.printError();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lỗi'),
          content: const Text('Đã xảy ra lỗi khi gọi API.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    }
  }
}
