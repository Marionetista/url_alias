import 'package:flutter/material.dart';

import '../../../../common/constants/app_colors.dart';
import '../../../../common/constants/design_tokens.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) => AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: AppColors.pinky,
    title: Text(
      'Aliases',
      style: TextStyle(
        color: AppColors.whitePinky,
        fontWeight: FontWeight.bold,
        fontSize: DesignTokens.fonstXL,
      ),
    ),
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
