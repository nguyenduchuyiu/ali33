import 'package:flutter/material.dart';

Widget buildErrorWidget(BuildContext context, Function() retry,
    [String errorMsg = "Something went wrong! Try again"]) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(errorMsg, style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 10),
        OutlinedButton(onPressed: retry, child: const Text("Retry")),
      ],
    ),
  );
}
