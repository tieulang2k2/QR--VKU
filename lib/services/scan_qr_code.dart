// import 'package:app/utils/api_consts.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// List<CameraDescription> cameras = [];

// Future<void> initCamera() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   cameras = await availableCameras();
// }

// Future<XFile> takePicture() async {
//   if (cameras == null) {
//     await initCamera();
//   }

//   final CameraController controller = CameraController(
//     cameras[0], // Chọn camera mặc định
//     ResolutionPreset.medium, // Chọn độ phân giải
//   );

//   await controller.initialize();

//   if (!controller.value.isInitialized) {
//     throw CameraException('Camera initialization failed.', 'failed');
//   }

//   XFile picture = await controller.takePicture();
//   await controller.dispose();

//   return picture;
// }

// Future<String> readQRCode() async {
//   try {
//     XFile picture = await takePicture();
//     List<int> imageBytes = await picture.readAsBytes();

//     // Gửi ảnh lên API
//     String url = "$BASE_URL/readQR";
//     http.Response response = await http.post(
//       Uri.parse(url),
//       body: imageBytes,
//       headers: {
//         "Content-Type": "image/jpeg", // Đảm bảo đúng định dạng ảnh
//       },
//     );

//     if (response.statusCode == 200) {
//       String qrData = response.body;
//       // Thực hiện các hành động tương ứng với tham số và dữ liệu từ mã QR
//       print("QR code data: $qrData");
//       return qrData;
//     } else {
//       print("Failed to read QR code. Status code: ${response.statusCode}");
//       print(url);

//       throw Exception('Failed to read QR code.');
//     }
//   } catch (e) {
//     throw Exception('Failed to read QR code.' + e.toString());
//   }
// }
