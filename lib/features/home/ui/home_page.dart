import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/constants/app_colors.dart';
import '../../../common/constants/design_tokens.dart';
import '../../../common/utils/app_utils.dart';
import '../logic/home_cubit.dart';
import '../logic/home_state.dart';
import 'widgets/alias_list_item_widget.dart';
import 'widgets/app_bar_widget.dart';
import 'widgets/error_snackbar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.whitePinky,
    appBar: AppBarWidget(),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            // Input Section
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            DesignTokens.sizeXXL,
                          ),
                        ),
                        hintText: 'Write your favorite url!',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please write an url';
                        }
                        if (!AppUtils.isValidUrl(value)) {
                          return 'Invalid URL';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: DesignTokens.sizeS),
                  SizedBox(
                    width: DesignTokens.sizeXXXL,
                    height: DesignTokens.sizeXXXL,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<HomeCubit>().createAlias(
                            _urlController.text,
                          );
                          _urlController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            DesignTokens.sizeM,
                          ),
                        ),
                      ),
                      child: Icon(Icons.send, size: DesignTokens.sizeXL),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: DesignTokens.sizeXXL,
              ),
              child: Row(
                children: [
                  Text(
                    'Recently shortened URLs',
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: DesignTokens.fontSM,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: BlocListener<HomeCubit, HomeState>(
                listener: (context, state) {
                  if (state is HomeError) {
                    ErrorSnackBarWidget.show(context, state.message);
                  }
                },

                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is HomeSuccess || state is HomeUrlRetrieved) {
                      final aliases = state is HomeSuccess
                          ? state.aliases
                          : (state as HomeUrlRetrieved).aliases;

                      return Column(
                        children: [
                          Expanded(
                            child: aliases.isEmpty
                                ? const Center(
                                    child: Text(
                                      'No aliases created yet',
                                      style: TextStyle(
                                        fontSize: DesignTokens.fontMD,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: aliases.length,
                                    itemBuilder: (context, index) {
                                      final alias = aliases[index];
                                      return AliasListItem(alias: alias);
                                    },
                                  ),
                          ),
                        ],
                      );
                    }

                    return const Center(
                      child: Text(
                        'No aliases created yet...\n Go on and create your shorten links!',
                        style: TextStyle(fontSize: DesignTokens.fontMD),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}
