import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/constants/app_colors.dart';
import '../../../common/constants/design_tokens.dart';
import '../../../common/constants/messages.dart';
import '../../../common/utils/app_utils.dart';
import '../logic/home_cubit.dart';
import '../logic/home_state.dart';
import 'widgets/aliases_list_widget.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        hintText: AppMessages.writeYourFavoriteUrl,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            DesignTokens.sizeXXL,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppMessages.pleaseWriteAnUrl;
                        }
                        if (!AppUtils.isValidUrl(value)) {
                          return AppMessages.invalidUrl;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: DesignTokens.sizeS),
                  SizedBox(
                    width: DesignTokens.sizeXXXL,
                    height: DesignTokens.sizeXXXL,
                    child: BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        final isLoading = state is HomeLoading;

                        return ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
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
                          child: isLoading
                              ? SizedBox(
                                  width: DesignTokens.sizeL,
                                  height: DesignTokens.sizeL,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                )
                              : Icon(Icons.send, size: DesignTokens.sizeXL),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: DesignTokens.sizeXXL,
              ),
              child: Text(
                AppMessages.recentlyShortenedUrls,
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: DesignTokens.fontMD,
                ),
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
                  builder: (context, state) => switch (state) {
                    HomeSuccess() => AliasesListWidget(aliases: state.aliases),
                    HomeError() => AliasesListWidget(aliases: state.aliases),
                    HomeInitial() => AliasesListWidget(aliases: state.aliases),
                    HomeLoading() => AliasesListWidget(
                      aliases: state.aliases,
                      isLoading: true,
                    ),
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
