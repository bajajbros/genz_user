// import 'dart:async';

// import 'package:customer/components/sized.dart';
// import 'package:customer/helper/background.dart';
// import 'package:flutter/material.dart';

// import 'onboarding_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {

//   //This is for animation
//   Animation? carAnimation;

//   //This is animation controller
//   AnimationController? carController;

//   @override
//   void initState() {
//     super.initState();

//     carController =
//         AnimationController(vsync: this, duration: const Duration(seconds: 4));

//     carAnimation = Tween(begin: 0.0, end: 280.0).animate(
//       CurvedAnimation(parent: carController!, curve: Curves.linear),
//     );

//     carController!.forward();
//     startTimer();

//   }

//   startTimer() {
//     Timer(const Duration(seconds: 4), () async {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const OnBoardingScreen(),
//         ),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose

//     carController!.dispose();
//     super.dispose();
//   }

// ignore_for_file: use_build_context_synchronously

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: InkWell(
//         onTap: () {},
//         child: Stack(
//           children: [
//             // backgroundImage(imageURl: 'images/splash_screen.png'),
//             AnimatedBuilder(
//               animation: carAnimation!,
//               builder: (context, child) {
//                 return Container(
//                   padding: EdgeInsets.only(
//                       left: carAnimation!.value,
//                       top: (MediaQuery.of(context).size.height * 0.69 -
//                           (carAnimation!.value / 4.4))),
//                   child: child,
//                 );
//               },
//               child: Image.asset(
//                 'images/car.png',
//                 width: SizedMedia.widthDivide(context, 3.6),
//                 height: SizedMedia.heightDivide(context, 10.66),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:developer';

import 'package:customer/screen/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

import 'package:customer/screen/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late VideoPlayerController _controller;
  bool _visible = false;

  @override
  void initState() {
    super.initState();

 

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _controller = VideoPlayerController.asset("images/splash_video.mp4");
    _controller.initialize().then((_) {
      // _controller.setLooping(true);
      Timer(const Duration(milliseconds: 100), () {
        setState(() {
          _controller.play();
          _visible = true;
        });
      });
    });

    Future.delayed(const Duration(seconds: 4), () async {
      log('trying to navigate');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // var status = prefs.getBool('isLoggedIn') ?? false;
      // log('trying to navigate1');

      // log('trying to navigate2');

      var userId = prefs.getString("userId");
      // log('trying to navigate3');

      var token = prefs.getString("token");
      // log('trying to navigate4');
//        preferences.setString('modelName', driver.distance.toString

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => token == null
                  ? const LoginScreen(
                      snack: false,
                    )
                  : CheckNextScreen(token: token, userId: userId!)),
          (e) => false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    // _controller = null;
  }

  Widget _getVideoBackground() {
    return VideoPlayer(_controller);
  }

  // _getBackgroundColor() {
  //   return Container(color: Colors.transparent //.withAlpha(120),
  //       );
  // }

  // _getContent() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     mainAxisAlignment: MainAxisAlignment.start,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: _getVideoBackground()),
      ),
    );
  }
}
