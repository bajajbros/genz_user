// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as m;

import 'dart:math' as math;
import 'dart:ui';
import 'package:customer/components/color.dart';
import 'package:customer/helper/button.dart';
import 'package:customer/helper/snackBar.dart';
import 'package:customer/screen/home/home_page.dart';
import 'package:customer/screen/navigation_screen.dart';
import 'package:customer/screen/search_page_screen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'backend/accepted_ride.dart';
import 'backend/driver_details_model.dart';
import 'backend/face_model.dart';
import 'components/text_style.dart';
import 'main.dart';
import 'module_helper/app_info.dart';

String? driverPhone;
String? driverEmail;
String? profileUrl;
XFile? image;
List<CameraDescription>? cameras;

class MyApp extends StatefulWidget {
  final String userId;
  final bool office;
  final String token;
  final List<double> cordinates;
  const MyApp(
      {super.key,
      required this.token,
      required this.cordinates,
      required this.office,
      required this.userId});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final math.Random _rnd = math.Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  Future<String> uploadImageToFirebase(File image) async {
    //('called');
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${getRandomString(20)}.jpg');
    //('created');
    final UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask;
    //('uploaded');

    final String downloadUrl = await storageReference.getDownloadURL();
    //('got url $downloadUrl');
    return downloadUrl;
  }

  bool _isCreatingLink = false;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  String? _linkMessage;

  Future _createDynamicLink(bool short, XFile image) async {
    setState(() {
      _isCreatingLink = true;
    });
    const String DynamicLink = 'https://themahi19.page.link';

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://themahi19.page.link',
      // longDynamicLink: Uri.parse(
      //   await uploadImageToFirebase(File(image.path)),
      // ),
      link: Uri.parse(
        await uploadImageToFirebase(File(image.path)),
      ),
    );
    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
      //(url.toString());
    } else {
      url = await dynamicLinks.buildLink(parameters);
      //(url.toString());
    }
    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
//
    // //(_linkMessage!);
    return url.toString();
  }

  // final DynamicLinkParameters parameters = DynamicLinkParameters(
  //   uriPrefix: 'https://flutterfiretests.page.link',
  //   longDynamicLink: Uri.parse(
  //     'https://flutterfiretests.page.link?efr=0&ibi=io.flutter.plugins.firebase.dynamiclinksexample&apn=io.flutter.plugins.firebase.dynamiclinksexample&imv=0&amv=0&link=https%3A%2F%2Fexample%2Fhelloworld&ofl=https://ofl-example.com',
  //   ),
  //   link: Uri.parse("themahi19.page.link"),
  //   // androidParameters: const AndroidParameters(
  //   //   packageName: 'io.flutter.plugins.firebase.dynamiclinksexample',
  //   //   minimumVersion: 0,
  //   // ),
  //   // iosParameters: const IOSParameters(
  //   //   bundleId: 'io.flutter.plugins.firebase.dynamiclinksexample',
  //   //   minimumVersion: '0',
  //   // ),
  // );

//   Future sendImage(XFile selectedImage) async {
//     //('methos called');
//     // Map<String, dynamic> params = {
//     //   "API_KEY": "vwD6B0tQMX2CcEVCAemNVIkoWxC9yW9k",
//     //   "task": "face_gender_detection",
//     //   "url_image": uploadImageToFirebase(File(image!.path))
//     // };
//     String url = await _createDynamicLink(true, selectedImage);
//     //(url);
//     Response response = await get(
//       Uri.parse(
//         'https://www.picpurify.com/analyse/1.1?API_KEY=vwD6B0tQMX2CcEVCAemNVIkoWxC9yW9k&task=face_gender_detection&url_image=$url',
//       ),
//     );

//     //('api called');
//     if (response.statusCode == 200) {
//       print(response.body);
//       return parseFaceDetectionResult(response.body);
//       // //(response.body);
//     }
//     //(response.statusCode.toString());

//     // final String DynamicLink = 'https://themahi19.page.link';

//     // final DynamicLinkParameters parameters = DynamicLinkParameters(
//     //   uriPrefix: 'https://themahi19.page.link',
//     //   // longDynamicLink: Uri.parse(
//     //   //   await uploadImageToFirebase(File(image.path)),
//     //   // ),
//     //   link: Uri.parse(
//     //     await uploadImageToFirebase(File(image!.path)),
//     //   ),
//     // );
//     // Uri url;
//     // if (short) {
//     //   final ShortDynamicLink shortLink =
//     //       await dynamicLinks.buildShortLink(parameters);
//     //   url = shortLink.shortUrl;
//     //   //(url.toString());
//     // } else {
//     //   url = await dynamicLinks.buildLink(parameters);
//     //   //(url.toString());
//     // }
//     // setState(() {
//     //   _linkMessage = url.toString();
//     //   _isCreatingLink = false;
//     // });
// //
//     // //(_linkMessage!);
//     return url.toString();
//   }

  // final DynamicLinkParameters parameters = DynamicLinkParameters(
  //   uriPrefix: 'https://flutterfiretests.page.link',
  //   longDynamicLink: Uri.parse(
  //     'https://flutterfiretests.page.link?efr=0&ibi=io.flutter.plugins.firebase.dynamiclinksexample&apn=io.flutter.plugins.firebase.dynamiclinksexample&imv=0&amv=0&link=https%3A%2F%2Fexample%2Fhelloworld&ofl=https://ofl-example.com',
  //   ),
  //   link: Uri.parse("themahi19.page.link"),
  //   // androidParameters: const AndroidParameters(
  //   //   packageName: 'io.flutter.plugins.firebase.dynamiclinksexample',
  //   //   minimumVersion: 0,
  //   // ),
  //   // iosParameters: const IOSParameters(
  //   //   bundleId: 'io.flutter.plugins.firebase.dynamiclinksexample',
  //   //   minimumVersion: '0',
  //   // ),
  // );

  Future sendImage(XFile selectedImage) async {
    //('methos called');
    // Map<String, dynamic> params = {
    //   "API_KEY": "vwD6B0tQMX2CcEVCAemNVIkoWxC9yW9k",
    //   "task": "face_gender_detection",
    //   "url_image": uploadImageToFirebase(File(image!.path))
    // };
    String url = await _createDynamicLink(true, selectedImage);
    //(url);
    Response response = await get(
      Uri.parse(
        'https://www.picpurify.com/analyse/1.1?API_KEY=zN4iKOW2w4Mduq1TKqOlkZfmz4U52I2F&task=face_gender_detection&url_image=$url',
      ),
    );

    //('api called');
    if (response.statusCode == 200) {
      print(response.body);
      // return response.body;
      return parseFaceDetectionResult(response.body);
      // //(response.body);
    }
    //(response.statusCode.toString());
  }

  FaceModel parseFaceDetectionResult(String responseBody) {
    final jsonData = json.decode(responseBody);
    return FaceModel.fromMap(jsonData);
  }
  // FaceModel parseFaceDetectionResult(String responseBody) {
  //   final jsonData = json.decode(responseBody);
  //   return FaceModel.fromMap(jsonData);
  // }

  CameraController? controller;
  var faceDetectionResult;
  late Timer timer;
  @override
  void initState() {
    super.initState();
    
    controller = CameraController(cameras![1], ResolutionPreset.medium);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  // Future getAvailableDrivers({
  //   required String userId,
  //   required bool office,
  //   required List cordinates,
  //   required String locationAName,
  //   required String locationBName,
  //   required List locationBCordinates,
  //   required String token,
  //   required BuildContext context,
  // }) async {
  //   const double earthRadius = 6371;

  //   double calDis(double lat1, double lon1, double lat2, double lon2) {
  //     double lat1Rad = lat1 * m.pi / 180;
  //     double lat2Rad = lat2 * m.pi / 180;
  //     double deltaLatRad = (lat2 - lat1) * m.pi / 180;
  //     double deltaLonRad = (lon2 - lon1) * m.pi / 180;

  //     double a = m.sin(deltaLatRad / 2) * m.sin(deltaLatRad / 2) +
  //         m.cos(lat1Rad) *
  //             m.cos(lat2Rad) *
  //             m.sin(deltaLonRad / 2) *
  //             m.sin(deltaLonRad / 2);
  //     double c = 2 * m.atan2(m.sqrt(a), m.sqrt(1 - a));

  //     return (earthRadius * c);
  //   }

  //   final currenContext = context;
  //   //('method of create ride');
  //   num distance = calDis(cordinates[0], cordinates[1], locationBCordinates[0],
  //       locationBCordinates[1]);
  //   var rideDetails = {
  //     "rideDetails": {
  //       "fromLocation": {
  //         "name": locationAName,
  //         "coordinates": [cordinates[0], cordinates[1]]
  //       },
  //       "toLocation": {
  //         "name": locationBName,
  //         "coordinates": [locationBCordinates[0], locationBCordinates[1]]
  //       },
  //       "distance": distance,
  //       "userId": userId,
  //       "rideType": office ? "office" : "normal",
  //     }
  //   };

  //   // Socket socket =
  //   //     io(baseUrl, OptionBuilder().setTransports(['websocket']).build());
  //   // if (socket.active) {
  //   socket.emit("CREATE_RIDE", rideDetails);
  //   log('create ride emitted already');

  //   //('ride created');
  //   // } else {
  //   //   socket.connect();
  //   //   socket.onConnect((data) async {
  //   //     //('ride connected');
  //   //     //(rideDetails.toString());
  //   //     socket.emit("CREATE_RIDE", rideDetails);
  //   //           log('create ride emitted after connecting');

  //   //     //('ride created');
  //   //   });
  //   // }

  //   socket.on(
  //     "CREATE_RIDE",
  //     ((data) async {
  //       //('sending create ride listen');
  //       //(data);

  //       String rideId = jsonDecode(data)['availableDrivers']['_id'];
  //       socket.emit("GET_USER_REQUEST", {"rideId": rideId});
  //       socket.on(
  //         "GET_REQUEST",
  //         ((data) async {
  //           var msg = await data;
  //           //('sending get user request by socket');

  //           //(msg.toString());
  //           //('message sent');
  //           // log(data);

  //           AvailableDriversModel driver = availableDriversModelFromMap(data);
  //           if (driver.status == "pending") {
  //             Navigator.pushAndRemoveUntil(currenContext, MaterialPageRoute(
  //               builder: ((currentContext) {
  //                 return NavigationScreen(
  //                     modelName: driver.finalFare.toStringAsFixed(2),
  //                     otp: driver.otp,
  //                     locationA: driver.fromLocation.name,
  //                     locationB: driver.toLocation.name,
  //                     rideId: driver.id,
  //                     token: token,
  //                     userId: userId);
  //               }),
  //             ), (route) => false);
  //           }

  //           //(msg.toString());
  //           if (driver.status == 'assigned') {
  //             //('ok bhai ab me chlta hu');
  //             AcceptedRideModal acceptedRideModal =
  //                 AcceptedRideModal.fromMap(jsonDecode(data));
  //             //('ab nhi ja paunga');
  //             // SharedPreferences preferences = await SharedPreferences.getInstance();
  //             // //  modelName: ,
  //             // // otp: ,
  //             // // locationA:
  //             // // locationB:
  //             // // driverNumber:
  //             // preferences.setBool('assigned', true);
  //             // preferences.setString('modelName', driver.fare.toString());

  //             // preferences.setString('otp', driver.otp.toString());

  //             // preferences.setString('locationA', driver.fromLocation.name);

  //             // preferences.setString('locationB', driver.toLocation.name);
  //             // preferences.setString('driverNumber', driver.distance.toString());
  //             profileUrl = acceptedRideModal.driver.profileUrl;

  //             //('converting navigate status');
  //             navigate = true;
  //             // driverLocation = Direction(locationLatitude: acceptedRideModal.driver.location.coordinates[0], locationLongitude: acceptedRideModal.driver.location.coordinates[1],);
  //             // Provider.of<AppInfo>(context,).updateDriverLocation(Direction(locationLatitude: acceptedRideModal.driver.location.coordinates[0], locationLongitude: acceptedRideModal.driver.location.coordinates[1],));
  //             driverPhone = acceptedRideModal.driver.phone;
  //             driverEmail = acceptedRideModal.driver.email;
  //             //('driver email = $driverEmail');
  //             //('driver ko phone dedia $driverPhone');

  //             // navigate = true;
  //             // //('navigate hojana chahiye ab to');
  //             if (mounted) {
  //               setState(() {
  //                 // socket.disconnect();
  //               });
  //             }
  //           } else {
  //             if (mounted) {
  //               setState(() {});
  //             }
  //           }
  //           //('ride status = ${driver.status}');
  //           // driver.status == "assigned" ? Provider.of<AppInfo>(context,).navigateWhenAccepted(): null;
  //           // //(driver.toString());
  //           //('driver sent');
  //           return await data;
  //         }),
  //       );

  //       // await getUserRequest(
  //       //     rideId, context);
  //       //(availableDriversModel.availableDrivers.id);
  //     }),
  //   );
  // }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  final double _earthRadius = 6371;

  double calDis(double lat1, double lon1, double lat2, double lon2) {
    double lat1Rad = lat1 * m.pi / 180;
    double lat2Rad = lat2 * m.pi / 180;
    double deltaLatRad = (lat2 - lat1) * m.pi / 180;
    double deltaLonRad = (lon2 - lon1) * m.pi / 180;

    double a = m.sin(deltaLatRad / 2) * m.sin(deltaLatRad / 2) +
        m.cos(lat1Rad) *
            m.cos(lat2Rad) *
            m.sin(deltaLonRad / 2) *
            m.sin(deltaLonRad / 2);
    double c = 2 * m.atan2(m.sqrt(a), m.sqrt(1 - a));

    return (_earthRadius * c);
  }

  Widget rideDetailsRequest(
    BuildContext context, {
    required List cordinates,
    required String locationAName,
    required String locationBName,
    required List locationBCordinates,
    required String fare,
    required String token,
    required Function(bool) setLoadingStatus, // add this parameter
  }) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          height: 500,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            children: [
              SizedBox(
                height: 300,
                width: 300,
                child: Image.network(
                  'https://cdn.pixabay.com/photo/2017/06/08/21/55/car-2385015_960_720.png',
                  fit: BoxFit.contain,
                  height: 300,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Go Intercity',
                            style: TStyleMedia.blackRoboto19SemiBold5,
                          ),
                          Text(
                            '$fare₹',
                            style: TStyleMedia.blackRoboto19SemiBold5,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        'This is not final fare, we may add some discounts in your final fare if you are eligible',
                        style: TStyleMedia.black60Roboto11Light,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NavigationScreen(
                      token: widget.token,
                      toCordinates: [Provider.of<AppInfo>(context, listen: false).userDropOffLocation!.locationLatitude!,Provider.of<AppInfo>(context, listen: false).userDropOffLocation!.locationLongitude!],
                     office: widget.office,
fromCordinates: [Provider.of<AppInfo>(context, listen: false).userPickUpLocation!.locationLatitude,Provider.of<AppInfo>(context, listen: false).userPickUpLocation!.locationLongitude!],
                        locationA: Provider.of<AppInfo>(context, listen: false).userPickUpLocation!.locationName!,
                        locationB: Provider.of<AppInfo>(context, listen: false).userDropOffLocation!.locationName!,
                        userId: widget.userId);
                  }));
                },
                child: isLoading
                    ? const CircularProgressIndicator() // show a loading indicator while loading
                    : buttonWidget('Done'),
              ),
            ],
          ),
        );
      },
    );
  }

  bool isLoading = false;

  void setLoadingStatus(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  // AvailableDriversModel? availablerDrivers;

  Future getUserRequest(String? rideId, BuildContext context) async {
    //('user req');
    //('rideId = $rideId');
    //('sending ride id');
    // var driver;
    // Socket socket =
    //     io(baseUrl, OptionBuilder().setTransports(['websocket']).build());
    // socket.connect();
    // socket.onConnect((data) async {
    //   //('socket connected');
    //   //('ride Id = $rideId');

    //   // socket.emit("GET_USER_REQUEST", {"rideId": rideId});
    //   //('request sent');
    // });
    socket.emit("GET_USER_REQUEST", {"rideId": rideId});

    socket.on(
      "GET_REQUEST",
      ((data) async {
        // var msg = await data;
        //('sending get user request by socket');

        //(msg.toString());
        //('message sent');
        AvailableDriversModel driver = availableDriversModelFromMap(data);
        //(msg.toString());
        if (driver.status == 'assigned') {
          //('ok bhai ab me chlta hu');
          AcceptedRideModel acceptedRideModal =
            acceptedRideModelFromMap(data);
          //('ab nhi ja paunga');
          driverPhone = acceptedRideModal.driver.phone;
          driverEmail = acceptedRideModal.driver.email;
          profileUrl = acceptedRideModal.driver.profileUrl;
          // SharedPreferences preferences = await SharedPreferences.getInstance();
          // //  modelName: ,
          // // otp: ,
          // // locationA:
          // // locationB:
          // // driverNumber:
          // preferences.setBool('assigned', true);
          // preferences.setString('modelName', driver.fare.toString());

          // preferences.setString('otp', driver.otp.toString());

          // preferences.setString('locationA', driver.fromLocation.name);

          // preferences.setString('locationB', driver.toLocation.name);
          // preferences.setString('driverNumber', driver.distance.toString());
          //('converting navigate status');
          navigate = true;
          // driverLocation = Direction(locationLatitude: acceptedRideModal.driver.location.coordinates[0], locationLongitude: acceptedRideModal.driver.location.coordinates[1],);
          // Provider.of<AppInfo>(context,).updateDriverLocation(Direction(locationLatitude: acceptedRideModal.driver.location.coordinates[0], locationLongitude: acceptedRideModal.driver.location.coordinates[1],));

          //('driver email = $driverEmail');
          //('driver ko phone dedia $driverPhone');

          // navigate = true;
          // //('navigate hojana chahiye ab to');
          if (mounted) {
            setState(() {});
          }
        } else {
          if (mounted) {
            setState(() {});
          }
        }
        //('ride status = ${driver.status}');
        // driver.status == "assigned" ? Provider.of<AppInfo>(context,).navigateWhenAccepted(): null;
        // //(driver.toString());
        //('driver sent');
        return await data;
      }),
    );
    //('sending driver');
    // //(driver.toString());
    // return driver!;
  }

  bool loader = false;

  bool popStatus = false;

  bool load = false;

  @override
  Widget build(BuildContext context) {
    if (!controller!.value.isInitialized) {
      return Container();
    }
    return load
        ? Scaffold(
            body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: primaryColor,
                  size: 120,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const CustomText(
                text: 'Please Wait while we are processing',
                color: Colors.white,
                size: 20,
                weight: FontWeight.w400,
              ),
              const Spacer(),
            ],
          ))
        : Scaffold(
            body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Center(
                child: Image.network(
                    'https://cdn.pixabay.com/photo/2018/03/23/08/09/flat-3252983_960_720.png'),
              ),
              const SizedBox(
                height: 10,
              ),
              const CustomText(
                text: 'Please recognize your face',
                color: Colors.white,
                size: 20,
                weight: FontWeight.w400,
              ),
              const Spacer(),
              GestureDetector(
                  onTap: () async {
                    timer = Timer(const Duration(seconds: 60), () {
      if (mounted) {
        showModalBottomSheet(
          context: context,
          isDismissible: false,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(30)),
                ),
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Oops!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Something went wrong or you seem to not be suitable for this ride.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    });
                    image = await controller!.takePicture();
                    setState(() {
                      load = true;
                    });
                    faceDetectionResult = await sendImage(image!);
                    FaceModel data = await faceDetectionResult;
                    setState(() {
                      timer.cancel();
                      load = false;
                    });

                    // data.faceDetection.results[0].gender.decision ==null? //('gender is null'):
                    // //(data.toString());
                    data.faceDetection.results[0].gender.decision == "male"
                        ? showModalBottomSheet(
                            enableDrag: false,
                            isDismissible: false,
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (BuildContext context, setState) {
                                return WillPopScope(
                                  onWillPop: () async {
                                    return popStatus;
                                  },
                                  child: rideDetailsRequest(context,
                                      setLoadingStatus: setLoadingStatus,
                                      cordinates: widget.cordinates,
                                      locationAName:
                                          Provider.of<AppInfo>(context)
                                              .userPickUpLocation!
                                              .locationName!,
                                      locationBName:
                                          Provider.of<AppInfo>(context)
                                              .userDropOffLocation!
                                              .locationName!,
                                      locationBCordinates: [
                                        Provider.of<AppInfo>(context)
                                            .userDropOffLocation!
                                            .locationLatitude!,
                                        Provider.of<AppInfo>(context)
                                            .userDropOffLocation!
                                            .locationLongitude!
                                      ],
                                      token: widget.token,
                                      fare: (calDis(
                                                  widget.cordinates[0],
                                                  widget.cordinates[1],
                                                  Provider.of<AppInfo>(context)
                                                      .userDropOffLocation!
                                                      .locationLatitude!,
                                                  Provider.of<AppInfo>(context)
                                                      .userDropOffLocation!
                                                      .locationLongitude!) *
                                              20)
                                          .toStringAsFixed(2)),
                                );
                              });
                            },
                          )
                        : snackWidget(context,
                            "seems like you are a female, please close the app or try again");
                  },
                  child: buttonWidget('RECOGNIZE YOUR FACE'))
            ],
          )
            // floatingActionButton: FloatingActionButton(
            //   child: const Icon(Icons.camera),
            //   onPressed: () async {
            //     // //('tapped');
            //     try {
            //       image = await controller!.takePicture();
            //       Navigator.push(context, MaterialPageRoute(builder: ((context) {
            //         return DisplayPictureScreen(image: image!);
            //       })));

            //       // await sendImage(image!);
            //       // await sendImage(image!);
            //       // print(controller!.value);

            //       // Navigator.push(
            //       //   context,
            //       //   MaterialPageRoute(
            //       //     builder: (context) => DisplayPictureScreen(),
            //       //   ),
            //       // );
            //     } catch (e) {
            //       print(e);
            //     }
            //   },
            // ),
            );
  }
}

// class DisplayPictureScreen extends StatefulWidget {
//   final XFile image;

//   const DisplayPictureScreen({super.key, required this.image});
//   @override
//   State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
// }

// class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
//   static const _chars =
//       'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
//   final math.Random _rnd = math.Random();

//   String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
//       length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
//   Future<String> uploadImageToFirebase(File image) async {
//     //('called');
//     final Reference storageReference = FirebaseStorage.instance
//         .ref()
//         .child('images/${getRandomString(20)}.jpg');
//     //('created');
//     final UploadTask uploadTask = storageReference.putFile(image);
//     await uploadTask;
//     //('uploaded');

//     final String downloadUrl = await storageReference.getDownloadURL();
//     //('got url $downloadUrl');
//     return downloadUrl;
//   }

//   bool _isCreatingLink = false;
//   FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
//   String? _linkMessage;

//   Future _createDynamicLink(bool short, XFile image) async {
//     setState(() {
//       _isCreatingLink = true;
//     });
//     final String DynamicLink = 'https://themahi19.page.link';

//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: 'https://themahi19.page.link',
//       // longDynamicLink: Uri.parse(
//       //   await uploadImageToFirebase(File(image.path)),
//       // ),
//       link: Uri.parse(
//         await uploadImageToFirebase(File(image.path)),
//       ),
//     );
//     Uri url;
//     if (short) {
//       final ShortDynamicLink shortLink =
//           await dynamicLinks.buildShortLink(parameters);
//       url = shortLink.shortUrl;
//       //(url.toString());
//     } else {
//       url = await dynamicLinks.buildLink(parameters);
//       //(url.toString());
//     }
//     setState(() {
//       _linkMessage = url.toString();
//       _isCreatingLink = false;
//     });
// //
//     // //(_linkMessage!);
//     return url.toString();
//   }

//   // final DynamicLinkParameters parameters = DynamicLinkParameters(
//   //   uriPrefix: 'https://flutterfiretests.page.link',
//   //   longDynamicLink: Uri.parse(
//   //     'https://flutterfiretests.page.link?efr=0&ibi=io.flutter.plugins.firebase.dynamiclinksexample&apn=io.flutter.plugins.firebase.dynamiclinksexample&imv=0&amv=0&link=https%3A%2F%2Fexample%2Fhelloworld&ofl=https://ofl-example.com',
//   //   ),
//   //   link: Uri.parse("themahi19.page.link"),
//   //   // androidParameters: const AndroidParameters(
//   //   //   packageName: 'io.flutter.plugins.firebase.dynamiclinksexample',
//   //   //   minimumVersion: 0,
//   //   // ),
//   //   // iosParameters: const IOSParameters(
//   //   //   bundleId: 'io.flutter.plugins.firebase.dynamiclinksexample',
//   //   //   minimumVersion: '0',
//   //   // ),
//   // );

//   Future sendImage(XFile selectedImage) async {
//     //('methos called');
//     // Map<String, dynamic> params = {
//     //   "API_KEY": "vwD6B0tQMX2CcEVCAemNVIkoWxC9yW9k",
//     //   "task": "face_gender_detection",
//     //   "url_image": uploadImageToFirebase(File(image!.path))
//     // };
//     String url = await _createDynamicLink(true, selectedImage);
//     //(url);
//     Response response = await get(
//       Uri.parse(
//         'https://www.picpurify.com/analyse/1.1?API_KEY=vwD6B0tQMX2CcEVCAemNVIkoWxC9yW9k&task=face_gender_detection&url_image=$url',
//       ),
//     );

//     //('api called');
//     if (response.statusCode == 200) {
//       print(response.body);
//       return response.body;
//       // return parseFaceDetectionResult(response.body);
//       // //(response.body);
//     }
//     //(response.statusCode.toString());
//   }

//   FaceModel parseFaceDetectionResult(String responseBody) {
//     final jsonData = json.decode(responseBody);
//     return FaceModel.fromMap(jsonData);
//   }

//   late Future faceDetectionResult;

//   void initState() {
//     super.initState();
//     faceDetectionResult = sendImage(widget.image);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: FutureBuilder(
//             future: faceDetectionResult,
//             builder: ((context, snapshot) {
//               if (snapshot.hasData) {
//                 return Center(child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Text(snapshot.data, style: TextStyle(fontSize: 20,),),
//                 ));
//               }
//               return CircularProgressIndicator.adaptive();
//             }),),);
//   }
// }
