// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:customer/backend/assistant_method.dart';
import 'package:customer/camera_test.dart';
import 'package:customer/helper/snackBar.dart';
import 'package:customer/module_helper/app_info.dart';
import 'package:customer/screen/search_screen/drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../api/api_value.dart';
import '../../backend/profile_model.dart';
import '../../components/color.dart';
import '../../components/sized.dart';
import '../../components/text_style.dart';
import '../../helper/button.dart';
import '../../module/direction_module.dart';
import '../search_screen/pick.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String userId;
  // final Position position;
  final bool office;
  final String token;
  // final String userName;
  // final String userPhone;
  // final String userId;
  const HomeScreen(
      {Key? key,
      // required this.userId,
      // required this.userName,
      // required this.userPhone,
      required this.token,
      required this.office,
      // required this.position,
      required this.userId})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Profile> getProfile() async {
    log('method called');
    String url = '$baseUrl/api/user/profile';
    Map<String, String> headers = {'Authorization': 'Bearer ${widget.token}'};

    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        // log(response.body);
        Profile profile = profileFromMap(response.body);

        // log(profile.profile.toString());
        return profile;
      } else {
        throw 'Error calling API';
      }
    } catch (err) {
      rethrow;
    }
  }

  String mapJson = '';
  @override
  void initState() {
    DefaultAssetBundle.of(context).loadString('images/theme.json').then(
      (value) {
        mapJson = value;
      },
    );
    checkIfPermissionAllowed();
    // locateUserPosition();
    super.initState();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? newGoogleMapController;

  Position? currentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;

  checkIfPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
      if (_locationPermission == LocationPermission.denied) {
        checkIfPermissionAllowed();
      } else if (_locationPermission == LocationPermission.deniedForever) {
        return;
      } else if (_locationPermission == LocationPermission.unableToDetermine) {}
    }
  }

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition();
    currentPosition = cPosition;

    // !
    // .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    if (mounted) {
      String pickUpAddress =
          await AssistantMethod.searchAddressForGeographicCoOrdinates(
              cPosition, context);

      Provider.of<AppInfo>(context, listen: false).updatePickUpLocation(
        Direction(
            locationName: pickUpAddress,
            locationLatitude: currentPosition!.latitude,
            locationLongitude: currentPosition!.longitude),
      );
    }
  }

  final PanelController panelController = PanelController();

  List<LatLng> pLineCoOrdinateList = [];
  Set<Polyline> polylineSet = {};

  // File? image;

  Future pickImage() async {
    try {
      // final image = await ImagePicker().pickImage(source: ImageSource.camera);
      // if (image == null) return;
      // final imageTemp = File(image.path);
      // setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  bool back = false;
  Future<bool> _onWillPop() {
  // Delay the pop for 2 seconds
  Future.delayed(const Duration(seconds: 1)).then((value) {
    Navigator.pop(context);
  });
  // Return false to prevent the default pop action
  return Future.value(false);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        color: backgroundColor,
        controller: panelController,
        minHeight: MediaQuery.of(context).size.height / 3.9,
        maxHeight: MediaQuery.of(context).size.height / 2.5,
        body: Stack(
          children: [
            GoogleMap(
              minMaxZoomPreference: const MinMaxZoomPreference(1, 16),
              // mapType: MapType.terrain,
              myLocationEnabled: true,
              markers: markerSet,
              circles: circleSet,
              zoomControlsEnabled: true,
              polylines: polylineSet,
              zoomGesturesEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) async {
                await locateUserPosition();

                String style = await DefaultAssetBundle.of(context)
                    .loadString('images/theme.json');
                log(style);
                if (currentPosition != null) {
                  LatLng latLngPosition = LatLng(
                      currentPosition!.latitude, currentPosition!.longitude);

                  CameraPosition cameraPosition =
                      CameraPosition(target: latLngPosition, zoom: 14);

                  _controller.complete(controller);
                  newGoogleMapController = controller;
                  // newGoogleMapController = controller;
                  newGoogleMapController!.animateCamera(
                      CameraUpdate.newCameraPosition(cameraPosition));
                } else {
                  setState(() {});
                }

                try {
                  log('map changing');
                  newGoogleMapController!
                      .setMapStyle(style)
                      .whenComplete(() => log('done hogay bhai map'));
                } catch (e) {
                  log(e.toString());
                }
                setState(() {
                  back = true;
                });
              },
            ),
            Positioned(
              top: MediaQuery.of(context).size.width * 0.10,
              child: Container(
                height: MediaQuery.of(context).size.height / 17.33,
                width: MediaQuery.of(context).size.width * 0.90,
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 19,
                    ),
                    const Icon(Icons.location_on_sharp),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 50,
                    ),
                    Text(
                      Provider.of<AppInfo>(context).userPickUpLocation != null
                          ? Provider.of<AppInfo>(context)
                                      .userPickUpLocation!
                                      .locationName!
                                      .length >
                                  40
                              ? '${Provider.of<AppInfo>(context).userPickUpLocation!.locationName!.substring(0, 40)}...'
                              : Provider.of<AppInfo>(context)
                                  .userPickUpLocation!
                                  .locationName!
                          : 'Select your location',
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 50,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        panelBuilder: (controller) {
          return ListView(
            controller: controller,
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 26,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 4.87,
                width: MediaQuery.of(context).size.width / 1.2,
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border.all(width: 0.1, color: ColorMedia.white),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 39,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SearchScreenPickup()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorMedia.greyLight,
                            borderRadius: BorderRadius.circular(10)),
                        width: SizedMedia.widthDivide(context, 1.3),
                        height: SizedMedia.heightDivide(context, 18),
                        child: Center(
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              const Icon(Icons.search_outlined),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 235,
                                child: Text(
                                  Provider.of<AppInfo>(context)
                                              .userPickUpLocation !=
                                          null
                                      ? Provider.of<AppInfo>(context)
                                          .userPickUpLocation!
                                          .locationName!
                                          .toString()
                                      : 'Enter pickup point',
                                  style: TStyleMedia.blue20Roboto16Medium2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 31.2,
                    ),
                    GestureDetector(
                      onTap: () async {
                        var responseNavigation = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SearchScreenDrop()));

                        print(responseNavigation);
                        if (responseNavigation == 'obtainedDropOff') {
                          print('answer me');
                          await drawPolylineFromSourceToDestination();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorMedia.greyLight,
                            borderRadius: BorderRadius.circular(10)),
                        width: SizedMedia.widthDivide(context, 1.3),
                        height: SizedMedia.heightDivide(context, 18),
                        child: Center(
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              const Icon(
                                Icons.location_on_sharp,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                Provider.of<AppInfo>(context)
                                            .userDropOffLocation !=
                                        null
                                    ? Provider.of<AppInfo>(context)
                                        .userDropOffLocation!
                                        .locationName!
                                        .toString()
                                    : 'Set your destination      >',
                                style: TStyleMedia.blue20Roboto16Medium2,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<Profile>(
                  future: getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Provider.of<AppInfo>(context, listen: false)
                                  .userPickUpLocation !=
                              null
                          ? InkWell(
                              onTap: () {
                                Provider.of<AppInfo>(context, listen: false)
                                            .userDropOffLocation ==
                                        null
                                    ? snackWidget(context,
                                        "Please select destination first")
                                    : snapshot.data!.profile.phone == ""
                                        ? snackWidget(context,
                                            'Please update mobile number in profile')
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return MyApp(
                                                  userId: widget.userId,
                                                  office: widget.office,
                                                  token: widget.token,
                                                  cordinates: [
                                                    Provider.of<AppInfo>(
                                                            context)
                                                        .userPickUpLocation!
                                                        .locationLatitude!,
                                                    Provider.of<AppInfo>(
                                                            context)
                                                        .userPickUpLocation!
                                                        .locationLongitude!
                                                  ],
                                                );
                                              },
                                            ),
                                          );

                                // showModalBottomSheet(
                                //     context: context,
                                //     builder: (context){
                                //       return rideDetailsRequest(context);
                                //     }
                                // );
                              },
                              child: buttonWidget('Search cab'),
                            )
                          : Container();
                    }
                    return Container();
                  })
            ],
          );
        },
        parallaxEnabled: true,
        parallaxOffset: 0.5,
      ),
    );
  }

  Future<void> drawPolylineFromSourceToDestination() async {
    print('drawPolylineFromSourceToDestination');

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(left: 100.0),
            child: Row(
              children: [
                const CircularProgressIndicator(
                  color: primaryColor,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'Please Wait...',
                  style: TStyleMedia.whiteMohave18Medium0,
                )
              ],
            ),
          );
        });

    print('1');
    var sourcePosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var sourceLatLng = LatLng(
        sourcePosition!.locationLatitude!, sourcePosition.locationLongitude!);
    var destinationLanLng = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition.locationLongitude!);

    print('2');

    print(sourceLatLng.longitude);
    print(destinationLanLng.latitude);
    var directionDetailsInfo =
        await AssistantMethod.obtainOriginToDestinationDirectionDetails(
            sourceLatLng, destinationLanLng);

    print('Value is pronitind');
    print(directionDetailsInfo.ePoint);

    Navigator.pop(context);

    PolylinePoints pPoints = PolylinePoints();

    List<PointLatLng> decodePointResultList =
        pPoints.decodePolyline(directionDetailsInfo.ePoint);

    pLineCoOrdinateList.clear();

    if (decodePointResultList.isNotEmpty) {
      for (var pointLatLng in decodePointResultList) {
        pLineCoOrdinateList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
          polylineId: const PolylineId('PolylineId'),
          color: primaryColor,
          jointType: JointType.round,
          points: pLineCoOrdinateList,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);
      polylineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if (sourceLatLng.latitude > destinationLanLng.latitude &&
        sourceLatLng.longitude > destinationLanLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLanLng, northeast: sourceLatLng);
    } else if (sourceLatLng.longitude > destinationLanLng.longitude) {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(sourceLatLng.latitude, destinationLanLng.longitude),
          northeast:
              LatLng(destinationLanLng.latitude, sourceLatLng.longitude));
    } else if (sourceLatLng.latitude > destinationLanLng.latitude) {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(destinationLanLng.latitude, sourceLatLng.longitude),
          northeast:
              LatLng(destinationLanLng.latitude, sourceLatLng.longitude));
    } else {
      boundsLatLng =
          LatLngBounds(southwest: sourceLatLng, northeast: destinationLanLng);
    }
    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 100));

    Marker originMarker = Marker(
      markerId: const MarkerId('originId'),
      infoWindow:
          InfoWindow(title: sourcePosition.locationName, snippet: 'origin'),
      position: sourceLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId('destinationId'),
      infoWindow: InfoWindow(
          title: destinationPosition.locationName, snippet: 'destination'),
      position: destinationLanLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    setState(() {
      markerSet.add(originMarker);

      markerSet.add(destinationMarker);
    });

    Circle originCircle = Circle(
        circleId: const CircleId('originId'),
        fillColor: primaryColor,
        radius: 12,
        strokeWidth: 3,
        strokeColor: ColorMedia.white,
        center: sourceLatLng);

    Circle destinationCircle = Circle(
        circleId: const CircleId('destinationId'),
        fillColor: ColorMedia.green50,
        radius: 12,
        strokeWidth: 3,
        strokeColor: Colors.white,
        center: destinationLanLng);

    setState(() {
      circleSet.add(originCircle);
      circleSet.add(destinationCircle);
    });
  }
}

class PanelWidget extends StatefulWidget {
  //final PanelController controller;
  final ScrollController scrollController;

  const PanelWidget({Key? key, required this.scrollController})
      : super(key: key);

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  List<LatLng> pLineCoOrdinateList = [];
  Set<Polyline> polylineSet = {};

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.scrollController,
      padding: EdgeInsets.zero,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 26,
        ),
        Container(
          height: MediaQuery.of(context).size.height / 4.87,
          width: MediaQuery.of(context).size.width / 1.2,
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
              border: Border.all(width: 0.1, color: Colors.black),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 39,
              ),
              GestureDetector(
                onTap: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> const SearchScreenPickupAndDrop()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorMedia.greyLight,
                      borderRadius: BorderRadius.circular(10)),
                  width: SizedMedia.widthDivide(context, 1.3),
                  height: SizedMedia.heightDivide(context, 18),
                  child: Center(
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        const Icon(Icons.search_outlined),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 235,
                          child: Text(
                            Provider.of<AppInfo>(context).userPickUpLocation !=
                                    null
                                ? Provider.of<AppInfo>(context)
                                    .userPickUpLocation!
                                    .locationName!
                                    .toString()
                                : 'Enter pickup point',
                            style: TStyleMedia.blue20Roboto16Medium2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 31.2,
              ),
              // GestureDetector(
              //   onTap: () async {
              //     var responseNavigation = await Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) =>
              //                 const SearchScreenPickupAndDrop()));

              //     print(responseNavigation);
              //     if (responseNavigation == 'obtainedDropOff') {
              //       print('answer me');
              //       await drawPolylineFromSourceToDestination();
              //     }
              //   },
              //   child: Container(
              //     decoration: BoxDecoration(
              //         color: ColorMedia.greyLight,
              //         borderRadius: BorderRadius.circular(10)),
              //     width: SizedMedia.widthDivide(context, 1.3),
              //     height: SizedMedia.heightDivide(context, 18),
              //     child: Center(
              //       child: Row(
              //         children: [
              //           const SizedBox(
              //             width: 20,
              //           ),
              //           const Icon(
              //             Icons.location_on_sharp,
              //           ),
              //           const SizedBox(
              //             width: 20,
              //           ),
              //           Text(
              //             Provider.of<AppInfo>(context).userDropOffLocation !=
              //                     null
              //                 ? Provider.of<AppInfo>(context)
              //                     .userDropOffLocation!
              //                     .locationName!
              //                     .toString()
              //                 : 'Set your destination      >',
              //             style: TStyleMedia.blue20Roboto16Medium2,
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> drawPolylineFromSourceToDestination() async {
    print('drawPolylineFromSourceToDestination');

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(left: 100.0),
            child: Row(
              children: [
                const CircularProgressIndicator(
                  color: primaryColor,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'Please Wait...',
                  style: TStyleMedia.whiteMohave18Medium0,
                )
              ],
            ),
          );
        });

    print('1');
    var sourcePosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var sourceLatLng = LatLng(
        sourcePosition!.locationLatitude!, sourcePosition.locationLongitude!);
    var destinationLanLng = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition.locationLongitude!);

    print('2');

    print(sourceLatLng.longitude);
    print(destinationLanLng.latitude);
    var directionDetailsInfo =
        await AssistantMethod.obtainOriginToDestinationDirectionDetails(
            sourceLatLng, destinationLanLng);

    print('Value is pronitind');
    print(directionDetailsInfo.ePoint);

    Navigator.pop(context);

    PolylinePoints pPoints = PolylinePoints();

    List<PointLatLng> decodePointResultList =
        pPoints.decodePolyline(directionDetailsInfo.ePoint);

    pLineCoOrdinateList.clear();

    if (decodePointResultList.isNotEmpty) {
      for (var pointLatLng in decodePointResultList) {
        pLineCoOrdinateList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
          polylineId: const PolylineId('PolylineId'),
          color: ColorMedia.orange,
          jointType: JointType.round,
          points: pLineCoOrdinateList,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);
      polylineSet.add(polyline);
    });
  }
}
