import 'package:flutter/material.dart';

class AliNotification extends StatelessWidget {
  final String notiMessage;

  const AliNotification({Key? key, required this.notiMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material( // Add Material for elevation and gesture detection
        color: Colors.transparent, // Transparent background for the Material
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(32), // Add margin for spacing
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row( // Use Row for icon and text alignment
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                size: 40,
                color: Colors.green,
              ),
              const SizedBox(width: 16),
              Expanded( // Expand text to take available space
                child: Text(
                  notiMessage,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Function to show the notification
void showAliNotification(BuildContext context, String message) {
  // Calculate a size based on screen width for a square shape
  double notificationSize = MediaQuery.of(context).size.width * 0.2;

  // Show a dialog
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing by tapping outside
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false, // Prevent closing with back button
        child: Dialog(
          backgroundColor: Colors.transparent, // Make the dialog transparent
          elevation: 0, // Remove dialog shadow
          child: Center(
            child: SizedBox( // Wrap with SizedBox to make it square
              width: notificationSize,
              height: notificationSize,
              child: AliNotification(notiMessage: message),
            ),
          ),
        ),
      );
    },
  );

  // Automatically close the dialog after a delay
  Future.delayed(const Duration(seconds: 3), () {
    Navigator.of(context).pop(); // Close the dialog
  });
}