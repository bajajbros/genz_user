import 'dart:developer';

import 'package:customer/api/api_value.dart';
import 'package:customer/components/color.dart';
import 'package:customer/components/text_style.dart';
import 'package:customer/screen/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../backend/previous_model.dart';

class ActivityScreen extends StatefulWidget {
  final String token;
  const ActivityScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  void initState() {
    // getPrevRides();
    super.initState();
  }

  Future<PreviousRides> getPrevRides() async {
    Response response =
        await get(Uri.parse('$baseUrl/api/user/previousRides'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    });
    if (response.statusCode == 200) {
      log('got data');
      log('sending prev rides');
      log(response.body);

      PreviousRides previousRides = prevRidesFromMap(response.body.toString());
      log('sending prev rides');
      return previousRides;
    } else {
      log(response.statusCode.toString());
      throw 'noooooooooooooo';
    }
  }

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const SizedBox(),
        leadingWidth: 10,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 12,
              ),
              Text(
                'Activity',
                style: TStyleMedia.whiteRoboto25SemiBold5,
              ),
            ],
          ),
        ),
        // title: Row(
        //   children: [
        //     SizedBox(height: 20,),
        //     Text('Activity', style: TStyleMedia.whiteRoboto25SemiBold5,),
        //   ],
        // ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 26.67,
              ),
              Text(
                'Past',
                style: TStyleMedia.whiteRoboto17Medium5,
              ),
              FutureBuilder<PreviousRides>(
                future: getPrevRides(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.previous!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          log('sending snap');
                          log(snapshot.data.toString());
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: rideHistoryWidget(
                              context,
                              date: snapshot.data!.previous![index].createdAt!
                                  .substring(0, 10),
                              time: snapshot.data!.previous![index].distance!
                                  .toString()
                                  .substring(0, 4),
                              fare: snapshot.data!.previous![index].finalFare.toStringAsFixed(2),
                              name: snapshot.data!.previous![index].rideType!,
                              locA: snapshot
                                  .data!.previous![index].fromLocation!.name!,
                              locB: snapshot
                                  .data!.previous![index].toLocation!.name!,
                            ),
                          );
                          // return Container(
                          //   width: MediaQuery.of(context).size.width,
                          //   height: MediaQuery.of(context).size.height / 7.27,
                          //   decoration:
                          //       BoxDecoration(border: Border.all(width: 1)),
                          //   child: Row(
                          //     children: [
                          //       Container(
                          //         width:
                          //             MediaQuery.of(context).size.width / 4.8,
                          //         height:
                          //             MediaQuery.of(context).size.width / 4.8,
                          //         decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(10),
                          //             color: Colors.grey.shade300),
                          //       ),
                          //       Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //             vertical: 15, horizontal: 25),
                          //         child: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           mainAxisAlignment: MainAxisAlignment.start,
                          //           children: [
                          //             SizedBox(
                          //               width: 160,
                          //               child: Text(
                          //                 snapshot.data!.previous![index]
                          //                     .fromLocation!.name!,
                          //                 style: TStyleMedia.whiteRoboto13Medium5,
                          //                 overflow: TextOverflow.ellipsis,
                          //               ),
                          //             ),
                          //             const SizedBox(
                          //               height: 10,
                          //             ),
                          //             Text(
                          //               snapshot.data!.previous![index].updatedAt
                          //                   .toString().substring(0,10),
                          //               style:
                          //                   TStyleMedia.white50Roboto11Regular5,
                          //             ),
                          //             const SizedBox(
                          //               height: 10,
                          //             ),
                          //             Text(
                          //               snapshot.data!.previous![index].finalFare
                          //                   .toString().substring(0,4),
                          //               style:
                          //                   TStyleMedia.white50Roboto11Regular5,
                          //             )
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // );
                        });
                  } else {
                    log(snapshot.data.toString());
                  }
                  return const Center(
                    child: CustomText(
                      weight: FontWeight.w600,
                      size: 32,
                      text: 'No Data Yet',
                      color: Colors.white,
                    ),
                  );
                },
              )
              // Container(
              //   decoration: BoxDecoration(
              //     color: ColorMedia.white,
              //     borderRadius: BorderRadius.circular(10),
              //     border: Border.all(width: 2, color: ColorMedia.blue.withOpacity(0.10),),
              //   ),
              //   width: 390,
              //   height: 248,
              //   child:  Column(
              //     children: [
              //       Container(
              //         width:350,
              //         height: 134,
              //         child: GoogleMap(
              //           zoomGesturesEnabled: false,
              //           zoomControlsEnabled: false,
              //           mapType: MapType.normal,
              //           initialCameraPosition: _kGooglePlex,
              //         ),
              //       ),
              //       Text('55, Dr Anandrao Nair Marg', style: TStyleMedia.blackRoboto19SemiBold5,),
              //       Text('11 Nov. 12:51 PM', style: TStyleMedia.white50Roboto11Regular5,),
              //       Text('376.00', style: TStyleMedia.white50Roboto11Regular5,)
              //     ],
              //   ),
              // ),

// Center(
//   child: Image.network(src),
// )
              // ...List.generate(10, (index){
              //   return Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: MediaQuery.of(context).size.height/7.27,
              //     //decoration: BoxDecoration(border: Border.all(width: 1)),
              //     child: Row(
              //       children: [
              //         Container(
              //           width: MediaQuery.of(context).size.width/4.8,
              //           height: MediaQuery.of(context).size.width/4.8,
              //           decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(10),
              //               color: Colors.grey.shade300),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              //           child: Row(
              //             children: [
              //               Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 mainAxisAlignment: MainAxisAlignment.start,
              //                 children: [
              //                   Text(
              //                     '55, Dr Andrada Nair Marg',
              //                     style: TStyleMedia.whiteRoboto13Medium5,
              //                     overflow: TextOverflow.ellipsis,
              //                   ),
              //                   const SizedBox(height: 10,),
              //                   Text(
              //                     '11 Nov. 12:51 PM',
              //                     style: TStyleMedia.white50Roboto11Regular5,
              //                   ),
              //                   const SizedBox(height: 10,),
              //                   Text(
              //                     '₹ 376.00',
              //                     style: TStyleMedia.white50Roboto11Regular5,
              //                   ),
              //                   const Spacer(),
              //                   Container(color: primaryColor , height: 1, width:MediaQuery.of(context).size.width - MediaQuery.of(context).size.width/2,)
              //                 ],
              //               ),
              //              const SizedBox(width: 10,),
              //               const Icon(
              //                 Icons.navigate_next
              //                 ,color: primaryColor,
              //               )
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   );
              // }),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   height: MediaQuery.of(context).size.height/7.27,
              //   //decoration: BoxDecoration(border: Border.all(width: 1)),
              //   child: Row(
              //     children: [
              //       Container(
              //         width: MediaQuery.of(context).size.width/4.8,
              //         height: MediaQuery.of(context).size.width/4.8,
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(10),
              //             color: Colors.grey.shade300),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: [
              //             Text(
              //               '55, Dr Andrada Nair Marg',
              //               style: TStyleMedia.whiteRoboto13Medium5,
              //               overflow: TextOverflow.ellipsis,
              //             ),
              //             const SizedBox(height: 10,),
              //             Text(
              //               '11 Nov. 12:51 PM',
              //               style: TStyleMedia.white50Roboto11Regular5,
              //             ),
              //             const SizedBox(height: 10,),
              //             Text(
              //               '₹ 376.00',
              //               style: TStyleMedia.white50Roboto11Regular5,
              //             )
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

Widget rideHistoryWidget(
  BuildContext context, {
  required String date,
  required String time,
  required String fare,
  required String name,
  required String locA,
  required String locB,
}) {
  return GestureDetector(
    // onTap: () {
    //   Navigator.push(context,
    //       MaterialPageRoute(builder: ((context) =>  const RideDetails())));
    // },
    child: Container(
      height: MediaQuery.of(context).size.height / 4.7619,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow:  [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 4,
            color: Colors.grey[900]!,
          )
        ],
        color: const Color(0xff252525),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width / 36),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 3 -3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppSize.height(context, 20),
                      Text(
                        date,
                        style: TStyleMedia.whiteRoboto20Medium2,
                      ),
                      AppSize.width(context, 36),
                      const Text(
                        "",
                        // style: AppText.roboto30014pxWhite,
                      ),
                    ],
                  ),
                  AppSize.height(context, 60),
                  Text(
                    name,
                    style: TStyleMedia.whiteMohave20SemiBold0,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSize.height(context, 80),
                  Text(
                    "$fare ₹",
                    style: TStyleMedia.whiteRoboto11SemiBold,
                  ),
                  AppSize.height(context, 80),
                  Container(
                    height: AppSize.heightMedia(context, 26.6666),
                    width: AppSize.widthMedia(context, 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: primaryColor),
                    child: Center(
                      child: Text(
                        '$time km',
                        style: TStyleMedia.white50Roboto16Regular2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: AppSize.widthMedia(context, 9)),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: primaryColor,
                      size: AppSize.heightMedia(context, 40),
                    ),
                    AppSize.width(context, 60),
                    SizedBox(
                      height: AppSize.heightMedia(context, 18.6666),
                      width: AppSize.widthMedia(context, 3.2),
                      child: Center(
                        child: Text(
                          locA,
                          style: TStyleMedia.whiteRoboto14Medium,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: AppSize.widthMedia(context, 8)),
                child: Image.asset(
                  'images/line.png',
                  height: AppSize.heightMedia(context, 10.6956),
                  width: AppSize.widthMedia(context, 4.5569),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: Colors.green,
                    size: AppSize.heightMedia(context, 40),
                  ),
                  AppSize.width(context, 60),
                  SizedBox(
                    height: AppSize.heightMedia(context, 18.6666),
                    width: AppSize.widthMedia(context, 3.2),
                    child: Center(
                      child: Text(
                        locB,
                        style: TStyleMedia.whiteRoboto14Medium,
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    ),
  );
}

class AppSize {
  static heightMedia(BuildContext context, double size) =>
      MediaQuery.of(context).size.height / size;

  static heightMediaM(BuildContext context, double size) =>
      MediaQuery.of(context).size.height * size;

  static widthMedia(BuildContext context, double size) =>
      MediaQuery.of(context).size.width / size;

  static widthMediaM(BuildContext context, double size) =>
      MediaQuery.of(context).size.width * size;

  static height(BuildContext context, double size) => SizedBox(
        height: heightMedia(context, size),
      );

  static heightM(BuildContext context, double size) => SizedBox(
        height: heightMediaM(context, size),
      );

  static width(BuildContext context, double size) => SizedBox(
        width: widthMedia(context, size),
      );

  static widthM(BuildContext context, double size) => SizedBox(
        height: widthMediaM(context, size),
      );
}
