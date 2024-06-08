// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:customer/backend/model_class.dart';
import 'package:customer/components/sized.dart';
import 'package:customer/screen/auth/login_page.dart';
import 'package:customer/screen/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api_value.dart';
import '../../components/color.dart';
import '../../components/text_style.dart';
import '../../helper/snackBar.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String mobileNumber;
  const OTPScreen({
    Key? key,
    required this.mobileNumber,
    required this.verificationId,
  }) : super(key: key);
  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  bool loader = false;

  TextEditingController controller = TextEditingController();

  apiCall(String token) async {
    setState(() {
      loader = true;
    });
    log('api called login');
    log(token);
    //Navigator.push(context, MaterialPageRoute(builder: (context)=> OTPScreen(mobileNumber: mobile.text,)));
    if (controller.text.length == 6) {
      log('method enters');
      Map<String, dynamic> parameter = {
        "firebaseIdToken": token,
        "signinMethod": "phone",
        "phone": widget.mobileNumber.toString(),
        "email": ""
      };
      try {
        final response = await post(Uri.parse('$baseUrl/api/user/login/'),
            headers: {"Content-Type": "application/json"},
            body: json.encode(parameter));
        if (response.statusCode == 200) {
          setState(() {
            loader = false;
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("isLoggedIn", true);
          prefs.setString('phoneNumber', widget.mobileNumber);

          LoginResponse user =
              LoginResponse.fromJson(json.decode(response.body));
          prefs.setString('token', user.token);
          prefs.setString('userId', user.data.user.id);
          snackWidget(context, 'Successful Verify');

          return LoginResponse.fromJson(json.decode(response.body));
        } else {
          print(response.body);
          snackWidget(context, 'Please check mobile connection');
        }
      } catch (e) {
        setState(() {
          loader = false;
        });
        print(e.toString());
      }
    } else {
      snackWidget(context, 'Please enter vaild OTP');
    }
  }

  final String _verificationId = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<LoginResponse> _signInWithOTP() async {
    String otp = controller.text;
    log(otp);
    String verificationId = widget.verificationId;
    log(verificationId);
    // log(_verificationId);
    log('verification sent');
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    try {
      await _auth.signInWithCredential(credential);
      final currentUser = FirebaseAuth.instance.currentUser;
      var token = await currentUser!.getIdToken();
      log(token);
      log('token sent');
      LoginResponse data = await apiCall(token);
      log('Successfully signed in with OTP.');
      return data;
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      if (e.code == 'invalid-verification-code') {
        throw ('The verification code entered is not valid.');
      }
      rethrow;
    }
  }

  Future<void> initSmsListener() async {
    String? commingSms;
    try {
      // commingSms = (await AltSmsAutofill().listenForSms)!;
    } on PlatformException {
      log('Failed to get Sms.');
    }
    if (!mounted) return;

    setState(() {
      log(commingSms!);
      log('autofill sent');
      controller.text = commingSms.substring(0, 6);
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    // AltSmsAutofill().unregisterListener();
    super.dispose();
  }

  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    initSmsListener();
    // OTPInteractor()
    //     .getAppSignature()
    //     .then((value) => print('signature - $value'));
    // OTPTextEditController(
    //   codeLength: 6,
    //   // onCodeReceive: (code) => setState(() {}),
    // ).startListenUserConsent(
    //   (code) {
    //     controller.text = code!;
    //     return code;
    //   },
    // );
    // _verificationId = widget.verificationId;
    _startTimer();
    super.initState();
  }

  bool pop = false;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining == 0) {
          _timer!.cancel();
          setState(() {
            pop = true;
          });
        } else {
          _secondsRemaining--;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            // backgroundImage(imageURl: 'images/background3.png'),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizedMedia.widthDivide(context, 7.2),
                      vertical: SizedMedia.heightDivide(context, 27),
                    ),
                    child: Text(
                      'Enter the 6-digit code sent to you at +91${widget.mobileNumber}',
                      style: TStyleMedia.whiteRoboto20Medium2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Directionality(
                      textDirection: TextDirection.ltr,
                      child: Pinput(
                        length: 6,
                        controller: controller,
                        defaultPinTheme: PinTheme(
                          width: 45,
                          height: 45,
                          textStyle: const TextStyle(
                              fontSize: 20,
                              color: backgroundColor,
                              fontWeight: FontWeight.w600),
                          decoration: BoxDecoration(
                            color: ColorMedia.white,
                            border: Border.all(
                                color: ColorMedia.greyLight, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )),
                  pop
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return const LoginScreen(
                                snack: true,
                              );
                            }), ((route) => false));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: SizedMedia.heightDivide(context, 9),
                            ),
                            decoration: BoxDecoration(
                              color: ColorMedia.greyLight,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                  width: 1, color: ColorMedia.greyLight),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: SizedMedia.widthDivide(context, 18),
                              vertical: SizedMedia.heightDivide(context, 80),
                            ),
                            child: Text(
                              'Edit Mobile number or resend code?',
                              style: TStyleMedia.red20Roboto16Medium0,
                            ),
                          ),
                        )
                      : GestureDetector(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: SizedMedia.heightDivide(context, 9),
                            ),
                            decoration: BoxDecoration(
                              color: ColorMedia.greyLight,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                  width: 1, color: ColorMedia.greyLight),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: SizedMedia.widthDivide(context, 18),
                              vertical: SizedMedia.heightDivide(context, 80),
                            ),
                            child: Text(
                              'I didn’t receive a code (0:${_secondsRemaining.toString().padLeft(2, "0")})',
                              style: TStyleMedia.red20Roboto16Medium0,
                            ),
                          ),
                        ),
                ],
              ),
            ),

            Positioned(
                bottom: SizedMedia.heightDivide(context, 18),
                right: SizedMedia.widthDivide(context, 12),
                child: InkWell(
                  onTap: () async {
                    LoginResponse loginResponse = await _signInWithOTP();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckNextScreen(
                          userId: loginResponse.data.user.id,
                          token: loginResponse.token,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorMedia.white,
                        borderRadius: BorderRadius.circular(50)),
                    padding: EdgeInsets.symmetric(
                        horizontal: SizedMedia.heightDivide(context, 80),
                        vertical: SizedMedia.heightDivide(context, 80)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedMedia.sizeWidthDivide(context, 72),
                        Text(
                          'Next',
                          style: TStyleMedia.red20Roboto16Medium0,
                        ),
                        SizedMedia.sizeWidthDivide(context, 72),
                        const Iconify(
                          Ic.round_navigate_next,
                          color: primaryColor,
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
