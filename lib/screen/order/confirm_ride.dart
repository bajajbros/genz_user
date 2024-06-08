import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:customer/screen/home/home_page.dart';
import 'package:customer/screen/order/ride_book_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../backend/live_location_model.dart';
import '../../components/color.dart';
import '../../main.dart';
import '../search_page_screen.dart';

class ConfirmRide extends StatefulWidget {
  final String carNumber;
  final String driverName;
  final String profileUrl;
  final String userId;
  final String driverEmail;
  final String token;
  final String rideId;
  final String driverNumber;
  final String modelName;
  final String otp;
  final String locationA;
  final String locationB;
  const ConfirmRide(
      {Key? key,
      required this.modelName,
      required this.otp,
      required this.locationA,
      required this.locationB,
      required this.driverNumber,
      required this.rideId,
      required this.token,
      required this.driverEmail,
      required this.userId,
      required this.profileUrl,
      required this.carNumber,
      required this.driverName})
      : super(key: key);

  @override
  State<ConfirmRide> createState() => _ConfirmRideState();
}

class _ConfirmRideState extends State<ConfirmRide> {
  String? rideId;
  String? driverEmail;
  String? driverNumber;
  String? locAName;
  String? locBName;
  String? otp;
  String? fare;
  LatLng driverLocation = const LatLng(37.4219983, -122.084);
  LatLng destinationLocation = const LatLng(37.7749, -122.4194);
  LatLng userLocation = const LatLng(37.4219983, -122.084);

  List<LatLng> polylineCoordinates = [];
  Polyline? polyline;
  Future updateLocation(String driverId, String rideId) async {
    log('method called of live location');

    // Socket socket =
    //     io(baseUrl, OptionBuilder().setTransports(['websocket']).build());
    var creds = {"driverEmail": driverId, "rideId": rideId};
    // if (socket.connected) {
    socket.emit("GET_DRIVER_LOCATION", creds);
    //   log('location request emmitted');
    // } else {
    //   socket.connect();
    //   socket.onConnect((data) => socket.emit("GET_DRIVER_LOCATION", creds));
    //   log('location request emmitted after connecting');
    // }
    // socket.connect();
    // socket.onConnect((data) async {
    //   log('socket ho chuka hai connecet');
    //   // var data = {"driverEmail": driverId, "rideId": rideId};
    //   log(data.toString());
    //   // socket.emit("GET_DRIVER_LOCATION", data);
    //   // log('location request emmitted');
    // });
    socket.on(
      "GET_LIVE_LOCATION",
      ((data) async {
        log('sending live data');
        log(data);
        // log(data);
        if (data != null) {
          String? rideId = jsonDecode(data)['rideDetails']['_id'];
          if (rideId!=null) {
            
          
          if (rideId == widget.rideId) {
            LiveRide liveRide = liveRideFromJson(data);
            if (liveRide.driver!.location != null) {
              driverLocation = LatLng(
                  liveRide.driver!.location!.coordinates![0],
                  liveRide.driver!.location!.coordinates![1]);
              destinationLocation = LatLng(
                  liveRide.rideDetails!.toLocation!.coordinates![0],
                  liveRide.rideDetails!.toLocation!.coordinates![1]);
              if (mounted) {
                setState(() {});
              }
            } else {
              setState(() {});
            }

            if (liveRide.rideDetails!.status == "completed" ||
                liveRide.rideDetails!.status == "rejected" ||
                liveRide.rideDetails!.status == 'cancelled') {
              if (mounted) {
                navigate = false;
              }
              if (mounted) {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return HomePage(token: widget.token, userId: widget.userId);
                }), (route) => false);
              }
            } else if (liveRide.rideDetails!.status == "assigned") {}
          }
        }
        }
      }),
    );
  }

  Set<Marker> markers = {};

  void _updatePolyline() {
    // Update the polyline coordinates
    setState(() {
      polylineCoordinates = [
        driverLocation,
        userLocation,
        destinationLocation,
      ];
      polyline = Polyline(
        jointType: JointType.round,
        endCap: Cap.roundCap,
        polylineId: const PolylineId("poly"),
        color: primaryColor,
        points: polylineCoordinates,
        width: 5,
      );
      markers = {
        Marker(
          markerId: const MarkerId("driver"),
          position: driverLocation,
          infoWindow: const InfoWindow(title: "Driver"),
          icon: carIcon,
        ),
        Marker(
          markerId: const MarkerId("destination"),
          position: destinationLocation,
          infoWindow: const InfoWindow(title: "Destination"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
        Marker(
          markerId: const MarkerId("user"),
          position: userLocation,
          infoWindow: const InfoWindow(title: "User"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      };
    });
  }

  // Direction? driverLocation;
  final PanelController panelControllerNew = PanelController();
  final Completer<GoogleMapController> _controller = Completer();

  // List<LatLng> pLineCoOrdinateListNew = [];
  Set<Polyline> polylineSetNew = {};

  Set<Marker> markerSetNew = {};
  Set<Circle> circleSetNew = {};

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  List<LatLng> pLineCoOrdinateList = [];
  Set<Polyline> polylineSet = {};
  late BitmapDescriptor carIcon;

  _addMarker(double lat, double lng) async {
    // String imgurl = "https://icons8.com/icon/42757/car-top-view";
    // Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imgurl)).load(imgurl))
    //     .buffer
    //     .asUint8List();
    // log('i am in marker');
    // log(_marker.length.toString());
    setState(() {
      markerSet.add(
        Marker(
          markerId: const MarkerId('default_id'),
          position: LatLng(lat, lng),
          icon: carIcon,
          infoWindow: const InfoWindow(
            title: 'Location',
            snippet: 'its location',
          ),
        ),
      );
    });
  }

  Future<void> setCustomMapPin(double zoom) async {
    ByteData data = await rootBundle.load('images/car3.png');
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: 100);
    ui.FrameInfo fi = await codec.getNextFrame();
    final Uint8List markerIcon =
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List();
    carIcon = BitmapDescriptor.fromBytes(markerIcon);
  }

  late Timer timer;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      updateLocation(widget.driverEmail, widget.rideId);
      setCustomMapPin(MediaQuery.of(context).size.width);
    });
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _updatePolyline();

          updateLocation(widget.driverEmail, widget.rideId);
        });
      }
    });
    // timer;
    // updateLocation(widget.driverEmail, widget.rideId);

    // setValues();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  LatLng? driverLoc;

  // Future<void> drawPolylineFromSourceToDestination(
  //   List<double> lat,
  //   List<double> long,
  // ) async {
  //   log('drawPolylineFromSourceToDestination');

  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Padding(
  //           padding: const EdgeInsets.only(left: 100.0),
  //           child: Row(
  //             children: [
  //               const CircularProgressIndicator(
  //                 color: primaryColor,
  //               ),
  //               const SizedBox(
  //                 width: 20,
  //               ),
  //               Text(
  //                 'Please Wait...',
  //                 style: TStyleMedia.whiteMohave18Medium0,
  //               )
  //             ],
  //           ),
  //         );
  //       });

  //   print('1');
  //   var sourcePosition = Direction(
  //       locationLongitude: lat[0],
  //       locationLatitude: lat[1],
  //       locationName: 'name');
  //   var destinationPosition = Direction(
  //       locationLongitude: long[0],
  //       locationLatitude: long[1],
  //       locationName: 'uttam nagar');
  //   log('got both lat lng');

  //   var sourceLatLng = LatLng(
  //       sourcePosition.locationLatitude!, sourcePosition.locationLongitude!);
  //   var destinationLanLng = LatLng(destinationPosition.locationLatitude!,
  //       destinationPosition.locationLongitude!);
  //   log('got both lat lng 2');

  //   var directionDetailsInfo =
  //       await AssistantMethod.obtainOriginToDestinationDirectionDetails(
  //           sourceLatLng, destinationLanLng);
  //   log('got both lat lng3');

  //   Navigator.pop(context);

  //   PolylinePoints pPoints = PolylinePoints();

  //   List<PointLatLng> decodePointResultList =
  //       pPoints.decodePolyline(directionDetailsInfo.ePoint);

  //   pLineCoOrdinateList.clear();

  //   if (decodePointResultList.isNotEmpty) {
  //     for (var pointLatLng in decodePointResultList) {
  //       pLineCoOrdinateList
  //           .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
  //     }
  //   }

  //   polylineSet.clear();

  //   setState(() {
  //     Polyline polyline = Polyline(
  //         polylineId: const PolylineId('PolylineId'),
  //         color: primaryColor,
  //         jointType: JointType.round,
  //         points: pLineCoOrdinateList,
  //         startCap: Cap.roundCap,
  //         endCap: Cap.roundCap,
  //         geodesic: true);
  //     polylineSet.add(polyline);
  //   });

  //   LatLngBounds boundsLatLng;
  //   if (sourceLatLng.latitude > destinationLanLng.latitude &&
  //       sourceLatLng.longitude > destinationLanLng.longitude) {
  //     boundsLatLng =
  //         LatLngBounds(southwest: destinationLanLng, northeast: sourceLatLng);
  //   } else if (sourceLatLng.longitude > destinationLanLng.longitude) {
  //     boundsLatLng = LatLngBounds(
  //         southwest: LatLng(sourceLatLng.latitude, destinationLanLng.longitude),
  //         northeast:
  //             LatLng(destinationLanLng.latitude, sourceLatLng.longitude));
  //   } else if (sourceLatLng.latitude > destinationLanLng.latitude) {
  //     boundsLatLng = LatLngBounds(
  //         southwest: LatLng(destinationLanLng.latitude, sourceLatLng.longitude),
  //         northeast:
  //             LatLng(destinationLanLng.latitude, sourceLatLng.longitude));
  //   } else {
  //     boundsLatLng =
  //         LatLngBounds(southwest: sourceLatLng, northeast: destinationLanLng);
  //   }
  //   newGoogleMapController!
  //       .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 100));

  //   Marker originMarker = Marker(
  //     markerId: const MarkerId('originId'),
  //     infoWindow: const InfoWindow(title: "Driver Location", snippet: 'origin'),
  //     position: sourceLatLng,
  //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //   );

  //   Marker destinationMarker = Marker(
  //     markerId: const MarkerId('destinationId'),
  //     infoWindow: InfoWindow(
  //         title: destinationPosition.locationName, snippet: 'destination'),
  //     position: destinationLanLng,
  //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
  //   );

  //   setState(() {
  //     markerSet.add(originMarker);

  //     markerSet.add(destinationMarker);
  //   });

  //   Circle originCircle = Circle(
  //       circleId: const CircleId('originId'),
  //       fillColor: primaryColor,
  //       radius: 12,
  //       strokeWidth: 3,
  //       strokeColor: ColorMedia.white,
  //       center: sourceLatLng);

  //   Circle destinationCircle = Circle(
  //       circleId: const CircleId('destinationId'),
  //       fillColor: ColorMedia.green50,
  //       radius: 12,
  //       strokeWidth: 3,
  //       strokeColor: Colors.white,
  //       center: destinationLanLng);

  //   setState(() {
  //     circleSet.add(originCircle);
  //     circleSet.add(destinationCircle);
  //   });
  // }

  GoogleMapController? newGoogleMapController;

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition();
    Position currentPosition = cPosition;
    LatLng latLngPosition =
        LatLng(currentPosition.latitude, currentPosition.longitude);
    if (mounted) {
      setState(() {
        userLocation =
            LatLng(currentPosition.latitude, currentPosition.longitude);
      });
    }

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  PolylinePoints polylinePoints = PolylinePoints();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SlidingUpPanel(
          controller: panelControllerNew,
          minHeight: MediaQuery.of(context).size.height / 3.9,
          maxHeight: MediaQuery.of(context).size.height / 1.8,
          body: Stack(
            children: [
              GoogleMap(
                // mapType: MapType.normal,
                myLocationEnabled: true,
                markers: markers,
                circles: circleSetNew,
                zoomControlsEnabled: true,
                polylines:
                    Set<Polyline>.of(polyline != null ? [polyline!] : []),
                // zoomGesturesEnabled: true,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) async {
                  String style = await DefaultAssetBundle.of(context)
                      .loadString('images/theme.json');

                  _controller.complete(controller);
                  controller.setMapStyle(style);
                  newGoogleMapController = controller;
                  await locateUserPosition();
                  await updateLocation(widget.driverEmail, widget.rideId);
                  // if (driverLoc != null) {
                  // await drawPolylineFromSourceToDestination();
                },
              ),
            ],
          ),
          panelBuilder: (controller) {
            return Goev(
              driverName: widget.driverName,
              carNumber: widget.carNumber,
              profileUrl: widget.profileUrl,
              userId: widget.userId,
              token: widget.token,
              rideId: widget.rideId,
              modelName: widget.modelName,
              otp: widget.otp,
              locationA: widget.locationA,
              locationB: widget.locationB,
              driverNumber: widget.driverNumber,
            );
          },
          parallaxEnabled: true,
          parallaxOffset: 0.5,
        ),
      ),
    );
  }
}
