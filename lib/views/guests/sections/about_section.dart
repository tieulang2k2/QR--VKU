import 'package:flutter/material.dart';
import 'package:vku_app/models/guest.dart';
import 'package:vku_app/utils/api_consts.dart';

class AboutSection extends StatelessWidget {
  final Guest guest;

  AboutSection({Key? key, required this.guest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   'Thông tin sự kiện',
          //   style: TextStyle(
          //     fontSize: 24,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.blueGrey,
          //   ),
          // ),
          SizedBox(height: 10),
          _buildTitle('Sự kiện tham gia'),
          _buildInfo(guest.event),
          SizedBox(height: 10),
          _buildTitle('Ngày đến'),
          _buildInfo(guest.checkInTime),
          SizedBox(height: 10),
          _buildTitle('Mục đích tham gia'),
          _buildInfo(guest.purpose),
          SizedBox(height: 10),
          _buildTitle('Thông tin sự kiện'),

          
          Image(image: NetworkImage(
            '$imagePath/${guest.phoneNumber}-QRCode.png',
          )),
          // Add your image widget here
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfo(String info) {
    return Text(
      info,
      style:const TextStyle(
        fontSize: 16,
      ),
    );
  }
}