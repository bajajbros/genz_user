// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:customer/screen/home/offer_card.dart';
import 'package:customer/screen/order/confirm_ride.dart';
import 'package:customer/screen/search_page_screen.dart';
import 'package:glassmorphism/glassmorphism.dart';

import 'package:customer/api/api_value.dart';
import 'package:customer/backend/banner_model.dart';
import 'package:customer/backend/office_banner.dart';
import 'package:customer/components/color.dart';
import 'package:customer/module/direction_module.dart';
import 'package:customer/module/predicted_place.dart';
import 'package:customer/module_helper/app_info.dart';
import 'package:customer/screen/home/dashboard.dart';
import 'package:customer/widget/place_prediction_tile.dart';
import 'package:customer/widget/search_field.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../backend/assistant_method.dart';
import '../../backend/prev_search_model.dart';

// List<String> imageList = [
//   'https://cdn.pixabay.com/photo/2019/03/15/09/49/girl-4056684_960_720.jpg',
//   'https://cdn.pixabay.com/photo/2020/12/15/16/25/clock-5834193__340.jpg',
//   'https://cdn.pixabay.com/photo/2020/09/18/19/31/laptop-5582775_960_720.jpg',
//   'https://media.istockphoto.com/photos/woman-kayaking-in-fjord-in-norway-picture-id1059380230?b=1&k=6&m=1059380230&s=170667a&w=0&h=kA_A_XrhZJjw2bo5jIJ7089-VktFK0h0I4OWDqaac0c=',
//   'https://cdn.pixabay.com/photo/2019/11/05/00/53/cellular-4602489_960_720.jpg',
//   'https://cdn.pixabay.com/photo/2017/02/12/10/29/christmas-2059698_960_720.jpg',
//   'https://cdn.pixabay.com/photo/2020/01/29/17/09/snowboard-4803050_960_720.jpg',
//   'https://cdn.pixabay.com/photo/2020/02/06/20/01/university-library-4825366_960_720.jpg',
//   'https://cdn.pixabay.com/photo/2020/11/22/17/28/cat-5767334_960_720.jpg',
//   'https://cdn.pixabay.com/photo/2020/12/13/16/22/snow-5828736_960_720.jpg',
//   'https://cdn.pixabay.com/photo/2020/12/09/09/27/women-5816861_960_720.jpg',
// ];
List<String> imageList2 = [
  'https://images.unsplash.com/photo-1621993202323-f438eec934ff?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=764&q=80',
  'https://images.unsplash.com/photo-1566367576585-051277d52997?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
  'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1583&q=80',
  'https://images.unsplash.com/photo-1514316454349-750a7fd3da3a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
  'https://images.unsplash.com/photo-1462396881884-de2c07cb95ed?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80',
  'https://images.unsplash.com/photo-1602777924012-f8664ffeed27?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=764&q=80',
];

class CheckNextScreen extends StatefulWidget {
  final String userId;

  final String token;
  const CheckNextScreen({super.key, required this.token, required this.userId});

  @override
  State<CheckNextScreen> createState() => _CheckNextScreenState();
}

class _CheckNextScreenState extends State<CheckNextScreen> {
  Future<String> getCurrentRide() async {
    print('method enters');
    http.Response response =
        await http.get(Uri.parse('$baseUrl/api/user/ongoingRide'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    });
    log('req sent');
    log(response.body);
    if (response.statusCode == 200) {
      print('got current ride');
      print(response.body);
      log(response.body);
      String rideCheck = jsonDecode(response.body)['ride']['status'];
      if (rideCheck == 'no ride') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: ((context) {
            return HomePage(token: widget.token, userId: widget.userId);
          })),((route) => false),
        );
      }
      log(rideCheck);
      return response.body;
    } else {
      throw 'error getting current ride details';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getCurrentRide(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          log('got ride data');
          String rideStatus = jsonDecode(snapshot.data!)['ride']['status'];
          if (rideStatus == "completed") {
            return HomePage(token: widget.token, userId: widget.userId);
          } else {
            String profileUrl = jsonDecode(snapshot.data!)['ride']['driver']
                    ['profileUrl'] ??
                "";
            var finalFare = jsonDecode(snapshot.data!)['ride']['finalFare'];
            dynamic otp = jsonDecode(snapshot.data!)['ride']['otp'];
            String driverName =
                jsonDecode(snapshot.data!)['ride']['driver']['name'];
            String carNumber = jsonDecode(snapshot.data!)['ride']['driver']
                ['carDetails']['carNumber'];
            String locationA =
                jsonDecode(snapshot.data!)['ride']['fromLocation']['name'];
            String locationB =
                jsonDecode(snapshot.data!)['ride']['toLocation']['name'];
            String driverNumber =
                jsonDecode(snapshot.data!)['ride']['driver']['phone'];
            String driverEmail =
                jsonDecode(snapshot.data!)['ride']['driver']['email'];
            dynamic id = jsonDecode(snapshot.data!)['ride']['_id'];
            return ConfirmRide(
                driverName: driverName,
                carNumber: carNumber,
                profileUrl: profileUrl,
                modelName: finalFare.toStringAsFixed(2),
                otp: otp,
                locationA: locationA,
                locationB: locationB,
                driverNumber: driverNumber,
                rideId: id,
                token: widget.token,
                driverEmail: driverEmail,
                userId: widget.userId);
          }
        }
        return Scaffold(
          backgroundColor: backgroundColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        primaryColor), // set the progress color to red
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Loading...',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class HomePage extends StatefulWidget {
  final String token;
  // final String userName;
  // final String userPhone;
  final String userId;
  const HomePage({
    super.key,
    required this.token,
    required this.userId,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

TextEditingController nameController = TextEditingController();

class _HomePageState extends State<HomePage> {
  Future<PrevSearches> getprevSearches() async {
    String url = '$baseUrl/api/user/previousSearches';
    Map<String, String> headers = {'Authorization': 'Bearer ${widget.token}'};

    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        log(response.body);
        final prevSearches = prevSearchesFromMap(response.body);
        return prevSearches;
      } else {
        // return Container();
        throw 'Error calling API';
      }
    } catch (err) {
      log(err.toString());
      rethrow;
    }
    // return PrevSearches(previous: []);
    // return null;
  }

  late Future<PrevSearches> futurePrevSearches;

  Future<BannerImages> getImages() async {
    String url = '$baseUrl/api/user/images';
    Map<String, String> headers = {'Authorization': 'Bearer ${widget.token}'};

    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final bannerImages = bannerImagesFromMap(response.body);
        // log(response.body);
        return bannerImages;
      } else {
        throw 'cannot get banner images';
      }
      // return BannerImages(images: []);
    } catch (err) {
      rethrow;
    }
    // return BannerImages(images: []);
  }

  Future<OfficeBanner> getOfficeBannerStatus() async {
    String url = '$baseUrl/api/user/officeStatus';
    Map<String, String> headers = {'Authorization': 'Bearer ${widget.token}'};

    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        log('sending office status');
        log(response.body);
        // log(response.body);
        return officeBannerFromMap(response.body);
      } else {
        log(response.body);
        throw 'cannot get office banner';
      }
      // return BannerImages(images: []);
    } catch (err) {
      rethrow;
    }
    // return BannerImages(images: []);
  }

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
    Position position = await Geolocator.getCurrentPosition();
    // currentPosition = cPosition;
    // LatLng latLngPosition =
    //     LatLng(currentPosition!.latitude, currentPosition!.longitude);

    // CameraPosition cameraPosition =
    //     CameraPosition(target: latLngPosition, zoom: 14);

    // newGoogleMapController!
    //     .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    if (mounted) {
      String pickUpAddress =
          await AssistantMethod.searchAddressForGeographicCoOrdinates(
              position, context);
      Provider.of<AppInfo>(context, listen: false).updatePickUpLocation(
          Direction(
              locationName: pickUpAddress,
              locationLatitude: position.latitude,
              locationLongitude: position.longitude));
    }

    return position;
  }

  @override
  void initState() {
    navigate = false;
    checkIfPermissionAllowed();
    futurePrevSearches = getprevSearches();
    super.initState();
  }


  final List<String> _offers = [
    'Offer 1',
    'Offer 2',
    'Offer 3',
  ];

  // Geolocator geolocator  = Geolocator();
  // var position;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Padding(
            padding: EdgeInsets.only(left: 20),
            child: CustomText(
              text: 'GENZ',
              color: Colors.white,
              weight: FontWeight.w900,
              size: 24,
            ),
          )),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  // Position position = await Geolocator.getCurrentPosition();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return DashboardScreen(
                          userId: widget.userId,
                          // position: position,
                          token: widget.token,
                          office: false,
                        );
                      },
                    ),
                  );
                },
                child: SearchField(userId: widget.userId, token: widget.token),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder<PrevSearches>(
                  future: futurePrevSearches,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      log(snapshot.data!.previous.length.toString());
                      log('got data');
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.previous.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              // Position position =
                              //     await Geolocator.getCurrentPosition();

                              Provider.of<AppInfo>(context, listen: false)
                                  .updateDropOffLocation(Direction(
                                humanReadableAddress: snapshot
                                    .data!.previous[index].toLocation.name,
                                locationName: snapshot
                                    .data!.previous[index].toLocation.name,
                                locationLatitude: snapshot.data!.previous[index]
                                    .toLocation.coordinates[0],
                                locationLongitude: snapshot.data!
                                    .previous[index].toLocation.coordinates[1],
                              ));
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DashboardScreen(
                                  userId: widget.userId,
                                  // position: position,
                                  token: widget.token,
                                  office: false,
                                );
                              }));
                            },
                            child: PlacePredictionTileDesign(
                              disableTap: true,
                              predictedPlace: PredictedPlace(
                                  placeId: snapshot.data!.previous[index].id,
                                  mainText: snapshot
                                      .data!.previous[index].toLocation.name,
                                  secondaryText: 'click to Ride'),
                            ),
                          );
                        },
                      );
                    }
                    log('no data');
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            primaryColor), // set the progress color to red
                      ),
                    );
                  }),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: CarouselSlider(
                  options: CarouselOptions(
                      autoPlay: true, height: 400.0, enlargeCenterPage: true),
                  items: [0, 1, 2, 3, 4, 5, 6].map(
                    (i) {
                      // print(i);
                      return Builder(
                        builder: (BuildContext context) {
                          return FutureBuilder(
                            future: getImages(),
                            builder: ((context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          snapshot.data!.images[i].link),
                                      fit: BoxFit.fill,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        primaryColor), // set the progress color to red
                                  ),
                                );
                              }
                            }),
                          );
                        },
                      );
                    },
                  ).toList(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder<OfficeBanner>(
                  future: getOfficeBannerStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.data.status
                          ? GestureDetector(
                              onTap: () async {
                              
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return DashboardScreen(
                                          userId: widget.userId,
                                          token: widget.token,
                                          office: true,
                                       );
                                    },
                                  ),
                                );
                              },
                              child: DiscountBanner(
                                url: snapshot.data!.data.link,
                              ),
                            )
                          : Container();
                      // return const DiscountBanner();
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            primaryColor), // set the progress color to red
                      ),
                    );
                  }),
              SizedBox(
                height: 200,
                width: 1500,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _offers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return MyBottomSheet();
                            },
                          );
                        },
                        child: GlassmorphicContainer(
                          height: 200,
                          width: 150,
                          borderRadius: 16.0,
                          blur: 10,
                          alignment: Alignment.center,
                          border: 2.0,
                          linearGradient: LinearGradient(
                            colors: [
                              Colors.grey[900]!.withOpacity(0.2),
                              Colors.white.withOpacity(0.01),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderGradient: LinearGradient(
                            colors: [
                              Colors.grey[600]!.withOpacity(0.5),
                              Colors.white.withOpacity(0.2),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.local_offer,
                                size: 50,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _offers[index],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String? Function(String?)? validator;
  final Widget? prefix;
  final TextEditingController? controller;
  final String? hintText;
  final String? label;
  final TextInputType? textInputType;
  final bool? obsureText;
  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.label,
    this.textInputType,
    this.obsureText,
    this.prefix,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          color: Colors.white,
          text: label,
          size: 18,
          weight: FontWeight.w500,
        ),
        const SizedBox(
          height: 6,
        ),
        TextFormField(
          validator: validator,
          textAlignVertical: TextAlignVertical.center,
          obscureText: obsureText ?? false,
          keyboardType: textInputType ?? TextInputType.text,
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(24),
            prefixIcon: prefix,
            hintText: hintText,
            hintStyle: GoogleFonts.montserrat(
              textStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.blueGrey[200],
                  fontWeight: FontWeight.w400),
            ),
            enabledBorder: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: BorderSide(color: Colors.grey[900]!, width: 0),
            ),
            focusedBorder: const OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: BorderSide(color: primaryColor, width: 0),
            ),
            border: const OutlineInputBorder(),
            // border:
            // OutlineInputBorder(

            //   borderSide: BorderSide(color: Colors.grey[100]!)
            // )
          ),
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}

class CustomText extends StatelessWidget {
  final String? text;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final TextAlign? align;

  const CustomText(
      {Key? key, this.text, this.size, this.color, this.weight, this.align})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: align ?? TextAlign.start,
      style: GoogleFonts.manrope(
        textStyle: TextStyle(
            fontSize: size ?? 14,
            color: color ?? Colors.white,
            fontWeight: weight ?? FontWeight.w600),
      ),
    );
  }
}

class DiscountBanner extends StatelessWidget {
  final String url;
  const DiscountBanner({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      margin: const EdgeInsets.all((20)),
      padding: const EdgeInsets.symmetric(
        horizontal: (20),
        vertical: (15),
      ),
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
        color: primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
