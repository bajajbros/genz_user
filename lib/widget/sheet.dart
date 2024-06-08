// import 'dart:convert';
// import 'dart:developer';

// import 'package:customer/helper/button.dart';
// import 'package:flutter/material.dart';

// import '../backend/accepted_ride.dart';
// import '../backend/driver_details_model.dart';
// import '../camera_test.dart';
// import '../components/text_style.dart';
// import '../main.dart';
// import '../screen/navigation_screen.dart';
// import '../screen/search_page_screen.dart';
// import 'dart:math' as m;

// class RideDetailsRequest extends StatefulWidget {
//   final List cordinates;
//   final String locationAName;
//   final String locationBName;
//   final List locationBCordinates;
//   final String fare;
//   final String token;
//   final String userId;
//   final bool office;

//   const RideDetailsRequest({
//     Key? key,
//     required this.cordinates,
//     required this.locationAName,
//     required this.locationBName,
//     required this.locationBCordinates,
//     required this.fare,
//     required this.token,
//     required this.userId,
//     required this.office,
//   }) : super(key: key);

//   @override
//   _RideDetailsRequestState createState() => _RideDetailsRequestState();
// }

// class _RideDetailsRequestState extends State<RideDetailsRequest> {
//   Future getAvailableDrivers({
//     required String userId,
//     required bool office,
//     required List cordinates,
//     required String locationAName,
//     required String locationBName,
//     required List locationBCordinates,
//     required String token,
//     required BuildContext context,
//   }) async {
//       final double _earthRadius = 6371;

//     double calDis(double lat1, double lon1, double lat2, double lon2) {
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

//     return (_earthRadius * c);
//   }


   
//     final currenContext = context;
//     //('method of create ride');
//     num distance = calDis(cordinates[0], cordinates[1], locationBCordinates[0],
//         locationBCordinates[1]);
//     var rideDetails = {
//       "rideDetails": {
//         "fromLocation": {
//           "name": locationAName,
//           "coordinates": [cordinates[0], cordinates[1]]
//         },
//         "toLocation": {
//           "name": locationBName,
//           "coordinates": [locationBCordinates[0], locationBCordinates[1]]
//         },
//         "distance": distance,
//         "userId": userId,
//         "rideType": office ? "office" : "normal",
//       }
//     };

//     // Socket socket =
//     //     io(baseUrl, OptionBuilder().setTransports(['websocket']).build());
//     // if (socket.active) {
//     socket.emit("CREATE_RIDE", rideDetails);
//     log('create ride emitted already');

//     //('ride created');
//     // } else {
//     //   socket.connect();
//     //   socket.onConnect((data) async {
//     //     //('ride connected');
//     //     //(rideDetails.toString());
//     //     socket.emit("CREATE_RIDE", rideDetails);
//     //           log('create ride emitted after connecting');

//     //     //('ride created');
//     //   });
//     // }

//     socket.on(
//       "CREATE_RIDE",
//       ((data) async {
//         //('sending create ride listen');
//         //(data);

//         String rideId = jsonDecode(data)['availableDrivers']['_id'];
//         socket.emit("GET_USER_REQUEST", {"rideId": rideId});
//         socket.on(
//           "GET_REQUEST",
//           ((data) async {
//             var msg = await data;
//             //('sending get user request by socket');

//             //(msg.toString());
//             //('message sent');
//             // log(data);
         
//             AvailableDriversModel driver = availableDriversModelFromMap(data);
//                if (driver.status == "pending") {
//               Navigator.pushAndRemoveUntil(currenContext, MaterialPageRoute(
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
//             }
            
//             //(msg.toString());
//             if (driver.status == 'assigned') {
//               //('ok bhai ab me chlta hu');
//               AcceptedRideModal acceptedRideModal =
//                   AcceptedRideModal.fromMap(jsonDecode(data));
//               //('ab nhi ja paunga');
//               // SharedPreferences preferences = await SharedPreferences.getInstance();
//               // //  modelName: ,
//               // // otp: ,
//               // // locationA:
//               // // locationB:
//               // // driverNumber:
//               // preferences.setBool('assigned', true);
//               // preferences.setString('modelName', driver.fare.toString());

//               // preferences.setString('otp', driver.otp.toString());

//               // preferences.setString('locationA', driver.fromLocation.name);

//               // preferences.setString('locationB', driver.toLocation.name);
//               // preferences.setString('driverNumber', driver.distance.toString());
//               profileUrl = acceptedRideModal.driver.profileUrl;

//               //('converting navigate status');
//               navigate = true;
//               // driverLocation = Direction(locationLatitude: acceptedRideModal.driver.location.coordinates[0], locationLongitude: acceptedRideModal.driver.location.coordinates[1],);
//               // Provider.of<AppInfo>(context,).updateDriverLocation(Direction(locationLatitude: acceptedRideModal.driver.location.coordinates[0], locationLongitude: acceptedRideModal.driver.location.coordinates[1],));
//               driverPhone = acceptedRideModal.driver.phone;
//               driverEmail = acceptedRideModal.driver.email;
//               //('driver email = $driverEmail');
//               //('driver ko phone dedia $driverPhone');

//               // navigate = true;
//               // //('navigate hojana chahiye ab to');
//               if (mounted) {
//                 setState(() {
//                   // socket.disconnect();
//                 });
//               }
//             } else {
//               if (mounted) {
//                 setState(() {});
//               }
//             }
//             //('ride status = ${driver.status}');
//             // driver.status == "assigned" ? Provider.of<AppInfo>(context,).navigateWhenAccepted(): null;
//             // //(driver.toString());
//             //('driver sent');
//             return await data;
//           }),
//         );

//         // await getUserRequest(
//         //     rideId, context);
//         //(availableDriversModel.availableDrivers.id);
//       }),
//     );
//   }
//   bool _isLoading = false;

//   void _handleDoneButtonPressed() async {
//     setState(() {
//       _isLoading = true;
//     });

//     await getAvailableDrivers(
//       userId: widget.userId,
//       office: widget.office,
//       context: context,
//       cordinates: widget.cordinates,
//       locationAName: widget.locationAName,
//       locationBName: widget.locationBName,
//       locationBCordinates: widget.locationBCordinates,
//       token: widget.token,
//     );

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 500,
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         children: [
//           SizedBox(
//             height: 300,
//             width: 300,
//             child: Image.asset(
//               'images/car1.png',
//               fit: BoxFit.contain,
//               height: 300,
//               // width: 200,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40.0),
//             child: SizedBox(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Go Intercity',
//                         style: TStyleMedia.blackRoboto19SemiBold5,
//                       ),
//                       Text(
//                         '${widget.fare}₹',
//                         style: TStyleMedia.blackRoboto19SemiBold5,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 2,
//                   ),
//                   Text(
//                     'This is not final fare, we may add some discounts in your final fare if you are eligible',
//                     style: TStyleMedia.black60Roboto11Light,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           _isLoading
//               ? const CircularProgressIndicator()
//               : GestureDetector(
//                   onTap: _handleDoneButtonPressed,
//                   child: buttonWidget('Done'),
//                 ),
//         ],
//       ),
//     );
//   }
// }
