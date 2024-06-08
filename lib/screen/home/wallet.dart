// import 'package:flutter/material.dart';

// class FreeRidesBottomSheet extends StatelessWidget {
//   final int freeRides;

//   const FreeRidesBottomSheet({required this.freeRides});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 300,
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.redAccent.withOpacity(0.1),
//             blurRadius: 16,
//             offset: const Offset(0, -8),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           const SizedBox(height: 16),
//           Container(
//             height: 8,
//             width: 64,
//             decoration: BoxDecoration(
//               color: Colors.grey[800],
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'Free Rides',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.redAccent,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             '$freeRides Free Rides',
//             style: const TextStyle(
//               fontSize: 48,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const Spacer(),
//           Container(
//             width: double.infinity,
//             height: 64,
//             margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               color: Colors.redAccent,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.redAccent.withOpacity(0.3),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: const Center(
//               child: Text(
//                 'View Details',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
