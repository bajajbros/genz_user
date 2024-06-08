
// import 'package:customer/backend/prev_search_model.dart';
import 'package:customer/screen/home/home.dart';
import 'package:flutter/material.dart';

import '../../components/color.dart';
import '../../components/text_style.dart';
import 'account.dart';
import 'activity_screen.dart';

class DashboardScreen extends StatefulWidget {
  
  // final String userPhone;
  // final Position position;
  final bool office;
  // final String userName;
  // final String userPhone;
  final String token;
  final String userId;
  const DashboardScreen(
      {Key? key,
      // required this.userId,
      required this.token,
      // required this.userName,
      // required this.userPhone,
      required this.office,
     required this.userId,})
      : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  int currentIndex = 0;

  getBody() {
    final List<Widget> body = [
      HomeScreen(
        userId: widget.userId,
        // position: widget.position,
        token: widget.token,
        office: widget.office,
      ),
      ActivityScreen(
        token: widget.token,
      ),
      AccountScreen(
        userId: widget.userId,
        // userMobile: widget.userPhone,
        token: widget.token,
      )
    ];
    return IndexedStack(
      index: currentIndex,
      children: body,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: getBody(),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.description),
              label: 'Activity',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          backgroundColor: backgroundColor,
          selectedIconTheme: const IconThemeData(
            color: primaryColor,
            size: 20,
          ),
          unselectedIconTheme: IconThemeData(
            color: ColorMedia.white,
            size: 20,
          ),
          selectedLabelStyle: TStyleMedia.white50Roboto16Regular2,
          iconSize: 20,
          unselectedItemColor: Colors.white,
          selectedItemColor: primaryColor,
        ),
      ),
    );
  }
}
