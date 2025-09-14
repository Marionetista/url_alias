import 'package:flutter/material.dart';
import '../../../../common/models/url_alias_model.dart';
import 'alias_list_item_widget.dart';
import 'empty_aliases_widget.dart';

class AliasesListWidget extends StatelessWidget {
  const AliasesListWidget({
    required this.aliases,
    this.isLoading = false,
    super.key,
  });

  final List<UrlAliasModel> aliases;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading && aliases.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (aliases.isEmpty) {
      return const EmptyAliasesWidget();
    }

    return ListView.builder(
      itemCount: aliases.length,
      itemBuilder: (context, index) => AliasListItem(alias: aliases[index]),
    );
  }
}
