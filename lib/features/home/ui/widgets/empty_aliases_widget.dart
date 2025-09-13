import 'package:flutter/material.dart';

import '../../../../common/constants/design_tokens.dart';
import '../../../../common/constants/messages.dart';

class EmptyAliasesWidget extends StatelessWidget {
  const EmptyAliasesWidget({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      AppMessages.noAliasesCreatedYet,
      style: TextStyle(fontSize: DesignTokens.fontMD),
      textAlign: TextAlign.center,
    ),
  );
}
