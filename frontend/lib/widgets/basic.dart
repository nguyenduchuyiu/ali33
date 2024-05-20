import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget nextButton(String text, Function() onPressed) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffF67552),
          fixedSize: const Size(200, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.blueGrey),
        ),
      ),
    )
  );
}

Widget loadingAnimation() {
  return const Center(child: CircularProgressIndicator());
}

Future<bool?> toastMessage(message) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM_RIGHT,
    fontSize: 16.0,
    timeInSecForIosWeb: 2,
  );
}













Future<bool?> internetToastMessage([message = "Couldn't reach the server! Check your network once."]) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    fontSize: 16.0,
  );
}
