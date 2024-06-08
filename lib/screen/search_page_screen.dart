import 'dart:async';

import 'package:customer/components/color.dart';
import 'package:customer/components/sized.dart';
import 'package:customer/screen/home/home_page.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';
import '../components/text_style.dart';
import '../main.dart';
import '../widget/no_driver_dialoge.dart';

void rejectOwn(
  String rideId,
) async {
  socket.emit("REJECT_OWN", {"rideId": rideId});
}

bool navigate = false;

class SearchPageScreen extends StatefulWidget {
  final String token;
  final String userId;
  final String rideId;
  const SearchPageScreen({
    Key? key,
    required this.rideId,
    required this.token,
    required this.userId,
  }) : super(key: key);
  @override
  State<SearchPageScreen> createState() => _SearchPageScreenState();
}

class _SearchPageScreenState extends State<SearchPageScreen> {
  late Timer timer;
  @override
  void initState() {
    timer = Timer(const Duration(seconds: 30, minutes: 2), () {
      showDialog(
          context: context,
          builder: (context) {
            return NoDriverFoundDialogue(widget.userId, widget.token);
          });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            // backgroundImage(imageURl: 'images/background3.png'),
            Positioned(
              top: 20,
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.arrow_back_outlined,
                      color: ColorMedia.white,
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Text(
                    'Searching for Cab',
                    style: TStyleMedia.whiteRoboto18Medium2,
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Searching Ride....',
                    style: TStyleMedia.whiteRoboto18Medium2,
                  ),
                  SizedMedia.sizeHeightDivide(context, 160),
                  Text(
                    'This may take a few seconds',
                    style: TStyleMedia.white50Roboto11Medium2,
                  ),
                  SizedMedia.sizeHeightDivide(context, 13.33),
                  DottedBorder(
                    borderType: BorderType.Circle,
                    color: primaryColor,
                    //color of dotted/dash line
                    strokeWidth: 3,
                    //thickness of dash/dots
                    dashPattern: const [10, 6],
                    child: CircleAvatar(
                      radius: 150,
                      backgroundColor: Colors.transparent,
                      child: Center(
                        child: DottedBorder(
                          borderType: BorderType.Circle,
                          color: primaryColor,
                          //color of dotted/dash line
                          strokeWidth: 3,
                          //thickness of dash/dots
                          dashPattern: const [10, 6],
                          child: CircleAvatar(
                            radius: 100,
                            backgroundColor: Colors.transparent,
                            child: Center(
                              child: DottedBorder(
                                borderType: BorderType.Circle,
                                color: primaryColor,
                                //color of dotted/dash line
                                strokeWidth: 3,
                                //thickness of dash/dots
                                dashPattern: const [10, 6],
                                child: const CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.transparent,
                                  child: Center(
                                    child: Icon(
                                      Icons.account_circle,
                                      color: primaryColor,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedMedia.sizeHeightDivide(context, 13.33),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 20),
                    child: SlideAction(
                      sliderButtonYOffset: 5,
                      height: 50,
                      sliderButtonIconSize: 10,
                      sliderButtonIconPadding: 3,
                      onSubmit: () {
                        rejectOwn(widget.rideId);
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                          return HomePage(
                              token: widget.token, userId: widget.userId);
                        }), (route) => false);
                      },
                      innerColor: ColorMedia.white,
                      outerColor: primaryColor,
                      alignment: Alignment.centerRight,
                      sliderButtonIcon: const Icon(CupertinoIcons.multiply),
                      child: Text('>>   Slide to cancel',
                          style: TStyleMedia.whiteMohave20SemiBold0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
