class Guest {
  int id;
  String name;
  String email;
  String checkInTime;
  String purpose;
  String organization;
  String event;
  String phoneNumber;

  Guest({
    required this.id,
    required this.name,
    required this.email,
    required this.checkInTime,
    required this.purpose,
    required this.organization,
    required this.event,
    required this.phoneNumber,
  });

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      checkInTime: json['arrivalDate'] != null ? json['arrivalDate'] : '',
      purpose: json['purpose'],
      organization: json['organization'],
      event: json['eventId'],
      phoneNumber: json['phoneNumber'],
    );
  }
}