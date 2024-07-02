import 'package:flutter/material.dart';
import 'package:vku_app/models/student.dart';
import 'package:vku_app/services/students/StudentService.dart';
import 'package:vku_app/utils/api_consts.dart';
import 'package:vku_app/views/students/edit.dart';
// Assuming this is the path to the Student model

class StudentProfilePage extends StatefulWidget {
  final String studentCode;
  const StudentProfilePage(this.studentCode, {super.key});

  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Student>(
      future: getStudentByStudentCode(widget.studentCode),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final student = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 250,
                    height: 600,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                              'https://cdn3.iconfinder.com/data/icons/vector-icons-6/96/256-512.png'),
                        ),
                        SizedBox(height: 16),
                        Text(
                          student.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline_rounded),
                            SizedBox(width: 4),
                            Text(
                              'MSV ${student.studentCode}',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.class_outlined),
                            SizedBox(width: 4),
                            Text(
                              'LỚP ${student.className}',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.school),
                            SizedBox(width: 4),
                            Text(
                              'KHÓA HỌC: 2020-2025',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.local_mall_outlined),
                            SizedBox(width: 4),
                            Text(
                              'CHUYÊN NGÀNH\nKỸ SƯ PHẦN MỀM',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'KHOA KHOA HỌC MÁY TÍNH',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon(Icons.edit),
                            SizedBox(
                              width: 4,
                            ),
                            //tạo nút button sửa hồ sơ
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfilePage()));
                                // return EditProfilePage();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 101, 226,
                                    178), // Set the button's background color to light green
                              ),
                              child: Text('Sửa hồ sơ'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _showQRCode(student.studentCode);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 228, 47,
                                    23), // Set the button's background color to light green
                              ),
                              child: Text('QR của tôi'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 16), // Khoảng cách giữa các khung thông tin
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: double.infinity, // Kích thước khung cố định
                            height: 200, // Kích thước khung cố định
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Thông tin cá nhân:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Họ và tên: ${student.name}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            'Ngày tháng năm sinh: ${student.birthDay}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            'Giới tính: ',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'CCCD: ${student.cccd}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            'Tôn giáo: không',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          Container(
                            width: double.infinity, // Kích thước khung cố định
                            height: 200, // Kích thước khung cố định
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            // child: const Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: <Widget>[
                            //     Text(
                            //       'Thường trú và địa chỉ:',
                            //       style: TextStyle(
                            //         fontSize: 18,
                            //         fontWeight: FontWeight.bold,
                            //       ),
                            //     ),
                            //     SizedBox(height: 16),
                            //     Text(
                            //       'Hộ khẩu thường trú: Thôn/tổ a, xã/phường b, quận/huyện c, tỉnh/thành phố d',
                            //       style: TextStyle(fontSize: 16),
                            //     ),
                            //     SizedBox(height: 16),
                            //     Text(
                            //       'Địa chỉ liên lạc: Thôn a, xã b, huyện c, tỉnh d',
                            //       style: TextStyle(fontSize: 16),
                            //     ),
                            //   ],
                            // ),
                          ),
                          const SizedBox(height: 32),
                          Container(
                            width: double.infinity, // Kích thước khung cố định
                            height: 200, // Kích thước khung cố định
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Thông tin liên hệ:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Email: ${student.email}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Số điện thoại: ${student.phoneNumber}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Zalo: ${student.phoneNumber}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                // SizedBox(height: 16),
                                // Text(
                                //   'Facebook: aaa',
                                //   style: TextStyle(fontSize: 16),
                                // ),
                              ],
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
      },
    );
  }

  void _showQRCode(String? studentCode) {

    debugPrint('path: $imagePath/$studentCode-QRCode.png');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('QRCode'),
          content: Image.network(
            '$imagePath/$studentCode-QRCode.png',
          ),
          // content: Column(
          //   mainAxisSize: MainAxisSize.min,  
          //   children: <Widget>[
          //     TextField(
          //       controller: contentController,
          //       keyboardType: TextInputType.text,
          //       decoration: const InputDecoration(
          //         hintText: 'Nhập nội dung buổi học',
          //       ),
          //     ),
          //   ],
          // ),
          
        );
      },
    );
  }
}


// Widget build(BuildContext context) {
//     return FutureBuilder<Student>(
//       future: widget.student,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text('Error: ${snapshot.error}'),
//           );
//         } else {
//           final student = snapshot.data!;
//           return Scaffold(
//             appBar: AppBar(
//               title: Text('Student Profile'),
//             ),
//             body: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CircleAvatar(
//                     radius: 60,
//                     backgroundImage: NetworkImage(student.qrcodeImage!),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     student.name,
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Icon(Icons.info_outline_rounded),
//                       SizedBox(width: 4),
//                       Text(
//                         'Student Code: ${student.studentCode}',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Icon(Icons.class_outlined),
//                       SizedBox(width: 4),
//                       Text(
//                         'Class: ${student.className}',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Icon(Icons.school),
//                       SizedBox(width: 4),
//                       Text(
//                         'Curriculum: ${student.curriculum}',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Contact Information:',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Icon(Icons.email),
//                       SizedBox(width: 4),
//                       Text(
//                         'Email: ${student.email ?? 'N/A'}',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Icon(Icons.phone),
//                       SizedBox(width: 4),
//                       Text(
//                         'Phone Number: ${student.phoneNumber ?? 'N/A'}',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Icon(Icons.phone),
//                       SizedBox(width: 4),
//                       Text(
//                         'Family Phone Number: ${student.familyPoneNumber ?? 'N/A'}',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Personal Information:',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Icon(Icons.cake),
//                       SizedBox(width: 4),
//                       Text(
//                         'Birthday: ${student.birthDay ?? 'N/A'}',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Icon(Icons.location_on_outlined),
//                       SizedBox(width: 4),
//                       Text(
//                         'Birthplace: ${student.birthPlace ?? 'N/A'}',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Icon(Icons.wc),
//                       SizedBox(width: 4),
//                       Text(
//                         'Gender: ${student.gender ?? 'N/A'}',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Additional Information:',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Icon(Icons.account_balance),
//                       SizedBox(width: 4),
//                       Text(
//                         'CCCD: ${student.cccd ?? 'N/A'}',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Icon(Icons.school),
//                       SizedBox(width: 4),
//                       Text(
//                         'Major: ${student.majors ?? 'N/A'}',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Icon(Icons.school),
//                       SizedBox(width: 4),
//                       Text(
//                         'Faculty: ${student.khoa ?? 'N/A'}',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   )               
//                   ],
//               ),
//             ),
//           );
//         }
//       }
//     );
//   }