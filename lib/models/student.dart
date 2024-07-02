class Student {
  final String studentCode;
  final String password;
  final String? cccd;
  final String name;
  final dynamic majors;
  final dynamic khoa;
  final dynamic curriculum;
  final String? method;
  final String? birthDay;
  final String? email;
  final String? phoneNumber;
  final String? familyPoneNumber;
  final String? address;
  final String? gender;
  final String? birthPlace;
  final String className;
  final String? groupCodes;
  final bool status;
  final DateTime createTime;
  final DateTime updateTime;
  final String? qrcodeImage;
  final String decyptPassWord;

  Student({
    required this.studentCode,
    required this.password,
    this.cccd,
    required this.name,
    this.majors,
    this.khoa,
    this.curriculum,
    this.method,
    this.birthDay,
    this.email,
    this.phoneNumber,
    this.familyPoneNumber,
    this.address,
    this.gender,
    this.birthPlace,
    required this.className,
    this.groupCodes,
    required this.status,
    required this.createTime,
    required this.updateTime,
    this.qrcodeImage,
    required this.decyptPassWord,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentCode: json['studentCode'],
      password: json['password'],
      cccd: json['cccd'],
      name: json['name'],
      majors: json['majors'],
      khoa: json['khoa'],
      curriculum: json['curriculum'],
      method: json['method'],
      birthDay: json['birthDay'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      familyPoneNumber: json['familyPoneNumber'],
      address: json['address'],
      gender: json['gender'],
      birthPlace: json['birthPlace'],
      className: json['className'],
      groupCodes: json['groupCodes'],
      status: json['status'],
      createTime: DateTime.parse(json['createTime']),
      updateTime: DateTime.parse(json['updateTime']),
      qrcodeImage: json['qrcodeImage'],
      decyptPassWord: json['decyptPassWord'],
    );
  }
}