import 'package:flutter/material.dart';

import '../../../../common/constants/app_colors.dart';
import '../../../../common/constants/design_tokens.dart';
import '../../../../common/constants/messages.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) => AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: AppColors.pinky,
    title: Text(
      AppMessages.aliases,
      style: TextStyle(
        color: AppColors.whitePinky,
        fontWeight: FontWeight.bold,
        fontSize: DesignTokens.fontXL,
      ),
    ),
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
