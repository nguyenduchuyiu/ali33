// ignore_for_file: use_build_context_synchronously

import 'package:ali33/constants/route_animation.dart';
import 'package:ali33/screens/login.dart';
import 'package:ali33/services/api_service.dart';
import 'package:ali33/widgets/basic.dart';
import 'package:flutter/material.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

double sizeBoxSize1 = 15;

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isLoading = false;
  bool _showPassword = false;

  final GlobalKey<FormState> usernameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> userIdKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  final GlobalKey<FormState> repassKey = GlobalKey<FormState>();

  TextEditingController username = TextEditingController();
  TextEditingController userId = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController repass = TextEditingController();

  bool _phoneNumberValidator(String value) {
    String pattern = r'^(0|\+84)(3[2-9]|5[689]|7[06-9]|8[1-689]|9[0-46-9])[0-9]{7}$';
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(pattern);
  }

  bool emailValidator(String email) {
    String regexp =
        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    RegExp reg = RegExp(regexp);
    return reg.hasMatch(email);
  }

   
  bool passwordValidator(String password) {
    // Require at least 8 characters, one uppercase, one lowercase, one number, and one special character
    String regexp = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!#$%&'()*+,-./:;<=>?@[\]^_`{|}~]).{8,}$";
    RegExp reg = RegExp(regexp);
    return reg.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body : SingleChildScrollView(
          child:Container(
            height: MediaQuery.of(context).size.height,
            width : MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff8a2387), // Start color
                  Color(0xffe94057),
                  Color(0xfff27121) // End color
                ]
              ),
            ),
            child : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                      "images/logo.png",
                      height: 90,
                      alignment: Alignment.topCenter,
                    ),
              SizedBox(height : size.height/40),
              Text(
                'Ali33',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height : 10.0),
              Container(
                height: 550,
                width: 372,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                      'Wellcome',
                      style :
                        TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        )
                    ),
                      Text(
                        'Please create your account',
                        style :
                          TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                          )
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        width: 300.0,
                        child: 
                        Form(
                          key: usernameKey,
                          child: TextFormField(
                            controller: username,
                            validator: (String? val) => val!.isEmpty
                                ? "Field can't be empty"
                                : null,
                            decoration: InputDecoration(
                              hintText: "Your name",
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(5),
                              //   borderSide: const BorderSide(color: Colors.black),
                              // ),
                              // enabledBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(5),
                              //   borderSide: const BorderSide(color: Colors.black),
                              // ),
                              // focusedBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(5),
                              //   borderSide: const BorderSide(color: Colors.black),
                              // ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: sizeBoxSize1,),
                      Container(
                        width: 300,
                        child: 
                        Form(
                          key: userIdKey,
                          child: TextFormField(
                            controller: userId,
                            validator: (String? val) => val!.isEmpty
                                ? "Field can't be empty"
                                : (!emailValidator(val) &&
                                        !_phoneNumberValidator(val))
                                    ? "Enter correct email id/phone no"
                                    : null,
                            decoration: InputDecoration(
                              hintText: "Enter your email",
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(5),
                              //   borderSide: const BorderSide(color: Colors.black),
                              // ),
                              // enabledBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(5),
                              //   borderSide: const BorderSide(color: Colors.black),
                              // ),
                              // focusedBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(5),
                              //   borderSide: const BorderSide(color: Colors.black),
                              // ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: sizeBoxSize1,),
                      Container(
                        width:300.0,
                        child: Form(
                          key: passwordKey,
                          child: TextFormField(
                            controller: password,
                            validator: (String? val) => val!.isEmpty
                                ? "Field can't be empty"
                                : (!passwordValidator(val))
                                ? "Require at least 8 characters, one uppercase, one lowercase, one number, and one special character"
                                : null,
                            decoration: InputDecoration(
                              hintText: 'Create your password',
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(5),
                              //   borderSide: const BorderSide(color: Colors.black),
                              // ),
                              // enabledBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(5),
                              //   borderSide: const BorderSide(color: Colors.black),
                              // ),
                              // focusedBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(5),
                              //   borderSide: const BorderSide(color: Colors.black),
                              // ),
                              suffixIcon: IconButton(
                              iconSize: 17,
                              icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              ),
                            ),
                            obscureText: !_showPassword
                          ),
                        ),
                      ),
                      SizedBox(height: sizeBoxSize1,),
                      Container(
                        width: 300.0,
                        child: 
                        Form(
                          key: repassKey,
                          child: TextFormField(
                            controller: repass,
                            validator: (String? val) => val != password.text
                                ? "Password is not matched!"
                                : null,
                            decoration: InputDecoration(
                              hintText: 'Confirm your password',
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(5),
                              //   borderSide: const BorderSide(color: Colors.black),
                              // ),
                              // enabledBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(5),
                              //   borderSide: const BorderSide(color: Colors.black),
                              // ),
                              // focusedBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(5),
                              //   borderSide: const BorderSide(color: Colors.black),
                              // ),
                              suffixIcon: IconButton(
                              iconSize: 17.0,
                              icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              ),
                            ),
                            obscureText: !_showPassword
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0,),
                      SizedBox(
                        width: 300,
                        height: 50,
child: ElevatedButton(
                          onPressed: () async {
                            if (usernameKey.currentState!.validate()
                            && userIdKey.currentState!.validate() 
                            && passwordKey.currentState!.validate() 
                            && repassKey.currentState!.validate()) {
                              bool isPhone = RegExp(r'^[0-9]+$').hasMatch(userId.text);
                              setState(() {
                                isLoading = true;
                              });
                              bool? isRegistered = await ApiService().checkUser({'userId': userId.text, 
                                                                                'type': isPhone? 'phone' : 'email'});
                              setState(() {
                                isLoading = false;
                              });
                              if (isRegistered  != null) {
                                if (!isRegistered) {
                                    final bool successSignup = await ApiService().signup({
                                                                                  "type": isPhone ? "phone" : "email",
                                                                                  "username": username.text,
                                                                                  "userId": userId.text,
                                                                                  "password": password.text
                                                                                  });
                                    if (successSignup) {
                                      Navigator.pushReplacement(context, SlideLeftRoute(widget: const LoginScreen(isEditing: false)));
                                      toastMessage('Account created successfully!');
                                    } else {
                                      toastMessage('Signup failed. Please try again or contact support.');
                                    }
                                  } 
                                  else { 
                                    toastMessage("Email/Phone is already registered!");
                                  } 
                                }
                              }
                  
                          },
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0), // Remove elevation (shadow)
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                            ),
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            // Setting the background to transparent
                            backgroundColor: MaterialStateProperty.all(Colors.transparent),
                            // Apply overlay color to ensure splash effect is transparent
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xffe94057),
                                  Color(0xfff27121) // End color
                                ],
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Container(
                              width: 300,
                              height: 50,
                              alignment: Alignment.center,
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: sizeBoxSize1,),
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                pageBuilder: (context, animation1, animation2) => const LoginScreen(isEditing: false),
                                transitionDuration: Duration(seconds: 1),
                                transitionsBuilder: (context, animation, animationTime, child) {
                                  animation = CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn);
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );// Your button press functionality
                          },
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0), // Remove elevation (shadow)
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                            ),
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            // Setting the background to transparent
                            backgroundColor: MaterialStateProperty.all(Colors.transparent),
                            // Apply overlay color to ensure splash effect is transparent
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xffe94057),
                                  Color(0xfff27121) // End color
                                ],
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Container(
                              width: 300,
                              height: 50,
                              alignment: Alignment.center,
                              child: Text(
                                "Log in",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                        ,
                      )
                    ],
                  ),
                )
              ],
            )
          ),
        )
      );
  }
}
        
// backgroundColor: Colors.white,
      // body: Stack(
      //   // alignment: Alignment.topLeft,
      //   children: [
      //     /// Wavy line
      //     ClipPath(
      //       clipper: ProsteBezierCurve(
      //         position: ClipPosition.bottom,
      //         list: [
      //           BezierCurveSection(
      //             start: const Offset(0, 175),
      //             top: Offset(size.width / 4, 150),
      //             end: Offset(size.width / 2, 175),
      //           ),
      //           BezierCurveSection(
      //             start: Offset(size.width / 2, 175),
      //             top: Offset(size.width / 4 * 3, 200),
      //             end: Offset(size.width, 175),
      //           ),
      //         ],
      //       ),
      //       child: Container(
      //         height: 200,
      //         color: const Color(0xffFFF0C9),
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           const SizedBox(height: 20),
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceAround,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               const Spacer(),
      //               Image.asset(
      //                 "images/logo.png",
      //                 height: 100,
      //                 alignment: Alignment.topCenter,
      //               ),
      //               const SizedBox(width: 10),
      //               Text(
      //                 "ALI33",
      //                 style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.black),
      //               ),
      //               const Spacer()
      //             ],
      //           ),
      //           const SizedBox(height: 50),
      //           Text(
      //             "SIGN UP",
      //             style: Theme.of(context).textTheme.displayMedium,
      //           ),
      //           const SizedBox(height: 20),
      //           Text(
      //             "Username",
      //             style: Theme.of(context).textTheme.displaySmall,
      //           ),
      //           Form(
      //             key: usernameKey,
      //             child: TextFormField(
      //               controller: username,
      //               validator: (String? val) => val!.isEmpty
      //                   ? "Field can't be empty"
      //                   : null,
      //               decoration: InputDecoration(
      //                 hintText: "John Doe",
      //                 border: OutlineInputBorder(
      //                   borderRadius: BorderRadius.circular(5),
      //                   borderSide: const BorderSide(color: Colors.black),
      //                 ),
      //                 enabledBorder: OutlineInputBorder(
      //                   borderRadius: BorderRadius.circular(5),
      //                   borderSide: const BorderSide(color: Colors.black),
      //                 ),
      //                 focusedBorder: OutlineInputBorder(
      //                   borderRadius: BorderRadius.circular(5),
      //                   borderSide: const BorderSide(color: Colors.black),
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Text(
      //             "Email/Phone",
      //             style: Theme.of(context).textTheme.displaySmall,
      //           ),
      //           Form(
      //             key: userIdKey,
      //             child: TextFormField(
      //               controller: userId,
      //               validator: (String? val) => val!.isEmpty
      //                   ? "Field can't be empty"
      //                   : (!emailValidator(val) &&
      //                           !_phoneNumberValidator(val))
      //                       ? "Enter correct email id/phone no"
      //                       : null,
      //               decoration: InputDecoration(
      //                 hintText: "example@gmail.com / 0123456789",
      //                 border: OutlineInputBorder(
      //                   borderRadius: BorderRadius.circular(5),
      //                   borderSide: const BorderSide(color: Colors.black),
      //                 ),
      //                 enabledBorder: OutlineInputBorder(
      //                   borderRadius: BorderRadius.circular(5),
      //                   borderSide: const BorderSide(color: Colors.black),
      //                 ),
      //                 focusedBorder: OutlineInputBorder(
      //                   borderRadius: BorderRadius.circular(5),
      //                   borderSide: const BorderSide(color: Colors.black),
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Text(
      //             "Password",
      //             style: Theme.of(context).textTheme.displaySmall,
      //           ),
      //           Form(
      //             key: passwordKey,
      //             child: TextFormField(
      //               controller: password,
      //               validator: (String? val) => val!.isEmpty
      //                   ? "Field can't be empty"
      //                   : (!passwordValidator(val))
      //                   ? "Require at least 8 characters, one uppercase, one lowercase, one number, and one special character"
      //                   : null,
      //               decoration: InputDecoration(
      //                 border: OutlineInputBorder(
      //                   borderRadius: BorderRadius.circular(5),
      //                   borderSide: const BorderSide(color: Colors.black),
      //                 ),
      //                 enabledBorder: OutlineInputBorder(
      //                   borderRadius: BorderRadius.circular(5),
      //                   borderSide: const BorderSide(color: Colors.black),
      //                 ),
      //                 focusedBorder: OutlineInputBorder(
      //                   borderRadius: BorderRadius.circular(5),
      //                   borderSide: const BorderSide(color: Colors.black),
      //                 ),
      //                 suffixIcon: IconButton(
      //                 icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
      //                 onPressed: () {
      //                   setState(() {
      //                     _showPassword = !_showPassword;
      //                   });
      //                 },
      //                 ),
      //               ),
      //               obscureText: !_showPassword
      //             ),
      //           ),
      //           Text(
      //             "Re-enter Password",
      //             style: Theme.of(context).textTheme.displaySmall,
      //           ),
      //           Form(
      //             key: repassKey,
      //             child: TextFormField(
      //               controller: repass,
      //               validator: (String? val) => val != password.text
      //                   ? "Password is not matched!"
      //                   : null,
      //               decoration: InputDecoration(
      //                 border: OutlineInputBorder(
      //                   borderRadius: BorderRadius.circular(5),
      //                   borderSide: const BorderSide(color: Colors.black),
      //                 ),
      //                 enabledBorder: OutlineInputBorder(
      //                   borderRadius: BorderRadius.circular(5),
      //                   borderSide: const BorderSide(color: Colors.black),
      //                 ),
      //                 focusedBorder: OutlineInputBorder(
      //                   borderRadius: BorderRadius.circular(5),
      //                   borderSide: const BorderSide(color: Colors.black),
      //                 ),
      //                 suffixIcon: IconButton(
      //                 icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
      //                 onPressed: () {
      //                   setState(() {
      //                     _showPassword = !_showPassword;
      //                   });
      //                 },
      //                 ),
      //               ),
      //               obscureText: !_showPassword
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //     if (isLoading) loadingAnimation(),
      //       Column(
      //         mainAxisAlignment: MainAxisAlignment.end,
      //         children: [
      //           nextButton("Sign up", () async {
      //             if (usernameKey.currentState!.validate()
      //             && userIdKey.currentState!.validate() 
      //             && passwordKey.currentState!.validate() 
      //             && repassKey.currentState!.validate()) {
      //               bool isPhone = RegExp(r'^[0-9]+$').hasMatch(userId.text);
      //               setState(() {
      //                 isLoading = true;
      //               });
      //               bool? isRegistered = await ApiService().checkUser({'userId': userId.text, 
      //                                                                 'type': isPhone? 'phone' : 'email'});
      //               setState(() {
      //                 isLoading = false;
      //               });
      //               if (isRegistered  != null) {
      //                 if (!isRegistered) {
      //                     final bool successSignup = await ApiService().signup({
      //                                                                   "type": isPhone ? "phone" : "email",
      //                                                                   "username": username.text,
      //                                                                   "userId": userId.text,
      //                                                                   "password": password.text
      //                                                                   });
      //                     if (successSignup) {
      //                       Navigator.pushReplacement(context, SlideLeftRoute(widget: const LoginScreen(isEditing: false)));
      //                       toastMessage('Account created successfully!');
      //                     } else {
      //                       toastMessage('Signup failed. Please try again or contact support.');
      //                     }
      //                   } 
      //                   else { 
      //                     toastMessage("Email/Phone is already registered!");
      //                   } 
      //                 }
      //               }
      //             }),
      //           const SizedBox(width: 10), // spacing between 2 botton
      //           nextButton("Log in", () async {
      //             Navigator.pushReplacement(context, SlideLeftRoute(widget: const LoginScreen(isEditing: false)));
      //           })
      //         ]
      //     )
      //   ],
      // ),