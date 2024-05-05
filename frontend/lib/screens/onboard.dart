// import 'package:ali33/constants/route_animation.dart';
// import 'package:ali33/screens/login.dart';
// import 'package:ali33/widgets/basic.dart';
// import 'package:flutter/material.dart';
// import 'package:proste_bezier_curve/proste_bezier_curve.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({Key? key}) : super(key: key);

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   Future<void> setOnboarding() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setBool("onBoard", true);
//   }

//   final PageController _pageController = PageController(initialPage: 0);

//   @override
//   void initState() {
//     super.initState();
//     setOnboarding();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           PageView(
//             // physics: NeverScrollableScrollPhysics(),
//             controller: _pageController,
//             children: [
//               // first page
//               Container(
//                 height: size.height,
//                 width: size.width,
//                 child: Stack(
//                   alignment: Alignment.topCenter,
//                   children: [
//                     ClipPath(
//                       clipper: ProsteBezierCurve(
//                         position: ClipPosition.bottom,
//                         list: [
//                           BezierCurveSection(
//                             start: Offset(0, size.height * 0.45),
//                             top: Offset(size.width / 7.5, size.height * 0.5),
//                             end: Offset(size.width / 3.3, size.height * 0.4),
//                           ),
//                           BezierCurveSection(
//                             start: Offset(size.width / 1.8, size.height * 0.35),
//                             top: Offset(size.width / 5 * 3, size.height * 0.33),
//                             end: Offset(size.width - 90, size.height * 0.55),
//                           ),
//                           BezierCurveSection(
//                             start: Offset(size.width - 90, size.height * 0.6),
//                             top: Offset(size.width - 50, size.height * 0.65),
//                             end: Offset(size.width, size.height * 0.7),
//                           ),
//                         ],
//                       ),
//                       child: Container(
//                         height: size.height * 0.7,
//                         color: Color(0xffF5FCF4),
//                       ),
//                     ),
//                     middleWidget(
//                         size,
//                         'assets/images/onboarding1.png',
//                         "Bee 2 Bee serves best grocery services",
//                         "soodtheladyehbdg,lakabbd jnabdbdgsandshecameli kenothingwetheassignmengreenguy",
//                         0)
//                   ],
//                 ),
//               ),
//               // second page
//               Container(
//                 height: size.height,
//                 width: size.width,
//                 child: Stack(
//                   alignment: Alignment.topCenter,
//                   children: [
//                     ClipPath(
//                       clipper: ProsteBezierCurve(
//                         position: ClipPosition.bottom,
//                         list: [
//                           BezierCurveSection(
//                             start: Offset(0, size.height * 0.7),
//                             top: Offset(40, size.height * 0.65),
//                             end: Offset(80, size.height * 0.55),
//                           ),
//                           BezierCurveSection(
//                             start: Offset(80, size.height * 0.55),
//                             top: Offset(size.width * 0.5, size.height * 0.4),
//                             end: Offset(size.width / 1.4, size.height * 0.48),
//                           ),
//                           BezierCurveSection(
//                             start: Offset(size.width * 2, size.height * 0.35),
//                             top: Offset(size.width * 1.2, size.height * 0.5),
//                             end: Offset(size.width, size.height * 0.4),
//                           ),
//                         ],
//                       ),
//                       child: Container(
//                         height: size.height * 0.7,
//                         color: Color(0xffFFF0C9),
//                       ),
//                     ),
//                     middleWidget(
//                         size,
//                         'assets/images/onboarding2.png',
//                         "Bee 2 Bee serves best grocery services",
//                         "soodtheladyehbdg,lakabbd jnabdbdgsandshecameli kenothingwetheassignmengreenguy",
//                         1)
//                   ],
//                 ),
//               ),
//               // third page
//               Container(
//                 height: size.height,
//                 width: size.width,
//                 child: Stack(
//                   alignment: Alignment.topCenter,
//                   children: [
//                     ClipPath(
//                       clipper:
//                           ProsteBezierCurve(position: ClipPosition.bottom, list: [
//                         BezierCurveSection(
//                           start: Offset(0, size.height * 0.45),
//                           top: Offset(size.width / 7.5, size.height * 0.5),
//                           end: Offset(size.width / 3.3, size.height * 0.4),
//                         ),
//                         BezierCurveSection(
//                           start: Offset(size.width / 1.8, size.height * 0.35),
//                           top: Offset(size.width / 5 * 3, size.height * 0.33),
//                           end: Offset(size.width - 90, size.height * 0.55),
//                         ),
//                         BezierCurveSection(
//                           start: Offset(size.width - 90, size.height * 0.6),
//                           top: Offset(size.width - 50, size.height * 0.65),
//                           end: Offset(size.width, size.height * 0.7),
//                         ),
//                       ]),
//                       child: Container(
//                         height: 650,
//                         color: Color(0xffF5FCF4),
//                       ),
//                     ),
//                     middleWidget(
//                         size,
//                         'assets/images/onboarding3.png',
//                         "Bee 2 Bee serves best grocery services",
//                         "soodtheladyehbdg,lakabbd jnabdbdgsandshecameli kenothingwetheassignmengreenguy",
//                         2)
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Positioned(
//             left: 20,
//             right: 20,
//             bottom: 20,
//             child: 
//           nextButton(
//             "Next",
//             () {
//               if (_pageController.page == 2) {
//                 Navigator.pushReplacement(
//                     context, SlideLeftRoute(widget: LoginScreen(isEditing: false,)));
//               } else {
//                 _pageController.nextPage(
//                     duration: Duration(milliseconds: 500),
//                     curve: Curves.easeInOut);
//               }
//             },
//           ))
//         ],
//       ),
//     );
//   }

//   Widget middleWidget(
//       Size size, String img, String title, String subTitle, int currentPage) {
//     return Padding(
//       padding:
//           const EdgeInsets.only(top: 16.0, bottom: 16, left: 30, right: 30),
//       child: Column(
//         children: [
//           Image.asset(img, height: size.height * 0.3),
//           SizedBox(height: size.height * 0.2),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: 1.2,color: Color(0xff9F7272)),
//           ),
//           SizedBox(height: 20),
//           Text(
//             subTitle,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 16,
//                 color: Color(0xff9F7272)),
//           ),
//           Spacer(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               circularDot(currentPage == 0),
//               SizedBox(width: 10),
//               circularDot(currentPage == 1),
//               SizedBox(width: 10),
//               circularDot(currentPage == 2),
//             ],
//           ),
//           Spacer()
//           //SizedBox(height: size.height * 0.02),
          
//         ],
//       ),
//     );
//   }

//   Widget circularDot(bool isFilled) {
//     return Container(
//       height: 15,
//       width: 15,
//       decoration: BoxDecoration(
//           shape: BoxShape.circle, color: isFilled ? Colors.red : Colors.grey),
//     );
//   }
// }
