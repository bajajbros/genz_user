import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:customer/components/color.dart';
import 'package:customer/screen/order/confirm_ride.dart';
import 'package:customer/screen/search_page_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as m;
import '../backend/accepted_ride.dart';
import '../backend/driver_details_model.dart';
import '../main.dart';

class NavigationScreen extends StatefulWidget {
  final String token;
  final List fromCordinates;
  final List toCordinates;
  final bool office;
  final String locationA;
  final String locationB;
  final String userId;
  const NavigationScreen({
    super.key,
    required this.locationA,
    required this.locationB,
    required this.office,
    required this.fromCordinates,
    required this.toCordinates,
    required this.userId,
    required this.token,
  });

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  String? rideId;
  AcceptedRideModel? acceptedRideModel;
  @override
  void initState() {
    _createRide();

    super.initState();
  }

  Future<Widget> getAvailableDrivers({
    required String userId,
    required bool office,
    required List cordinates,
    required String locationAName,
    required String locationBName,
    required List locationBCordinates,
    // required String token,
    required BuildContext context,
  }) async {
    const double earthRadius = 6371;

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

      return (earthRadius * c);
    }

    //('method of create ride');
    num distance = calDis(cordinates[0], cordinates[1], locationBCordinates[0],
        locationBCordinates[1]);
    var rideDetails = {
      "rideDetails": {
        "fromLocation": {
          "name": locationAName,
          "coordinates": [cordinates[0], cordinates[1]]
        },
        "toLocation": {
          "name": locationBName,
          "coordinates": [locationBCordinates[0], locationBCordinates[1]]
        },
        "distance": distance,
        "userId": userId,
        "rideType": office ? "office" : "normal",
      }
    };

    socket.emit("CREATE_RIDE", rideDetails);
    log('create ride emitted already');
    log(rideDetails.toString());

    socket.on(
      "CREATE_RIDE",
      ((data) async {
        log(data);
        if (mounted) {
          setState(() {
            rideId = jsonDecode(data)['availableDrivers']['_id'];
          });
        }

        socket.emit("GET_USER_REQUEST", {"rideId": rideId});
        socket.on(
          "GET_REQUEST",
          ((data) async {
            log('sending create ride data');
            log(data);
            if (data != null) {
              AvailableDriversModel driver = availableDriversModelFromMap(data);
              log(driver.status);
              if (driver.status == 'pending') {}

              if (driver.status == 'assigned') {
                log('asssigned hai bhai ab faltu nhi');
                acceptedRideModel = acceptedRideModelFromMap(data);
                setState(() {
                  navigate = true;
                });
              }
            }

            // return Container();
          }),
        );
        // return Container();
      }),
    );
    return const CircularProgressIndicator.adaptive();
  }

  // Widget _rideStatusWidget = const SizedBox();

  Future<void> _createRide() async {
    // setState(() {
    //   _rideStatusWidget = const CircularProgressIndicator.adaptive();
    // });

    try {
      await getAvailableDrivers(
        userId: widget.userId,
        office: widget.office,
        cordinates: widget.fromCordinates,
        locationAName: widget.locationA,
        locationBName: widget.locationB,
        locationBCordinates: widget.toCordinates,
        context: context,
      );

      // setState(() {
      //   _rideStatusWidget = wid;
      // });
    } catch (e) {
      // setState(() {
      //   _rideStatusWidget = const Text('Error creating ride');
      // });
    }
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  // getInstance() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   setState(() {
  //     pref = prefs!;
  //   });
  //   return pref;
  // }

  // SharedPreferences? prefs;
  @override
  Widget build(BuildContext context) {
    if (navigate) {
      setState(() {});
      return ConfirmRide(
        driverName: acceptedRideModel!.driver.name,
        carNumber: acceptedRideModel!.driver.carDetails.carNumber,
        profileUrl: acceptedRideModel!.driver.profileUrl,
        userId: widget.userId,
        driverEmail: acceptedRideModel!.driver.email,
        token: widget.token,
        modelName: acceptedRideModel!.finalFare.toStringAsFixed(2),
        otp: acceptedRideModel!.otp,
        locationA: widget.locationA,
        locationB: widget.locationB,
        driverNumber: acceptedRideModel!.driver.phone,
        rideId: acceptedRideModel!.id,
      );
    } else if (rideId != null) {
      setState(() {});
      return SearchPageScreen(
        token: widget.token,
        userId: widget.userId,
        rideId: rideId!,
      );
    } else {
      setState(() {});
      return const Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(primaryColor),
      ));
    }

    //   return navigate
    //       ? ConfirmRide(
    //           modelName: widget.modelName,
    //           otp: widget.otp,
    //           locationA: widget.locationA,
    //           locationB: widget.locationB)
    //       :
    // }
  }
}
