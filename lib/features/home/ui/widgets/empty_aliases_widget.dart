import 'package:flutter/material.dart';

import '../../../../common/constants/design_tokens.dart';

class EmptyAliasesWidget extends StatelessWidget {
  const EmptyAliasesWidget({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: Text(
      'No aliases created yet...\n Go on and create your shorten links!',
      style: TextStyle(fontSize: DesignTokens.fontMD),
      textAlign: TextAlign.center,
    ),
  );
}
