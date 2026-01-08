import 'package:flutter/material.dart';
import 'package:testing/constans/MyColor.dart';
import 'package:testing/view/pages/EventsTap.dart';
import 'package:testing/view/pages/HomeTap.dart';
import 'package:testing/view/widget/BottomNavBar.dart';
import 'package:testing/view/widget/NotificationsTap.dart';
import 'package:testing/view/widget/ProfileTap.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  AppBar buildHomeAppBar() {
    return AppBar(
      actions: [IconButton(onPressed: (){}, icon: Icon(Icons.list,color: MyColors.primary,size: 40,)),SizedBox(width: 20,)],
      elevation: 2,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Close ",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1,
              ),
            ),
            TextSpan(
              text: "Friend",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: MyColors.primary,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Widget> pages = const [
    HomeTab(),
    EventsTab(),
    NotificationsTab(),
    ProfileTab(),
  ];

  void onTabChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHomeAppBar(),
      body: pages[currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: onTabChanged,
      ),
    );
  }
}
