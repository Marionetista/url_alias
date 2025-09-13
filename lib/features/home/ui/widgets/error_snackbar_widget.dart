import 'package:flutter/material.dart';

class ErrorSnackBarWidget {
  static void show(BuildContext context, String errorMessage) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade300,
          content: Text(errorMessage),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
        ),
      );
}
