import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../common/constants/ui_tools.dart';
import '../../../../common/models/url_alias_model.dart';

class AliasListItem extends StatelessWidget {
  const AliasListItem({required this.alias, super.key});
  final UrlAliasModel alias;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: DesignTokens.sizeS),
    child: Padding(
      padding: const EdgeInsets.all(DesignTokens.sizeL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppMessages.alias(alias.alias),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: DesignTokens.sizeL,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: alias.short));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppMessages.shortUrlCopiedToClipboard),
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.sizeS),
          Text(
            AppMessages.original(alias.self),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: DesignTokens.sizeM),
          ),
          const SizedBox(height: DesignTokens.sizeXS),
          Text(
            AppMessages.short(alias.short),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: DesignTokens.sizeM,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: DesignTokens.sizeS),
        ],
      ),
    ),
  );
}
