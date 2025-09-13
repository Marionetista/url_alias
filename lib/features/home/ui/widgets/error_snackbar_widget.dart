import 'package:flutter/material.dart';
import '../../../../common/constants/messages.dart';

class ErrorSnackBarWidget {
  static void show(BuildContext context, String errorMessage) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade300,
          content: Text(errorMessage),
          action: SnackBarAction(
            label: AppMessages.close,
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
        ),
      );
}
