// import 'dart:async';

// import 'package:ali33/constants/route_animation.dart';
// import 'package:ali33/models/user_model.dart';
// import 'package:ali33/screens/home.dart';
// import 'package:ali33/screens/profile.dart';
// import 'package:ali33/services/api_service.dart';
// import 'package:ali33/widgets/basic.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
 
// class OtpScreen extends StatefulWidget {
//   final String primary;
//   final bool isPresent, isPhone;
//   OtpScreen(
//       {required this.primary, required this.isPresent, required this.isPhone});
//   @override
//   _OtpScreenState createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen>
//     with SingleTickerProviderStateMixin {
//   AnimationController? _animationController;
//   int levelClock = 1 * 60;

//   late FocusNode pin2FocusNode;
//   late FocusNode pin3FocusNode;
//   late FocusNode pin4FocusNode;

//   TextEditingController contoller1 = TextEditingController();
//   TextEditingController contoller2 = TextEditingController();
//   TextEditingController contoller3 = TextEditingController();
//   TextEditingController contoller4 = TextEditingController();

//   bool status = false;
//   bool isLoading = false;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   static String otp = '';

//   // double tweenBegin = 60.0;
//   // Timer? _timer;
//   // int _startTime = 60;
//   // void timer() {
//   //   if (_timer != null) _timer!.cancel();
//   //   _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
//   //     setState(() {
//   //       if (_startTime > 0)
//   //         _startTime--;
//   //       else {
//   //         _timer!.cancel();
//   //         print("OTP expired");
//   //         setState(() {
//   //           otp = '';
//   //         });
//   //       }
//   //     });
//   //   });
//   // }

//   void getCode() async {
//     otp = "";
//     String result = await ApiService().sendOtp(widget.primary, 'email');
//     if (result != "") {
//       otp = result;
//       setState(() {});
//     }
//   }

//   @override
//   void initState() {
//     _animationController = AnimationController(
//         vsync: this, duration: Duration(seconds: levelClock));

//     _animationController!.forward();
//     // _startTime = 60;
//     // timer();
//     getCode();
//     pin2FocusNode = FocusNode();
//     pin3FocusNode = FocusNode();
//     pin4FocusNode = FocusNode();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _animationController!.dispose();
//     resetOtp();
//     pin2FocusNode.dispose();
//     pin3FocusNode.dispose();
//     pin4FocusNode.dispose();
//     // _timer!.cancel();
//     super.dispose();
//   }

//   void nextField(String value, FocusNode focusNode) {
//     if (value.length == 1) {
//       focusNode.requestFocus();
//     }
//   }

//   void resetOtp() {
//     // setState(() {
//     otp = "";
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("${widget.isPresent}");
//     final Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       // backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Stack(
//           children: <Widget>[
//             Container(
//               height: size.height,
//               width: size.width,
//               padding: EdgeInsets.symmetric(
//                   horizontal: 16, vertical: size.height * 0.1),
//               child: Column(
//                 children: [
//                   Text(
//                     'OTP Verification',
//                     style: Theme.of(context).textTheme.headline1,
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     "We've sent your code to ${widget.primary}",
//                     style: Theme.of(context).textTheme.headline3,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 30),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "This code expires in ",
//                         style: Theme.of(context).textTheme.bodyText1,
//                       ),
//                       Countdown(
//                         animation: StepTween(
//                           begin: levelClock, // THIS IS A USER ENTERED NUMBER
//                           end: 0,
//                         ).animate(_animationController!),
//                         resetOtp: resetOtp,
//                       ),
//                       // Text(
//                       //   "00:$_startTime sec",
//                       //   style: TextStyle(
//                       //     fontWeight: FontWeight.w500,
//                       //     fontSize: 16,
//                       //     color: Color(0xFFFF7643),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Form(
//                     key: _formKey,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(
//                           width: 60,
//                           child: TextFormField(
//                             inputFormatters: [
//                               LengthLimitingTextInputFormatter(1),
//                               FilteringTextInputFormatter.digitsOnly,
//                             ],
//                             controller: contoller1,
//                             autofocus: true,
//                             onChanged: (value) {
//                               nextField(value, pin2FocusNode);
//                             },
//                             obscureText: true,
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(fontSize: 24),
//                             decoration: InputDecoration(
//                               hintText: "0",
//                               contentPadding:
//                                   EdgeInsets.symmetric(vertical: 15),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide: BorderSide(color: Colors.black),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide: BorderSide(color: Colors.black),
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide: BorderSide(color: Colors.black),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 60,
//                           child: TextFormField(
//                             inputFormatters: [
//                               LengthLimitingTextInputFormatter(1),
//                               FilteringTextInputFormatter.digitsOnly,
//                             ],
//                             controller: contoller2,
//                             onChanged: (value) {
//                               nextField(value, pin3FocusNode);
//                             },
//                             obscureText: true,
//                             focusNode: pin2FocusNode,
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(fontSize: 24),
//                             decoration: InputDecoration(
//                               hintText: "0",
//                               contentPadding:
//                                   EdgeInsets.symmetric(vertical: 15),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide: BorderSide(color: Colors.black),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide: BorderSide(color: Colors.black),
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide: BorderSide(color: Colors.black),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 60,
//                           child: TextFormField(
//                             inputFormatters: [
//                               LengthLimitingTextInputFormatter(1),
//                               FilteringTextInputFormatter.digitsOnly,
//                             ],
//                             controller: contoller3,
//                             focusNode: pin3FocusNode,
//                             onChanged: (value) {
//                               nextField(value, pin4FocusNode);
//                             },
//                             obscureText: true,
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(fontSize: 24),
//                             decoration: InputDecoration(
//                               hintText: "0",
//                               contentPadding:
//                                   EdgeInsets.symmetric(vertical: 15),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide: BorderSide(color: Colors.black),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide: BorderSide(color: Colors.black),
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide: BorderSide(color: Colors.black),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 60,
//                           child: TextFormField(
//                             inputFormatters: [
//                               LengthLimitingTextInputFormatter(1),
//                               FilteringTextInputFormatter.digitsOnly,
//                             ],
//                             controller: contoller4,
//                             focusNode: pin4FocusNode,
//                             onChanged: (value) {
//                               pin4FocusNode.unfocus();
//                               if (value.isNotEmpty &&
//                                   contoller1.text.isNotEmpty &&
//                                   contoller2.text.isNotEmpty &&
//                                   contoller3.text.isNotEmpty) {
//                                 setState(() {
//                                   status = true;
//                                 });
//                               } else {
//                                 setState(() {
//                                   status = false;//Huy note: fix this to false
//                                 });
//                               }
//                             },
//                             obscureText: true,
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(fontSize: 24),
//                             decoration: InputDecoration(
//                               hintText: "0",
//                               contentPadding:
//                                   EdgeInsets.symmetric(vertical: 15),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide: BorderSide(color: Colors.black),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide: BorderSide(color: Colors.black),
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                                 borderSide: BorderSide(color: Colors.black),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 30),
//                   GestureDetector(
//                     onTap: () async {
//                       toastMessage("OTP resent");
//                       _animationController!.reset();
//                       _animationController!.forward();
//                       getCode();
//                       // setState(() {
//                       //   _startTime = 60;
//                       //   timer();
//                       // });
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text(
//                           'Resend OTP',
//                           style: Theme.of(context)
//                               .textTheme
//                               .headline3!
//                               .copyWith(
//                                   fontWeight: FontWeight.w800,
//                                   decoration: TextDecoration.underline,
//                                   color: Theme.of(context).primaryColor),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               child: isLoading ? loadingAnimation() : SizedBox.shrink(),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: nextButton("Verify", () {
//         if (contoller1.text.length == 1 &&
//             contoller2.text.length == 1 &&
//             contoller3.text.length == 1 &&
//             contoller4.text.length == 1) {
//           if (otp != "") { //Huy note : fix this to !=
//             String enterdOtp = contoller1.text +
//                 contoller2.text +
//                 contoller3.text +
//                 contoller4.text;
//             if (otp == enterdOtp) { //Huy note : fix this to ==
//               print("verified");
//               Navigator.pop(context, true);
//               //Huy note : I added a line below
//               // Navigator.pushReplacement(context, SlideLeftRoute(widget: HomeScreen()));
//               // Navigator.pushReplacement(
//               //     context,
//               //     SlideLeftRoute(
//               //       widget: widget.isPresent
//               //           ? HomeScreen()
//               //           : ProfileEditScreen(
//               //               isPhone: widget.isPhone,
//               //               // primary: widget.primary,
//               //               userModel: UserModel(cartItems: [], deliveryAddress: [], deviceToken: "deviceToken", dob: DateTime.now(), emailId:widget.isPhone?"": widget.primary, name: "", orders: [], phoneNo:widget.isPhone? widget.primary:"", profilePic: "", userType: "customer"),
//               //             ),
//               //     ));
//             } else {
//               toastMessage("invalid otp");
//             }
//           } else {
//             toastMessage("otp expired! click resend");
//           }
//         }
//       }),
//     );
//   }
// }

// class Countdown extends AnimatedWidget {
//   Countdown({Key? key, required this.animation, required this.resetOtp})
//       : super(key: key, listenable: animation);
//   Animation<int> animation;
//   Function resetOtp;

//   @override
//   build(BuildContext context) {
//     Duration clockTimer = Duration(seconds: animation.value);

//     String timerText =
//         '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
//     if (clockTimer.inSeconds.remainder(60) <= 1) {
//       resetOtp();
//     }
//     return Text(
//       timerText,
//       style: TextStyle(
//         fontSize: 18,
//         color: Theme.of(context).primaryColor,
//       ),
//     );
//   }
// }
