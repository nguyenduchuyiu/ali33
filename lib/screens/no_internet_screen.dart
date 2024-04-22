import 'package:flutter/material.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

class NoInternetScreen extends StatefulWidget {
  NoInternetScreen({Key? key}) : super(key: key);

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        // decoration: BoxDecoration(
        //   image: DecorationImage(image: AssetImage("assets/images/no_internet.png"),fit: BoxFit.cover)
        // ),
        child: Column(
          children: [
            Image.asset("assets/images/no_internet.png",
                height: size.height * 0.6,
                width: size.width,
                fit: BoxFit.cover),
            ClipPath(
              clipper: ProsteBezierCurve(
                position: ClipPosition.top,
                list: [
                  BezierCurveSection(
                    start: Offset(size.width, 60),
                    top: Offset(size.width * 0.5, 0),
                    end: Offset(0, 60),
                  ),
                ],
              ),
              child: Container(
                color: Theme.of(context).primaryColor,
                height: size.height * 0.4,
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 60),
                    Text(
                      "No Internet Connection",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "You are not connected to internet. Make sure to check network settings.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(180, 56), backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () => setState(() {}),
                      child: Text(
                        "Retry",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Spacer()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
