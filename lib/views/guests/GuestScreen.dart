import 'package:flutter/material.dart';
import 'package:vku_app/models/guest.dart';
import 'package:vku_app/utils/api_consts.dart';
import 'package:vku_app/views/guests/sections/about_section.dart';
import 'package:vku_app/views/guests/sections/contact_section.dart';

class GuestScreen extends StatelessWidget {
   Guest guest;

  GuestScreen({super.key,
  required this.guest 
  });

  List<Tab> tabs = [
    const Tab(
      text: "About",
      icon: Icon(
        Icons.account_box,
      ),
    ),
    const Tab(
      text: "Contact",
      icon: Icon(
        Icons.contact_page,
      ),
    ),
  ];
  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder<Guest>(
  //     future: guest,
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         final guest = snapshot.data!;
  //          return DefaultTabController(
  //     length: tabs.length,
  //     child: Scaffold(
  //       appBar: AppBar(
  //         backgroundColor: const Color.fromARGB(255, 48, 160, 211),
  //         titleTextStyle: const TextStyle(
  //           color: Colors.white,
  //           fontSize: 20,
  //         ),
  //         toolbarHeight: 275,
  //         title: Padding(
  //           padding: const EdgeInsets.only(top: 35.0),
  //           child: Column(
  //             children: [
  //               profilePhotos(),
  //               profileName(),
  //               // hobbies(),
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 10.0),
  //                 child: stats(),
  //               ),
  //             ],
  //           ),
  //         ),
  //         bottom: TabBar(
  //           tabs: tabs,
  //           indicatorColor: Colors.white,
  //           indicatorSize: TabBarIndicatorSize.tab,
  //         ),
  //       ),
  //       body: TabBarView(
  //         children: [
  //           const SingleChildScrollView(
  //             child: AboutSection(),
  //           ),
  //           SingleChildScrollView(
  //             child: contactSection(),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  //       } else if (snapshot.hasError) {
  //         return Text('Error: ${snapshot.error}');
  //       } else {
  //         return const CircularProgressIndicator();
  //       }
  //     },
  //   );
  // }

 @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // initialIndex: guest,
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 48, 160, 211),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          toolbarHeight: 275,
          title: Padding(
            padding: const EdgeInsets.only(top: 35.0),
            child: Column(
              children: [
                profilePhotos(),
                profileName(),
                // hobbies(),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: stats(),
                ),
              ],
            ),
          ),
          bottom: TabBar(
            tabs: tabs,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        body: TabBarView(
          children: [
             SingleChildScrollView(
              child: AboutSection(guest: guest),
            ),
            SingleChildScrollView(
              child: contactSection(guest),
            ),
          ],
        ),
      ),
    );
  }

  Padding hobbies() {
    return const Padding(
      padding: EdgeInsets.only(
        top: 5.0,
        bottom: 5.0,
      ),
      child: Text(
        "Traveller - Dreamer - Fighter",
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }

  Padding profileName() {
    return  Padding(
      padding:const EdgeInsets.only(top: 8.0),
      child: Text(
        guest.name,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Row stats() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(
              "Photos",
              style: TextStyle(
                color: Color.fromARGB(255, 28, 124, 172),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "160",
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "Followers",
              style: TextStyle(
                color: Color.fromARGB(255, 28, 124, 172),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "1657",
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "Following",
              style: TextStyle(
                color: Color.fromARGB(255, 28, 124, 172),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "9",
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ],
    );
  }

  Container profilePhotos() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
      width: 105,
      height: 105,
      alignment: Alignment.center,
      child: const CircleAvatar(
        radius: 50,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(
          // "$imagePath/0343414748-QRCode.png",
          "https://t3.ftcdn.net/jpg/03/46/83/96/240_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg",
          
        ),
      ),
    );
  }
  
  fetchGuestData() {}

}