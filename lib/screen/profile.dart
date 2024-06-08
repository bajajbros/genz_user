import 'dart:convert';
import 'dart:developer';
// import 'dart:math';
import 'package:customer/api/api_value.dart';
import 'package:customer/components/color.dart';
import 'package:customer/helper/snackBar.dart';
import 'package:customer/screen/home/home_page.dart';
import 'package:customer/widget/nm_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';

// import 'package:neumorphic/neumorphic.dart';

class EditProfile extends StatefulWidget {
  final String userId;
  final String? firstName;
  final String? email;
  final String token;
  final String? phoneNumber;
  const EditProfile(
      {super.key,
      required this.phoneNumber,
      required this.token,
      required this.email,
      required this.firstName,
      required this.userId});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    super.initState();
    number.text = widget.email ?? "";

    name.text = widget.phoneNumber ?? "";
    city.text = widget.firstName ?? "";
  }

  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  // TextEditingController flat = TextEditingController();
  // TextEditingController street = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController landmark = TextEditingController();
  // TextEditingController state = TextEditingController();
  // TextEditingController pincode = TextEditingController();

  // Future addAddress() async {
  //   Uri url = Uri.parse(
  //       'http://www.hukmee.in/APIs/APIs.asmx/AddAddress?token=7785522ooij6639polivgtKlah&Addresstype=&AddressLine1=${flat.text}&AddressLine2=${street.text}&City=${city.text}&State=${state.text}&Country=India&phone=${number.text}');

  //   Response response = await get(url);
  //   if (response.statusCode == 200) {
  //   } else {}
  // }
  Future updateProfile() async {
    final Map<String, dynamic> updatedData = {
      'name': city.text + landmark.text,
      'email': number.text,
      'phone': name.text,
    };

// Convert the map to a JSON string
    final String jsonData = json.encode(updatedData);

// Set the headers for the request
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
      // Add any other headers required by the API here
    };
    final http.Response response = await http.put(
      Uri.parse('$baseUrl/api/user/updateProfile'),
      headers: headers,
      body: jsonData,
    );
    log(jsonData);

// Check the response status code
    if (response.statusCode == 200) {
      log(response.body);

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return HomePage(token: widget.token, userId: widget.userId);
      }), (route) => false);
    } else {
      // An error occurred. Handle the error here
      snackWidget(context, jsonDecode(response.body)['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            // size: 15,
          ),
        ),
        title: Text(
          'Edit Your Profile',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  //  width: MediaQuery.of(context).size.width / 2.3,
                  //       height: MediaQuery.of(context).size.height / 22,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Full name'.toUpperCase(),
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.characters,
                        controller: city,
                        style: GoogleFonts.roboto(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(1),
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                // height: MediaQuery.of(context).size.height * 0.827,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                      ),
                      Text(
                        'Phone number'.toUpperCase(),
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 22,
                        width: double.infinity,
                        child: TextFormField(
                          // readOnly: true,
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.characters,
                          controller: name,
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                      ),
                      Text(
                        'Email address'.toUpperCase(),
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 22,
                        width: double.infinity,
                        child: TextFormField(
                          // textCapitalization: TextCapitalization.characters,
                          controller: number,
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                      ),
                      Text(
                        'Country'.toUpperCase(),
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 22,
                        width: double.infinity,
                        child: TextFormField(
                          readOnly: true,
                          initialValue: 'India',
                          textCapitalization: TextCapitalization.characters,
                          // controller: flat,
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
              ),
              NMButton(
                text: 'Update Profile',
                onPressed: () async {
                  if (name.text.length == 10) {
                    await updateProfile();
                  } else {
                    return snackWidget(context, 'Please enter phone number');
                  }
                },
              )
              // InkWell(
              //   onTap: () async {
              //     await updateProfile();
              //   },
              //   child: Container(
              //     height: MediaQuery.of(context).size.height / 10,
              //     width: MediaQuery.of(context).size.width * 1,
              //     decoration: const BoxDecoration(color: primaryColor),
              //     child: Center(
              //       child: Text(
              //         'Update Profile'.toUpperCase(),
              //         style: GoogleFonts.roboto(
              //           fontSize: 15,
              //           fontWeight: FontWeight.w600,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlassButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const GlassButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                offset: const Offset(0, 8),
                blurRadius: 16,
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red.withOpacity(0.4),
                Colors.red.withOpacity(0.3),
                Colors.white.withOpacity(0.4),
                Colors.white.withOpacity(0.3),
              ],
              stops: const [0.1, 0.3, 0.7, 0.9],
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onPressed(),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
