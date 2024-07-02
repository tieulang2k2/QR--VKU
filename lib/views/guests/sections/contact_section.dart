import 'package:flutter/material.dart';
import 'package:vku_app/models/guest.dart';

class ContactSection extends StatelessWidget {
  Guest guest;
  ContactSection({super.key, required this.guest});

  @override
  Widget build(BuildContext context) {
    return contactSection(guest);
  }
}

Column contactSection(Guest guest) {
  return Column(
    children: [
      contactDetail(guest),
      contactStatus(),
    ],
  );
}

Card contactStatus() {
  return const Card(
    margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
    color: Colors.white,
    child: Column(
      children: [
        ListTile(
          iconColor: Colors.blueGrey,
          textColor: Colors.blueGrey,
          title: Text(
            "Status",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Available",
            style: TextStyle(color: Colors.black),
          ),
          dense: true,
        ),
      ],
    ),
  );
}

Card contactDetail(Guest guest) {
  return Card(
    margin: const EdgeInsets.all(20),
    color: Colors.white,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildContactTile(
            icon: Icons.phone_android,
            title: "Mobile",
            subtitle:  guest.phoneNumber,
            fontSize: 20, // Kích thước chữ 20
          ),
          _buildContactTile(
            icon: Icons.mail,
            title: "Email",
            subtitle: guest.email,
            fontSize: 20, // Kích thước chữ 20
          ),
          _buildContactTile(
            icon: Icons.web_asset,
            title: "Website",
            subtitle: "",
            fontSize: 20, // Kích thước chữ 20
          ),
        ],
      ),
    ),
  );
}

ListTile _buildContactTile({
  IconData? icon,
  String? title,
  String? subtitle,
  double? fontSize,
}) {
  return ListTile(
    iconColor: Colors.blueGrey,
    textColor: Colors.blueGrey,
    leading: Icon(icon),
    title: Text(
      title!,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    ),
    subtitle: Text(
      subtitle!,
      style:const TextStyle(color: Colors.black),
    ),
    dense: true,
  );
}
