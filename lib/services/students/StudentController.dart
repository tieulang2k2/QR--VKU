


// class StudentController extends GetxController {
//   RxList<Student> students = <Student>[].obs;
//   RxBool isLoading = false.obs;

//   @override
//   void onInit() {
//     fetchStudents();
//     super.onInit();
//   }

//   Future<void> fetchStudents() async {
//     try {
//       isLoading.value = true;

//       var response = await http.get(Uri.parse('YOUR_API_URL'));

//       if (response.statusCode == 200) {
//         var jsonData = json.decode(response.body);

//         students.value = (jsonData as List)
//             .map((data) => Student.fromJson(data))
//             .toList();
//       } else {
//         // Xử lý lỗi nếu cần
//       }
//     } catch (e) {
//       // Xử lý lỗi nếu cần
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> addStudent(Student student) async {
//     try {
//       isLoading.value = true;

//       var response = await http.post(
//         Uri.parse('YOUR_API_URL'),
//         body: json.encode(student.toJson()),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 201) {
//         fetchStudents();
//       } else {
//         // Xử lý lỗi nếu cần
//       }
//     } catch (e) {
//       // Xử lý lỗi nếu cần
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> updateStudent(Student student) async {
//     try {
//       isLoading.value = true;

//       var response = await http.put(
//         Uri.parse('YOUR_API_URL/${student.studentCode}'),
//         body: json.encode(student.toJson()),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         fetchStudents();
//       } else {
//         // Xử lý lỗi nếu cần
//       }
//     } catch (e) {
//       // Xử lý lỗi nếu cần
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // void navigateToDetailsScreen(Student student) {
//   //   Get.to(DetailsScreen(student: student));
//   // }

//   // void navigateToCreateStudentScreen() {
//   //   Get.to(CreateStudentScreen());
//   // }
// }