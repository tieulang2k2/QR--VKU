import 'package:flutter/material.dart';
import 'package:vku_app/models/student.dart';
import 'package:vku_app/services/students/StudentService.dart';
import 'package:vku_app/utils/data/shared_preferences_manager.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Profile Information',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: EditProfilePage(),
//     );
//   }
// }

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _ngayCapController = TextEditingController();
  final TextEditingController _ngayCapCCCDController = TextEditingController();
  final TextEditingController _ngayKetNapController = TextEditingController();
  String _selectedDoanThe = 'Đoàn viên';
  bool _showFamilyInfo = false;
  String? studentCode;
  @override
  void initState() {
    super.initState();
    initializeProfessorId();
    // selectedCourses = fetchProfessorCourses(professorId!);
  }

  Future<void> initializeProfessorId() async {
    studentCode = await getSessionId();
    debugPrint('studentCode: $studentCode');
    debugPrint('');
    setState(() {
      // selectedCourses = selectedCourses;
    });
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Student>(
      future: getStudentByStudentCode(studentCode!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error get student in edit_profile: ${snapshot.error}'),
          );
        } else {
          final student = snapshot.data!;
          // debugPrint('student in edit_profile: $student');
          return Scaffold(
            appBar: AppBar(
              title: Text('Sửa hồ sơ'),
              // actions: [
              //   Padding(
              //     padding: EdgeInsets.only(right: 16.0),
              //     child: CircleAvatar(
              //       backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
              //     ),
              //   ),
              // ],
            ),
            // drawer: Drawer(),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phần đầu bên trái
                  Expanded(
                    flex: 2,
                    child: Card(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                NetworkImage('https://i.pravatar.cc/300'),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            student.name,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text('NGÀNH CHUYÊN NGÀNH KỸ THUẬT PHẦN MỀM (KỸ SƯ)'),
                          Text('LỚP 20SE4 MSV 20IT344'),
                          SizedBox(height: 20),
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text('Thông tin cá nhân'),
                            onTap: () {
                              setState(() {
                                _showFamilyInfo = false;
                              });
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.home),
                            title: Text('Thông tin gia đình'),
                            onTap: () {
                              setState(() {
                                _showFamilyInfo = true;
                              });
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.location_on),
                            title: Text('Địa chỉ và thường trú'),
                            // onTap: () {
                            //   setState(() {
                            //     _showFamilyInfo = false;
                            //   });
                            // },
                          ),
                          ListTile(
                            leading: Icon(Icons.contact_phone),
                            title: Text('Thông tin liên hệ'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Phần thông tin cá nhân bên phải
                  Expanded(
                    flex: 5,
                    child: _showFamilyInfo
                        ? _buildFamilyInfoCard()
                        : _buildPersonalInfoCard(context, student),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildPersonalInfoCard(BuildContext context, Student student) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thông tin cá nhân',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: _buildTextField(
                        label: 'Họ và tên',
                        initialValue: student.name,
                        enabled: false)),
                SizedBox(width: 16),
                Expanded(
                    child: _buildTextField(
                        label: 'Giới tính',
                        initialValue: student.gender ,
                        enabled: false)),
                SizedBox(width: 16),
                Expanded(
                    child: _buildTextField(
                        label: 'Ngày sinh',
                        initialValue: student.birthDay,
                        enabled: false)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: _buildTextField(
                        label: 'Nơi sinh',
                        initialValue: 'Quảng Nam',
                        enabled: false)),
                SizedBox(width: 16),
                Expanded(
                    child: _buildTextField(
                        label: 'Dân tộc',
                        initialValue: 'Kinh',
                        enabled: false)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: _buildTextField(
                        label: 'CMND',
                        initialValue: student.cccd,
                        enabled: false)),
                SizedBox(width: 16),
                Expanded(
                    child: _buildDateField(context,
                        label: 'Ngày cấp', controller: _ngayCapController)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: _buildTextField(
                        label: 'Nơi cấp', initialValue: 'Quảng Nam')),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: _buildTextField(
                        label: 'CCCD',
                        initialValue: '049202013298',
                        enabled: false)),
                SizedBox(width: 16),
                Expanded(
                    child: _buildDateField(context,
                        label: 'Ngày cấp CCCD',
                        controller: _ngayCapCCCDController)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: _buildTextField(
                        label: 'Nơi cấp CCCD',
                        initialValue: 
                            'Cục Cảnh sát quản lý hành chính về trật tự xã hội')),
              ],
            ),
            Row(
              children: [
                Expanded(child: _buildDropdownField(label: 'Đoàn thể')),
                SizedBox(width: 16),
                Expanded(
                    child: _buildDateField(context,
                        label: 'Ngày kết nạp',
                        controller: _ngayKetNapController)),
                SizedBox(width: 16),
                Expanded(
                    child: _buildTextField(
                        label: 'Tôn giáo', initialValue: 'Không')),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildTextField(
                    label: 'Thuộc diện chính sách',
                    initialValue: 'Con liệt sĩ/thương bệnh binh',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    label: 'Mã số bảo hiểm y tế',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Lưu'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Sinh viên liên hệ phòng công tác sinh viên hoặc 0236 3667 129 nếu có thay đổi chi tiết thông tin cá nhân (Áp dụng với các trường thông tin bị làm mờ)',
              style: TextStyle(color: Colors.blue),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thông tin gia đình',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('|Cha',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      _buildTextField(
                          label: 'Họ tên', initialValue: 'Phạm Văn Dũng'),
                      _buildTextField(label: 'Năm sinh', initialValue: '1968'),
                      _buildTextField(label: 'Dân tộc', initialValue: 'Kinh'),
                      _buildTextField(
                          label: 'CMND/CCCD', initialValue: '049060801712'),
                      _buildTextField(
                          label: 'Nghề nghiệp', initialValue: 'Nông'),
                      _buildTextField(
                          label: 'Nơi cư trú cha',
                          initialValue:
                              'Phú Đông, Đại Hiệp, Đại Lộc, Quảng Nam'),
                      _buildTextField(label: 'Cơ quan công tác'),
                      _buildDropdownFieldFamily(label: 'Trình độ'),
                      _buildTextField(label: 'Email'),
                      _buildTextField(label: 'SDT', initialValue: '0379965269'),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('|Mẹ',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      _buildTextField(
                          label: 'Họ tên', initialValue: 'Trần Thị Thanh Xuân'),
                      _buildTextField(label: 'Năm sinh', initialValue: '1977'),
                      _buildTextField(label: 'Dân tộc', initialValue: 'Kinh'),
                      _buildTextField(
                          label: 'CMND/CCCD', initialValue: '04817700475'),
                      _buildTextField(
                          label: 'Nghề nghiệp', initialValue: 'Nông'),
                      _buildTextField(
                          label: 'Nơi cư trú mẹ',
                          initialValue:
                              'Phú Đông, Đại Hiệp, Đại Lộc, Quảng Nam'),
                      _buildTextField(label: 'Cơ quan công tác'),
                      _buildDropdownFieldFamily(label: 'Trình độ'),
                      _buildTextField(label: 'Email'),
                      _buildTextField(label: 'SDT', initialValue: '0384902993'),
                    ],
                  ),
                ),
              ],
            ),
            Text('|Anh chị ruột',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildTextField(label: 'Anh chị em'),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Lưu'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Sinh viên liên hệ phòng công tác sinh viên hoặc 0236 3667 129 nếu có thay đổi chi tiết thông tin cá nhân (Áp dụng với các trường thông tin bị làm mờ)',
              style: TextStyle(color: Colors.blue),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String label, String? initialValue, bool enabled = true}) {
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.text : SystemMouseCursors.forbidden,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          initialValue: initialValue,
          enabled: enabled,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context,
      {required String label, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _selectDate(context, controller),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
          child: Text(controller.text.isEmpty ? 'mm/dd/yyyy' : controller.text),
        ),
      ),
    );
  }

  Widget _buildDropdownField({required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _selectedDoanThe,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        onChanged: (String? newValue) {
          setState(() {
            _selectedDoanThe = newValue!;
          });
        },
        items: <String>['Đoàn viên', 'Đảng viên', 'Không']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDropdownFieldFamily({required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        onChanged: (String? newValue) {
          setState(() {
            // Handle the new value if needed
          });
        },
        items: <String>['Cao đẳng', 'Đại học', 'Sau đại học', 'Khác']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
