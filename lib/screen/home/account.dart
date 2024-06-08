import 'dart:developer';

import 'package:customer/api/api_value.dart';
import 'package:customer/backend/forms.dart';
import 'package:customer/backend/profile_model.dart';
import 'package:customer/components/color.dart';
import 'package:customer/screen/home/activity_screen.dart';
import 'package:customer/screen/home/forms.dart';
import 'package:customer/screen/home/home_page.dart';
import 'package:customer/screen/profile.dart';
import 'package:customer/widget/nm_button.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ep.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/vaadin.dart';
import 'package:http/http.dart' as http;

import '../../components/text_style.dart';
import '../../widget/dialoge.dart';

class AccountScreen extends StatefulWidget {
  final String userId;
  final String token;
  // final String userMobile;
  const AccountScreen({Key? key, required this.token, required this.userId})
      : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Future<Forms> getForms() async {
    String url = '$baseUrl/api/user/forms';
    Map<String, String> headers = {'Authorization': 'Bearer ${widget.token}'};

    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        log(response.body);
        return formsFromMap(response.body);
      } else {
        log(response.body);
        throw 'Error calling API';
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<Profile> getProfile() async {
    log('method called');
    String url = '$baseUrl/api/user/profile';
    Map<String, String> headers = {'Authorization': 'Bearer ${widget.token}'};

    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        log(response.body);
        Profile profile = profileFromMap(response.body);
        log('profile done');
        log(profile.profile.toString());
        log('profile sent');
        return profile;
      } else {
        throw 'Error calling API';
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    getProfile();
    getForms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: FutureBuilder<Forms>(
          future: getForms(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                  future: getProfile(),
                  builder: ((context, snShot) {
                    if (snShot.hasData) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return EditProfile(
                                      userId: widget.userId,
                                      email: snShot.data!.profile.email,
                                      firstName: snShot.data!.profile.name,
                                      phoneNumber: snShot.data!.profile.phone,
                                      token: widget.token,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  snShot.data!.profile.phone == ""
                                      ? snShot.data!.profile.email
                                          .substring(0, 20)
                                      : snShot.data!.profile.phone,
                                  style: TStyleMedia.whiteRoboto25SemiBold5,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  backgroundColor: ColorMedia.white,
                                  radius: 40,
                                  child: const Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 40,
                                      color: primaryColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return TermsAndConditionsScreen(
                                            name: 'About us',
                                            htmlData: snapshot.data!.forms[1]
                                                .toString(),
                                          );
                                        }),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: primaryColor, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            ColorMedia.white.withOpacity(0.10),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height /
                                              8,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Iconify(
                                            Ep.help_filled,
                                            color: primaryColor,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'About Us',
                                            style: TStyleMedia
                                                .whiteRoboto17Medium5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(24)),
                                          context: context,
                                          builder: (context) {
                                            return snShot.data!.profile
                                                        .freeRides.rides ==
                                                    0
                                                ? Container(
                                                    height: 200,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.8),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      20)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.3),
                                                          blurRadius: 20,
                                                          offset: const Offset(
                                                              0, -10),
                                                        ),
                                                      ],
                                                    ),
                                                    child: const Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .directions_car,
                                                            color: Colors.red,
                                                            size: 50,
                                                          ),
                                                          SizedBox(height: 20),
                                                          Text(
                                                            "No Free Ride in your Account",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.6,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.8),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(
                                                                20.0),
                                                        topRight:
                                                            Radius.circular(
                                                                20.0),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 20,
                                                          spreadRadius: 10,
                                                          color: Colors.black
                                                              .withOpacity(0.3),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              24),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                              height: 16),
                                                          Align(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            child: Container(
                                                              width: 60,
                                                              height: 5,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 24),
                                                          const Text(
                                                            'Wallet',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 24),
                                                          const CustomText(
                                                            text:
                                                                'Your remaining free rides!!',
                                                            color: Colors.white,
                                                            size: 24,
                                                          ),
                                                          CustomText(
                                                            text:
                                                                'Number of rides:${snShot.data!.profile.freeRides.rides}',
                                                            color: Colors.white,
                                                            size: 24,
                                                          ),
                                                          CustomText(
                                                            text:
                                                                'Expiry Date:${snShot.data!.profile.freeRides.expire.toString().substring(0, 10)}',
                                                            color: Colors.white,
                                                            size: 24,
                                                          ),
                                                          CustomText(
                                                            text:
                                                                'KM:${snShot.data!.profile.freeRides.km}',
                                                            color: Colors.white,
                                                            size: 24,
                                                          ),
                                                          const SizedBox(
                                                              height: 24),
                                                          Align(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            child: NMButton(
                                                                text:
                                                                    'Get offer',
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                }),
                                                          ),
                                                          const SizedBox(
                                                              height: 24),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                          });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: primaryColor, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            ColorMedia.white.withOpacity(0.10),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height /
                                              8,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Iconify(
                                            Vaadin.wallet,
                                            color: primaryColor,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Wallet',
                                            style: TStyleMedia
                                                .whiteRoboto17Medium5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ActivityScreen(
                                          token: widget.token,
                                        );
                                      }));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: primaryColor, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            ColorMedia.white.withOpacity(0.10),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height /
                                              8,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Iconify(
                                            Mdi.clock_time_three,
                                            color: primaryColor,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Trips',
                                            style: TStyleMedia
                                                .whiteRoboto17Medium5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Container(
                          //   height: 120,
                          //   width: double.infinity,
                          //   margin: const EdgeInsets.symmetric(
                          //       horizontal: 20, vertical: 30),
                          //   decoration: BoxDecoration(
                          //     border: Border.all(color: primaryColor),
                          //     color: ColorMedia.white.withOpacity(0.10),
                          //     borderRadius: BorderRadius.circular(20),
                          //   ),
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: 30, vertical: 20),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //     children: [
                          //       Text(
                          //         'Safety check-up',
                          //         style: TStyleMedia.whiteRoboto17Medium5,
                          //       ),
                          //       Text(
                          //         'Boost your safety profile by turning on additional features.',
                          //         style: TStyleMedia.white50Roboto16Regular2,
                          //       )
                          //     ],
                          //   ),
                          // )
                          const SizedBox(
                            height: 120,
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return TermsAndConditionsScreen(
                                  name:
                                      '${snapshot.data!.forms[0].type.toUpperCase()} AND CONDITIONS',
                                  htmlData: snapshot.data!.forms[0].description,
                                );
                              }));
                            },
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 30),
                            leading: const Icon(
                              Icons.mail,
                              color: primaryColor,
                            ),
                            title: Text(
                              'Terms and conditions',
                              style: TStyleMedia.whiteRoboto17Medium5,
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return TermsAndConditionsScreen(
                                  name: snapshot.data!.forms[1].type
                                      .toUpperCase(),
                                  htmlData: snapshot.data!.forms[1].description,
                                );
                              }));
                            },
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 30),
                            leading: const Icon(
                              Icons.security,
                              color: primaryColor,
                            ),
                            title: Text(
                              'Privacy & Security',
                              style: TStyleMedia.whiteRoboto17Medium5,
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return TermsAndConditionsScreen(
                                  name: snapshot.data!.forms[2].type
                                      .toUpperCase(),
                                  htmlData: snapshot.data!.forms[2].description,
                                );
                              }));
                            },
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 30),
                            leading: const Icon(
                              Icons.info_rounded,
                              color: primaryColor,
                            ),
                            title: Text(
                              'Legal',
                              style: TStyleMedia.whiteRoboto17Medium5,
                            ),
                          ),
                          ListTile(
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const LogoutDialog();
                                },
                              );
                            },
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 30),
                            leading: const Icon(
                              Icons.logout,
                              color: primaryColor,
                            ),
                            title: Text(
                              'Log Out',
                              style: TStyleMedia.whiteRoboto17Medium5,
                            ),
                          ),
                        ],
                      );
                    }
                    return Container();
                  }));
            } else {
              return Container();
            }
          },
        ));
  }
}
