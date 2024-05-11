// ignore_for_file: use_build_context_synchronously

import 'package:ali33/constants/route_animation.dart';
import 'package:ali33/screens/home.dart';
import 'package:ali33/services/api_service.dart';
import 'package:ali33/widgets/basic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:ali33/screens/signup.dart';

class LoginScreen extends StatefulWidget {
  final bool isEditing;
  const LoginScreen({Key? key, required this.isEditing}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool _showPassword = false;
  final GlobalKey<FormState> userIdKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  TextEditingController userId = TextEditingController();
  TextEditingController password = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder : (context, constraints) {
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
            child: Column(
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
                height: 480,
                width: 325,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    // SizedBox(height : 30),
                    
                    Text(
                      'Hello',
                      style :
                        TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        )
                    ),

                    // SizedBox(height: 10.0,),
                    Text(
                      'Please Login to Your Account',
                      style :
                        TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey
                        )
                    ),
                    SizedBox(height: 30.0,),

                    Container(
                      width: 250,
                      height: 50.0,
                      child: Form(
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
                          hintText: "Email or phone number",
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(15),
                          //   borderSide: const BorderSide(color: Colors.black),
                          // ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(15),
                          //   borderSide: const BorderSide(color: Colors.black),
                          // ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(15),
                          //   borderSide: const BorderSide(color: Colors.black),
                          // ),
                        ),
                      ),
                    ),
                    ),

                    SizedBox(height: 20.0),

                    Container(
                      width: 250,
                      height: 50.0,
                      child: Form(
                      key: passwordKey,
                      child: TextFormField(
                        controller: password,
                        validator: (String? val) => val!.isEmpty
                            ? "Field can't be empty"
                            : null,
                        decoration: InputDecoration(
                          hintText: "Enter your passworld",
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(15),
                          //   borderSide: const BorderSide(color: Colors.black),
                          // ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(15),
                          //   borderSide: const BorderSide(color: Colors.black),
                          // ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(15),
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
                          )
                        ),
                        obscureText: !_showPassword
                      ),
                    ),
                    ),
                    if (isLoading) loadingAnimation(),
                SizedBox(height: 40.0,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      SizedBox(
                        width: 250, // Set your desired width
                        height: 50, // Set your desired height
                        child: ElevatedButton(
                          onPressed: () async {
                            if (userIdKey.currentState!.validate() && passwordKey.currentState!.validate()) {
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
                              if (isRegistered) {
                                  final bool successLogin = await ApiService().login({
                                                                                "type": isPhone ? "phone" : "email",
                                                                                "userId": userId.text,
                                                                                "password": password.text
                                                                                });
                                  if (successLogin) {
                                    toastMessage("Successful Login");
                                    Navigator.pushReplacement(context, SlideLeftRoute(widget: const HomeScreen(selectedPage : 1)));
                                  }
                                  else {
                                    toastMessage('Wrong email (phone) or password!');
                                  }
                                } 
                                else { 
                                  toastMessage("Email/Phone is not registered!");
                                } 
                              }
                            }
                    
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20), // Rounded corners
                              ),
                            ),
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            backgroundColor: MaterialStateProperty.all(Colors.transparent), // Required to see the gradient
                            // Remove shadow from the button
                            elevation: MaterialStateProperty.all(0),
                            // Apply overlay color to ensure splash effect is transparent
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xff8a2387), // Start color
                                  Color(0xffe94057),
                                  
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20), // Match button border radius
                            ),
                            child: Container(
                              width: 250,
                              height: 50,
                              alignment: Alignment.center,
                              child: Text(
                                "Log in",
                                style: TextStyle(
                                  fontSize: 15, // Adjust text size to fit the button properly
                                  color: Colors.white, // Set text color
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height:  20), // spacing between 2 buttons
                      SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                pageBuilder: (context, animation1, animation2) => SignupScreen(),
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
                              width: 250,
                              height: 50,
                              alignment: Alignment.center,
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ]
                 )
                  ],
                ),
              )
            ],
            ),
          )
        )
        );
      }
      );
      }
}
