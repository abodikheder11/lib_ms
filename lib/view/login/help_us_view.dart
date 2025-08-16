// import 'package:flutter/material.dart';
// import 'package:lib_ms/common/color__extention.dart';
// import 'package:lib_ms/view/home/home_view.dart';

// class HelpUsView extends StatefulWidget {
//   const HelpUsView({super.key});

//   @override
//   State<HelpUsView> createState() => _SigninViewState();
// }

// class _SigninViewState extends State<HelpUsView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back_ios, color: Tcolor.primary),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Help Us help You",
//                 style: TextStyle(
//                     color: Tcolor.text,
//                     fontSize: 24,
//                     fontWeight: FontWeight.w700),
//               ),
//               const SizedBox(
//                 height: 25,
//               ),
//               Text(
//                 "it seems as this is your first time using our app, please enter your location so we can filteer our results and stock accordingly to your local store,",
//                 style: TextStyle(
//                   color: Tcolor.subTitle,
//                   fontSize: 15,
//                 ),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               Text(
//                 "if you choose to skip, you can change your location at any time n your account settings.",
//                 style: TextStyle(
//                   color: Tcolor.subTitle,
//                   fontSize: 15,
//                 ),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               const Text("Chanch Click"),
//               ////////////////////
//               const SizedBox(
//                 height: 15,
//               ),
//               Container(
//                 height: 50,
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 decoration: BoxDecoration(
//                     color: Tcolor.TextBox,
//                     borderRadius: BorderRadius.circular(20)),
//                 child: DropdownButton(
//                     isExpanded: true,
//                     hint: const Text("State"),
//                     underline: Container(),
//                     items: ["State1", "State2"].map((name) {
//                       return DropdownMenuItem(
//                         value: name,
//                         child: Text(name),
//                       );
//                     }).toList(),
//                     onChanged: (selectVal) {}),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               ///////////////////////////
//               Container(
//                 height: 50,
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 decoration: BoxDecoration(
//                     color: Tcolor.TextBox,
//                     borderRadius: BorderRadius.circular(20)),
//                 child: DropdownButton(
//                     isExpanded: true,
//                     hint: const Text("City"),
//                     underline: Container(),
//                     items: ["City1", "City2"].map((name) {
//                       return DropdownMenuItem(
//                         value: name,
//                         child: Text(name),
//                       );
//                     }).toList(),
//                     onChanged: (selectVal) {}),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               //////////////////////
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const HomeView()));
//                     },
//                     child: Text(
//                       "Skip",
//                       style: TextStyle(
//                         color: Tcolor.primary,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],  
//           ),
//         ),
//       ),
//     );
//   }
// }
