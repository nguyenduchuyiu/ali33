// ignore_for_file: use_build_context_synchronously

import 'package:ali33/constants/route_animation.dart';
import 'package:ali33/screens/home.dart';
import 'package:ali33/services/api_service.dart';
import 'package:ali33/widgets/basic.dart';
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
          // backgroundColor: Colors.white,
          body: Stack(
            // alignment: Alignment.topLeft,
            children: [
              /// Wavy line
              ClipPath(
                clipper: ProsteBezierCurve(
                  position: ClipPosition.bottom,
                  list: [
                    BezierCurveSection(
                      start: const Offset(0, 175),
                      top: Offset(size.width / 4, 150),
                      end: Offset(size.width / 2, 175),
                    ),
                    BezierCurveSection(
                      start: Offset(size.width / 2, 175),
                      top: Offset(size.width / 4 * 3, 200),
                      end: Offset(size.width, 175),
                    ),
                  ],
                ),
                child: Container(
                  height: 200,
                  color: const Color(0xffFFF0C9),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     const Spacer(),
                    //     Image.asset(
                    //       "images/logo.png",
                    //       height: 100,
                    //       alignment: Alignment.center,
                    //     ),
                    //     const SizedBox(width: 10),
                    //     Text(
                    //       "ALI33",
                    //       style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.black),
                    //     ),
                    //     const Spacer()
                    //   ],
                    // ),
                    LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Center content horizontally
                          children: [
                            // Conditionally show image based on available space
                            if (constraints.maxWidth > 400) // Adjust threshold as needed
                              Image.asset(
                                "images/logo.png",
                                height: 100,
                                alignment: Alignment.center,
                              ),
                            const SizedBox(width: 10),
                            Text(
                              "ALI33",
                              style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.black),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 50),
                    Text(
                      "LOG IN",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Email/Phone",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
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
                          hintText: "example@gmail.com / 0123456789",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Password",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Form(
                      key: passwordKey,
                      child: TextFormField(
                        controller: password,
                        validator: (String? val) => val!.isEmpty
                            ? "Field can't be empty"
                            : null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          suffixIcon: IconButton(
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
                  ],
                ),
              ),
              if (isLoading) loadingAnimation(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    nextButton("Log in", () async {
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
                              Navigator.pushReplacement(context, SlideLeftRoute(widget: const HomeScreen(selectedPage: 0,)));
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
                    }),
                    const SizedBox(width: 10), // spacing between 2 botton
                    nextButton("Sign up", () async {
                      Navigator.pushReplacement(context, SlideLeftRoute(widget: const SignupScreen()));
                    })
                  ]
              )
            ],
          ),
        );
      }
    );
  }
}
        
