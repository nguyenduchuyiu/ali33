// import 'package:ali33/screens/home.dart';
// import 'package:ali33/screens/login.dart';
// import 'package:ali33/screens/no_internet_screen.dart';
// import 'package:ali33/screens/onboard.dart';
// import 'package:connectivity_wrapper/connectivity_wrapper.dart';
// import 'package:flutter/material.dart';

// class SplashScreen extends StatefulWidget {
//   String token;
//   SplashScreen({Key? key, required this.token})
//       : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   Widget _page = const SizedBox.shrink(); // Khởi tạo _page

//   @override
//   void initState() {
//     super.initState();
//     startSpreadOutAnimation(
//       widget.token != "" ? HomeScreen() : LoginScreen(isEditing: false)
//     );
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: AnimatedSwitcher(
//           duration: const Duration(milliseconds: 1500),
//           child: _page,
//         ),
//       ),
//     );
//   }

//   void startSpreadOutAnimation(Widget page) {
//     setState(() {
//       _page = page;
//     });
//   }
// }

