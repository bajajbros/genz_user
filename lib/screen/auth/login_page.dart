import 'dart:convert';
import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
// import 'package:colorful_iconify_flutter/icons/logos.dart';
// import 'package:colorful_iconify_flutter/icons/flat_color_icons.dart';
import 'package:customer/api/api_value.dart';
import 'package:customer/components/color.dart';
import 'package:customer/components/sized.dart';
import 'package:customer/helper/snackBar.dart';
import 'package:customer/screen/auth/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fa6_brands.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../backend/forms.dart';
import '../../backend/model_class.dart';
import '../../components/text_style.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../home/forms.dart';
import '../home/home_page.dart';

class LoginScreen extends StatefulWidget {
  final bool snack;
  const LoginScreen({Key? key, required this.snack}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookAuth facebookAuth = FacebookAuth.instance;

  Future<LoginResponse> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    log(googleAuth.toString());
    log('auth sent');
    log(googleAuth.accessToken!.toString());

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    var creds = await _auth.signInWithCredential(credential);
    log('done');
    fb.User user = _auth.currentUser!;
    if (user != null) {
      var email = _auth.currentUser!.email;
      String token = await _auth.currentUser!.getIdToken();
      log(email!);

      return loginWithGoogle(
        token,
        email,
      );
      // User is signed in.

      // return user;
    } else {
      setState(() {});

      throw ('user is null');
    }
    // return await _auth.signInWithCredential(credential);
  }

  Future<Forms> getForms() async {
    String url = '$baseUrl/api/user/forms';
    // Map<String, String> headers = {'Authorization': 'Bearer ${widget.token}'};

    try {
      http.Response response = await http.get(
        Uri.parse(url),
      );
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

  Future<LoginResponse> loginWithGoogle(
    String token,
    String email,
  ) async {
    setState(() {
      loader = true;
    });
    log('api called login');
    log(token);
    //Navigator.push(context, MaterialPageRoute(builder: (context)=> OTPScreen(mobileNumber: mobile.text,)));

    log('method enters');
    Map<String, dynamic> parameter = {
      "firebaseIdToken": token,
      "signinMethod": "google", // "google", "facebook", "apple"
      // "phone": "" ,//"phone"
      "email": email //rest
    };
    log(parameter.toString());
    try {
      final response = await post(Uri.parse('$baseUrl/api/user/login/'),
          headers: {"Content-Type": "application/json"},
          body: json.encode(parameter));
      log(parameter.toString());
      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          loader = false;
        });

        LoginResponse user = LoginResponse.fromJson(json.decode(response.body));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);
        prefs.setString('token', user.token);

        prefs.setString('token', user.token);
        prefs.setString('userId', user.data.user.id);
        snackWidget(context, 'Successful Verify');

        return LoginResponse.fromJson(json.decode(response.body));
      } else {
        print(response.body);
        snackWidget(context, 'Please check mobile connection');
        throw 'cannot login with google';
      }
    } catch (e) {
      setState(() {
        loader = false;
      });
      print(e.toString());
      rethrow;
    }
  }

  @override
  void initState() {
    getForms();
    super.initState();
    widget.snack
        ? WidgetsBinding.instance.addPostFrameCallback((_) async {
            snackWidget(
                context, 'Please recheck you mobile number and try again');
          })
        : null;
  }

  Future signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      log(result.status.toString());
      switch (result.status) {
        case LoginStatus.success:
          final AuthCredential facebookCredential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          final userCredential =
              await _auth.signInWithCredential(facebookCredential);
          log(userCredential.toString());
          return userCredential;
        case LoginStatus.cancelled:
          return log('cancelled');
        case LoginStatus.failed:
          return log('failed');
        default:
          return null;
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String selectCountry = 'India';
  bool checkBox = false;
  bool loader = false;
  TextEditingController mobile = TextEditingController();

  Future _sendOTP() async {
    String phoneNumber = '+91${mobile.text}';
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // var data =await apiCall(credential.token.toString());
        // return data;
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      timeout: const Duration(seconds: 120),
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              verificationId: verificationId,
              mobileNumber: mobile.text,
            ),
          ),((route) => false)
        );

        // Save the verification ID somewhere
        // The user is already authenticated with their phone number
        print('Code sent to $phoneNumber');
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  String _verificationId = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          // backgroundImage(imageURl: 'images/background3.png'),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedMedia.sizeHeightDivide(context, 32),
                //SizedBox(height: 25,),
                Text(
                  'Enter your mobile number',
                  style: TStyleMedia.whiteRoboto20Medium2,
                ),

                SizedMedia.sizeHeightDivide(context, 54),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      color: ColorMedia.greyLight,
                      width: SizedMedia.widthDivide(context, 1.1),
                      height: SizedMedia.heightDivide(context, 18),
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false, decimal: false),
                        controller: mobile,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorMedia.greyLight,
                          prefixIcon: SizedBox(
                            width: 20,
                            child: Center(
                              child: Text(
                                '+91',
                                style: TStyleMedia.blackRoboto16Medium0,
                              ),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0.5, color: ColorMedia.green50)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0.5, color: ColorMedia.greyLight)),
                          hintText: 'Enter mobile number',
                          hintStyle: TStyleMedia.blue20Roboto16Medium2,
                          contentPadding:
                              const EdgeInsets.only(top: 5, left: 10),
                          hintMaxLines: 1,
                        ),
                        onSaved: (value) {
                          setState(() {
                            mobile.text = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                SizedMedia.sizeHeightDivide(context, 32),

                loader
                    ? const CircularProgressIndicator(
                        color: primaryColor,
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: primaryColor,
                            padding: EdgeInsets.only(
                                left: SizedMedia.widthDivide(context, 2.65),
                                right: SizedMedia.widthDivide(context, 2.65),
                                top: SizedMedia.heightDivide(context, 80),
                                bottom: SizedMedia.heightDivide(context, 80))),
                        onPressed: () async {
                          setState(() {
                            loader = true;
                          });
                          if (selectCountry == 'India') {
                            if (checkBox == true) {
                              if (mobile.text.length == 10) {
                                await _sendOTP();

                                // var parameter = {
                                //   'mobile' : mobile.text.trim(),
                                //   'address' : '195, Anshu Kumar , Jharkhand'
                                // };
                                // try {
                                //   final response =
                                //       await post(customerLogin, body: parameter);
                                //
                                //   if(response.statusCode == 200){
                                //
                                //     print(response.body);
                                //     setState(() {
                                //       loader = false;
                                //     });
                                //     Navigator.push(context, MaterialPageRoute(builder: (context)=> OTPScreen(mobileNumber: mobile.text,)));
                                //   }else{
                                //     snackWidget(context, 'Please check mobile connection');
                                //   }
                                // } catch(e){
                                //   setState(() {
                                //     loader = false;
                                //   });
                                //   print(e.toString());
                                // }
                              } else {
                                setState(() {
                                  loader = false;
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content:
                                      Text('Please enter valid mobile no.'),
                                  backgroundColor: primaryColor,
                                ));
                              }
                            } else {
                              setState(() {
                                loader = false;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text('Please check Terms & Conditions'),
                                backgroundColor: primaryColor,
                              ));
                            }
                          } else {
                            setState(() {
                              loader = false;
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Please select Indian code'),
                              backgroundColor: primaryColor,
                            ));
                          }
                        },
                        child: Text(
                          'Continue',
                          style: TStyleMedia.whiteRoboto18Medium2,
                        ),
                      ),

                SizedMedia.sizeHeightDivide(context, 54),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 160,
                      child: Divider(
                        thickness: 1,
                        color: ColorMedia.black40,
                      ),
                    ),
                    Text(
                      'or',
                      style: TStyleMedia.black40Roboto18Medium2,
                    ),
                    SizedBox(
                      width: 160,
                      child: Divider(
                        thickness: 1,
                        color: ColorMedia.black40,
                      ),
                    ),
                  ],
                ),

                SizedMedia.sizeHeightDivide(context, 54),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: ColorMedia.greyLight,
                        padding: EdgeInsets.only(
                            left: SizedMedia.widthDivide(context, 5),
                            right: SizedMedia.widthDivide(context, 5),
                            top: SizedMedia.heightDivide(context, 80),
                            bottom: SizedMedia.heightDivide(context, 80))),
                    onPressed: () async {
                      LoginResponse loginResponse = checkBox
                          ? await signInWithGoogle()
                          : snackWidget(
                              context, 'Please accept Terms and conditions');
                      log('should navigate now');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckNextScreen(
                            userId: loginResponse.data.user.id,
                            token: loginResponse.token,
                          ),
                        ),
                      );
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'images/google.png',
                          height: 30,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Continue with Google',
                          style: TStyleMedia.blueRoboto18Medium2,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedMedia.sizeHeightDivide(context, 80),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: ColorMedia.greyLight,
                        padding: EdgeInsets.only(
                            left: SizedMedia.widthDivide(context, 6),
                            //right: SizedMedia.widthDivide(context,5),
                            top: SizedMedia.heightDivide(context, 80),
                            bottom: SizedMedia.heightDivide(context, 80))),
                    onPressed: () async{ checkBox
                          ? await                       signInWithFacebook()
                          : snackWidget(
                              context, 'Please accept Terms and conditions');
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                    },
                    child: Row(
                      children: [
                        Iconify(
                          Fa6Brands.facebook,
                          color: ColorMedia.blue,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Continue with Facebook',
                          style: TStyleMedia.blueRoboto18Medium2,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedMedia.sizeHeightDivide(context, 80),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: ColorMedia.greyLight,
                        padding: EdgeInsets.only(
                            left: SizedMedia.widthDivide(context, 6),
                            //right: SizedMedia.widthDivide(context,5),
                            top: SizedMedia.heightDivide(context, 80),
                            bottom: SizedMedia.heightDivide(context, 80))),
                    onPressed: () {
checkBox?null:snackWidget(
                              context, 'Please accept Terms and conditions');
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.apple,
                          color: backgroundColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Continue with Apple',
                          style: TStyleMedia.blueRoboto18Medium2,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedMedia.sizeHeightDivide(context, 16),
                Padding(
                  padding: const EdgeInsets.only(left: 13, right: 50),
                  child: Text(
                    'By proceeding, you consent to get calls, WhatsApp or SMS messages, including by automated means, from Uber and its affiliates to the number provided.',
                    style: TStyleMedia.grey40Roboto12Regular2,
                  ),
                )
              ],
            ),
          ),
          Positioned(
              bottom: SizedMedia.heightDivide(context, 25),
              left: SizedMedia.widthDivide(context, 60),
              child: Row(
                children: [
                  Checkbox(
                    activeColor: ColorMedia.green,
                    value: checkBox,
                    onChanged: (value) {
                      setState(() {
                        checkBox = value!;
                      });
                    },
                    side: const BorderSide(color: primaryColor, width: 2),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'I agree to,',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            fontSize: 12,
                            color: ColorMedia.white,
                            fontWeight: FontWeight.w400),
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.push(context,
                                    MaterialPageRoute(builder: ((context) {
                                  return FutureBuilder(
                                    future: getForms(),
                                    builder: ((context, snapshot) {
                                      if (snapshot.hasData) {
                                        return TermsAndConditionsScreen(
                                            name: snapshot.data!.forms[0].title,
                                            htmlData: snapshot
                                                .data!.forms[0].description);
                                      }
                                      return Container();
                                    }),
                                  );
                                }))),
                          text: ' Terms and Conditions ',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                                fontSize: 12,
                                color: primaryColor,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        TextSpan(
                          text: 'and',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                fontSize: 12,
                                color: ColorMedia.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        TextSpan(
                          text: ' Privacy Policy ',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                                fontSize: 12,
                                color: primaryColor,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ))
        ],
      )),
    );
  }
}

// splash
// flag in login page
// image in onboarding
// google image change
// otp back bug
// maxCharacter condition in field
// responsive of login page
// otp page
// bottom sheet chakachak on map page
// home page (search, slider, hot deals)
// car details bottom sheet manage

// rider home manage