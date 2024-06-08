// import 'package:customer/components/color.dart';
// import 'package:customer/components/sized.dart';
// import 'package:customer/components/text_style.dart';
// import 'package:customer/helper/background.dart';
// import 'package:customer/screen/auth/login_page.dart';
// import 'package:flutter/material.dart';
// import 'package:iconify_flutter/iconify_flutter.dart';

// import 'package:iconify_flutter/icons/ic.dart';

// class OnBoardingScreen extends StatelessWidget {
//   const OnBoardingScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor:backgroundColor,
//       body: Stack(children: [
//         // backgroundImage(imageURl: 'images/background1.png'),
//         Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'images/intro.png',
//                 width: SizedMedia.widthDivide(context, 1.44),
//                 height: SizedMedia.heightDivide(context, 5.63),
//               ),
//               SizedMedia.sizeHeightDivide(context, 40),
//               Text(
//                 'Book your Cab',
//                 style: TStyleMedia.whiteRoboto28Bold2,
//               )
//             ],
//           ),
//         ),
//         Positioned(
//           bottom: SizedMedia.heightDivide(context, 18),
//           left: SizedMedia.widthDivide(context, 18),
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//                 backgroundColor: primaryColor,
//                 padding: EdgeInsets.only(
//                     left: SizedMedia.widthDivide(context, 3.4),
//                     right: SizedMedia.widthDivide(context, 16.5),
//                     top: SizedMedia.heightDivide(context, 80),
//                     bottom: SizedMedia.heightDivide(context, 80))),
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const LoginScreen(),
//                 ),
//               );
//             },
//             child: Row(
//               children: [
//                 Text(
//                   'Get Started',
//                   style: TStyleMedia.whiteMohave20SemiBold0,
//                 ),
//                 //SizedBox(width: 75,),
//                 SizedMedia.sizeWidthDivide(context, 5),
//                 Iconify(
//                   Ic.outline_east,
//                   color: ColorMedia.white,
//                 )
//               ],
//             ),
//           ),
//         )
//       ]),
//     );
//   }
// }
