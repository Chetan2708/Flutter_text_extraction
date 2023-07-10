// import "package:flutter/material.dart";

// class UserPage extends StatelessWidget {
//   // the page where user's extracted info is presented
//   // after processing done by the api-> call this class and pass the arguments that we need !
//   late String name, org;
//   UserPage({super.key, required this.name, required this.org});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("User View!"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//         child: Container(
//           width: double.infinity,
//           height: double.infinity,
//           color: Colors.grey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 0),
//                 child: Text(
//                   "Name",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 25.0,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 8.0,
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(5, 3, 0, 1),
//                 child: Container(
//                   height: 50,
//                   width: double.maxFinite,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: Text(
//                     name,
//                     style: const TextStyle(
//                       color: Colors.black,
//                       fontSize: 25.0,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10.0,
//               ),
//               const Padding(
//                 padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 0),
//                 child: Text(
//                   "Organization",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 25.0,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 8.0,
//               ),
//               Container(
//                 height: 60,
//                 width: double.maxFinite,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: Text(
//                   org,
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 25.0,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10.0,
//               ),
//               // const Padding(
//               //   padding: EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 0),
//               //   child: Text(
//               //     "Course",
//               //     style: TextStyle(
//               //       color: Colors.white,
//               //       fontSize: 25.0,
//               //     ),
//               //   ),
//               // ),
//               // const SizedBox(
//               //   height: 8.0,
//               // ),
//               // Container(
//               //   height: 40,
//               //   width: double.maxFinite,
//               //   decoration: BoxDecoration(
//               //     color: Colors.white,
//               //     borderRadius: BorderRadius.circular(5),
//               //   ),
//               //   child: Text(
//               //     course,
//               //     style: const TextStyle(
//               //       color: Colors.blueAccent,
//               //       fontSize: 25.0,
//               //     ),
//               //   ),
//               // ),
//               // const SizedBox(
//               //   height: 10.0,
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
