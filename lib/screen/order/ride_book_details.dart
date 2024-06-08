import 'dart:convert';
import 'dart:developer';

import 'package:customer/components/color.dart';
import 'package:customer/helper/button.dart';
import 'package:customer/helper/snackBar.dart';
import 'package:customer/screen/home/home_page.dart';
import 'package:customer/widget/dialoge.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../api/api_value.dart';
import '../../components/sized.dart';
import '../../components/text_style.dart';
import 'package:http/http.dart' as http;


class Goev extends StatefulWidget {
  final String driverName;
  final String carNumber;
  final String profileUrl;
  final String userId;
  final String token;
  final String rideId;
  final String driverNumber;
  final String modelName;
  final String otp;
  final String locationA;
  final String locationB;
  const Goev(
      {super.key,
      required this.modelName,
      required this.otp,
      required this.locationA,
      required this.locationB,
      required this.driverNumber,
      required this.rideId,
      required this.token,
      required this.userId,
      required this.profileUrl,
      required this.driverName,
      required this.carNumber});

  @override
  State<Goev> createState() => _GoevState();
}

class _GoevState extends State<Goev> {
  Future emergencyStop(String reason) async {
    String url = '$baseUrl/api/user/cancelRequest';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
      // Add any other headers required by the API here
    };
    Map<String, dynamic> body = {"rideId": widget.rideId, "reason": reason};
    log(body.toString());
    try {
      http.Response response = await http.post(Uri.parse(url),
          body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        // log(response.body);
        // final prevSearches = prevSearchesFromMap(response.body);
        // return prevSearches;
      } else {
        // log(widget.rideId);
        // log(response.statusCode.toString());
        throw response.body;
      }
    } catch (err) {
      log(err.toString());
      rethrow;
    }
    // return PrevSearches(previous: []);
    // return null;
  }

  // Future rejectOwn(
  //   String rideId,
  // ) async {
  //   io.Socket socket = io.io('$baseUrl',
  //       OptionBuilder().setTransports(['websocket']).build());
  //   socket.connect();
  //   socket.onConnect((data) async {
  //     socket.emit("REJECT_OWN", {"rideId": rideId});
  //     print('ride request sent');
  //   });
  //   socket.on(
  //     "GET_REQUEST",
  //     ((data) async {
  //       log('rides socket on');
  //       log(data);
  //       setState(() {});
  //       return await data;
  //     }),
  //   );
  //   setState(() {});
  // }

  TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedMedia.sizeHeightDivide(context, 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your OTP is : ',
                    style: TStyleMedia.roboto70024pxwhite,
                  ),
                  Text(
                    widget.otp,
                    style: TStyleMedia.roboto70024pxwhite,
                  ),
                ],
              ),
            ),
            SizedMedia.sizeHeightDivide(context, 80),
            Divider(
              thickness: 1,
              color: ColorMedia.white50,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizedMedia.heightDivide(context, 80),
                horizontal: SizedMedia.widthDivide(context, 26),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.driverName,
                              style: TStyleMedia.roboto70024pxwhite,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomText(
                              text: widget.carNumber,
                              color: primaryColor,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.profileUrl),
                        radius: 28,
                        backgroundColor: ColorMedia.white,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          log('pressed');
                          await launchUrlString('tel:${widget.driverNumber}');
                        },
                        child: Container(
                          height: SizedMedia.heightDivide(context, 16),
                          width: MediaQuery.of(context).size.width - 32,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  width: 2,
                                  color: const Color(0xff000080)
                                      .withOpacity(0.1))),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Icon(Icons.call,
                                  size: SizedMedia.heightDivide(context, 40),
                                  color: primaryColor),
                              const SizedBox(
                                width: 20,
                              ),
                              const CustomText(
                                text: "Connect with your driver",
                                color: primaryColor,
                                size: 18,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: SizedMedia.heightDivide(context, 80),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: SizedMedia.heightDivide(context, 80),
                    ),
                    height: SizedMedia.heightDivide(context, 4.6),
                    width: SizedMedia.widthMultiply(context, 1),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            width: 2,
                            color: const Color(0xff000080).withOpacity(0.1))),
                    child: Column(
                      children: [
                        SizedMedia.sizeHeightDivide(context, 80),
                        Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const CircleAvatar(
                              backgroundColor: primaryColor,
                              radius: 8,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              width: SizedMedia.widthMultiply(context, 0.75),
                              child: Text(
                                widget.locationA,
                                style: GoogleFonts.roboto(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.02,
                                    color: Colors.black.withOpacity(0.6)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedMedia.sizeHeightDivide(context, 30),
                        Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            CircleAvatar(
                              backgroundColor: ColorMedia.green,
                              radius: 8,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              width: SizedMedia.widthMultiply(context, 0.68),
                              child: Text(
                                widget.locationB,
                                style: TStyleMedia.roboto40015pxblack80,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedMedia.sizeHeightDivide(context, 70),
                        Divider(
                          thickness: 1,
                          color: const Color(0xff000080).withOpacity(0.1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                Share.share(
                                    'Hey I am using GENZ app you can track my location');
                              },
                              child: Container(
                                height: SizedMedia.heightDivide(context, 16),
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        width: 1,
                                        color: const Color(0xff000080)
                                            .withOpacity(0.1))),
                                child: const Center(
                                  child: Icon(
                                    Icons.emergency_share,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return Center(
                                      child: Material(
                                        type: MaterialType.card,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24)),
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Center(
                                                  child: CustomText(
                                                    text: 'EMERGENCY ALERT',
                                                    color: primaryColor,
                                                    size: 30,
                                                    weight: FontWeight.bold,
                                                  ),
                                                ),
                                                GestureDetector(
                                                    onTap: () async {
                                                      emergencyStop(
                                                          "I WANT HELP");
                                                      snackWidget(context,
                                                          'Your ride will be cancelled soon');
                                                    },
                                                    child: buttonWidget(
                                                        'Stop car now'))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              },
                              child: Container(
                                height: SizedMedia.heightDivide(context, 16),
                                width: 80,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        width: 1,
                                        color: const Color(0xff000080)
                                            .withOpacity(0.1))),
                                child: const Center(
                                  child: Icon(
                                    Icons.warning_amber,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                log('cancel tapped');
                                showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return CancelDialoge(
                                      token: widget.token,
                                      rideId: widget.rideId,
                                      userId: widget.userId,
                                    );
                                  }),
                                );
                              },
                              child: Container(
                                height: SizedMedia.heightDivide(context, 16),
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        width: 1,
                                        color: const Color(0xff000080)
                                            .withOpacity(0.1))),
                                child: const Center(
                                  child: Icon(
                                    Icons.cancel,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: SizedMedia.widthDivide(context, 25),
                        //     vertical: SizedMedia.heightDivide(context, 210),
                        //   ),
                        //   child: Row(
                        //     children: [
                        //       InkWell(
                        //         onTap: () {},
                        //         child: SizedBox(
                        //           height: SizedMedia.heightDivide(context, 30),
                        //           width:
                        //               SizedMedia.widthDivide(context, 4.3902),
                        //           child: Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceAround,
                        //             children: [
                        //               Icon(CupertinoIcons.multiply,
                        //                   size: SizedMedia.heightDivide(
                        //                       context, 45),
                        //                   color: primaryColor),
                        //               Text('Cancel',
                        //                   style: GoogleFonts.roboto(
                        //                     fontSize: 16,
                        //                     fontWeight: FontWeight.w700,
                        //                     letterSpacing: 0.0,
                        //                     color: primaryColor,
                        //                   ))
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //       Container(
                        //         margin: EdgeInsets.symmetric(
                        //             horizontal:
                        //                 SizedMedia.widthDivide(context, 60)),
                        //         height: SizedMedia.heightDivide(context, 26),
                        //         child: VerticalDivider(
                        //           thickness: 1,
                        //           color:
                        //               const Color(0xff000080).withOpacity(0.1),
                        //         ),
                        //       ),
                        //       InkWell(
                        //         onTap: () {},
                        //         child: SizedBox(
                        //           height: SizedMedia.heightDivide(context, 30),
                        //           width:
                        //               SizedMedia.widthDivide(context, 4.3902),
                        //           child: Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               Icon(Icons.support,
                        //                   size: SizedMedia.heightDivide(
                        //                       context, 50),
                        //                   color: primaryColor),
                        //               Text('Support',
                        //                   style: GoogleFonts.roboto(
                        //                     fontSize: 16,
                        //                     fontWeight: FontWeight.w700,
                        //                     letterSpacing: 0.0,
                        //                     color: primaryColor,
                        //                   ))
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //       Container(
                        //         margin: EdgeInsets.symmetric(
                        //             horizontal:
                        //                 SizedMedia.widthDivide(context, 60)),
                        //         height: SizedMedia.heightDivide(context, 26),
                        //         child: VerticalDivider(
                        //           thickness: 1,
                        //           color:
                        //               const Color(0xff000080).withOpacity(0.1),
                        //         ),
                        //       ),
                        //       InkWell(
                        //         onTap: () {},
                        //         child: SizedBox(
                        //           height: SizedMedia.heightDivide(context, 30),
                        //           width:
                        //               SizedMedia.widthDivide(context, 4.3902),
                        //           child: Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceAround,
                        //             children: [
                        //               Icon(Icons.share,
                        //                   size: SizedMedia.heightDivide(
                        //                       context, 50),
                        //                   color: primaryColor),
                        //               Text('Share',
                        //                   style: GoogleFonts.roboto(
                        //                     fontSize: 16,
                        //                     fontWeight: FontWeight.w700,
                        //                     letterSpacing: 0.0,
                        //                     color: primaryColor,
                        //                   ))
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: SizedMedia.heightDivide(context, 80),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: SizedMedia.widthDivide(context, 36),
                      vertical: SizedMedia.heightDivide(context, 80),
                    ),
                    height: SizedMedia.heightDivide(context, 16),
                    width: SizedMedia.widthMultiply(context, 1),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            width: 2,
                            color: const Color(0xff000080).withOpacity(0.1))),
                    child: Text(
                      'Total Fare ${widget.modelName} ₹',
                      style: TStyleMedia.roboto50022pxblack,
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(
                  //     vertical: SizedMedia.heightDivide(context, 80),
                  //   ),
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: SizedMedia.widthDivide(context, 30),
                  //     vertical: SizedMedia.heightDivide(context, 50),
                  //   ),
                  //   height: SizedMedia.heightDivide(context, 3.4620),
                  //   width: SizedMedia.widthMultiply(context, 1),
                  //   decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(5),
                  //       border: Border.all(
                  //           width: 2,
                  //           color: const Color(0xff000080).withOpacity(0.1))),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         'Offers for you',
                  //         style: TStyleMedia.roboto50019pxblack,
                  //       ),
                  //       SizedMedia.sizeHeightDivide(context, 100),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           SizedBox(
                  //             height: SizedMedia.heightDivide(context, 18),
                  //             width: SizedMedia.widthDivide(context, 6),
                  //             child: Center(
                  //               child: Text(
                  //                 'TOP\n 30',
                  //                 style: TStyleMedia.roboto70012pxoFF9933,
                  //               ),
                  //             ),
                  //           ),
                  //           SizedBox(
                  //             width: SizedMedia.widthMultiply(context, 0.65),
                  //             child: Text(
                  //               'First 10,000 users get 5km ride free.',
                  //               style: TStyleMedia.roboto40015pxblack80,
                  //               maxLines: 2,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       Padding(
                  //         padding: EdgeInsets.only(
                  //             left: SizedMedia.widthDivide(context, 5.5)),
                  //         child: Divider(
                  //           thickness: 1,
                  //           color: const Color(0xff000080).withOpacity(0.1),
                  //         ),
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           SizedBox(
                  //             height: SizedMedia.heightDivide(context, 18),
                  //             width: SizedMedia.widthDivide(context, 6),
                  //             child: Center(
                  //               child: Text(
                  //                 'TOP\n 30',
                  //                 style: TStyleMedia.roboto70012pxoFF9933,
                  //               ),
                  //             ),
                  //           ),
                  //           SizedBox(
                  //             width: SizedMedia.widthMultiply(context, 0.65),
                  //             child: Text(
                  //               'First 10,000 users get 5km ride free.',
                  //               style: TStyleMedia.roboto40015pxblack80,
                  //               maxLines: 2,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       Padding(
                  //         padding: EdgeInsets.only(
                  //             left: SizedMedia.widthDivide(context, 5.5)),
                  //         child: Divider(
                  //           thickness: 1,
                  //           color: const Color(0xff000080).withOpacity(0.1),
                  //         ),
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           SizedBox(
                  //             height: SizedMedia.heightDivide(context, 18),
                  //             width: SizedMedia.widthDivide(context, 6),
                  //             child: Center(
                  //               child: Text(
                  //                 'TOP\n 30',
                  //                 style: TStyleMedia.roboto70012pxoFF9933,
                  //               ),
                  //             ),
                  //           ),
                  //           SizedBox(
                  //             width: SizedMedia.widthMultiply(context, 0.65),
                  //             child: Text(
                  //               'First 10,000 users get 5km ride free.',
                  //               style: TStyleMedia.roboto40015pxblack80,
                  //               maxLines: 2,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(
                  //     vertical: SizedMedia.heightDivide(context, 80),
                  //   ),
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: SizedMedia.widthDivide(context, 30),
                  //     vertical: SizedMedia.heightDivide(context, 80),
                  //   ),
                  //   height: SizedMedia.heightDivide(context, 6.8376),
                  //   width: SizedMedia.widthMultiply(context, 1),
                  //   decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(5),
                  //       border: Border.all(
                  //           width: 2,
                  //           color: const Color(0xff000080).withOpacity(0.1))),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Container(
                  //         height: SizedMedia.heightDivide(context, 8.4210),
                  //         width: SizedMedia.widthDivide(context, 3.7894),
                  //         decoration: BoxDecoration(
                  //           color: const Color(0xff6666B3),
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             SizedMedia.sizeHeightDivide(context, 60),
                  //             Text(
                  //               'Platinum',
                  //               style: TStyleMedia.roboto80013pxyEFDF8C,
                  //             ),
                  //             Padding(
                  //               padding: EdgeInsets.only(
                  //                   left: SizedMedia.widthDivide(context, 6),
                  //                   top: SizedMedia.heightDivide(context, 40)),
                  //               child: InkWell(
                  //                 onTap: () {},
                  //                 child: Row(
                  //                   children: [
                  //                     Text(
                  //                       'more',
                  //                       style: TStyleMedia.roboto80008pxyEFDF8C,
                  //                     ),
                  //                     Icon(
                  //                       Icons.arrow_forward_ios_outlined,
                  //                       color: const Color(0xffEFDF8C),
                  //                       size: SizedMedia.heightDivide(
                  //                           context, 100),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Container(
                  //         height: SizedMedia.heightDivide(context, 8.4210),
                  //         width: SizedMedia.widthDivide(context, 3.7894),
                  //         decoration: BoxDecoration(
                  //           color: const Color(0xffEFDF8C),
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             SizedMedia.sizeHeightDivide(context, 60),
                  //             Text(
                  //               'Gold',
                  //               style: TStyleMedia.roboto80013pxblack,
                  //             ),
                  //             Padding(
                  //               padding: EdgeInsets.only(
                  //                   left: SizedMedia.widthDivide(context, 6),
                  //                   top: SizedMedia.heightDivide(context, 40)),
                  //               child: InkWell(
                  //                 onTap: () {},
                  //                 child: Row(
                  //                   children: [
                  //                     Text(
                  //                       'more',
                  //                       style: TStyleMedia.roboto80008pxblack,
                  //                     ),
                  //                     Icon(
                  //                       Icons.arrow_forward_ios_outlined,
                  //                       color: const Color(0xffEFDF8C),
                  //                       size: SizedMedia.heightDivide(
                  //                           context, 100),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Container(
                  //         height: SizedMedia.heightDivide(context, 8.4210),
                  //         width: SizedMedia.widthDivide(context, 3.7894),
                  //         decoration: BoxDecoration(
                  //           color: const Color(0xffD9D9D9).withOpacity(0.9),
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             SizedMedia.sizeHeightDivide(context, 60),
                  //             Text(
                  //               'Silver',
                  //               style: TStyleMedia.roboto80013pxb6666B3,
                  //             ),
                  //             Padding(
                  //               padding: EdgeInsets.only(
                  //                   left: SizedMedia.widthDivide(context, 6),
                  //                   top: SizedMedia.heightDivide(context, 40)),
                  //               child: InkWell(
                  //                 onTap: () {},
                  //                 child: Row(
                  //                   children: [
                  //                     Text(
                  //                       'more',
                  //                       style: TStyleMedia.roboto80008pxb6666B3,
                  //                     ),
                  //                     Icon(
                  //                       Icons.arrow_forward_ios_outlined,
                  //                       color: const Color(0xff6666B3),
                  //                       size: SizedMedia.heightDivide(
                  //                           context, 100),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
