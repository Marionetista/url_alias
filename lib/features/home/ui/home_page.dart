import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/constants/ui_tools.dart';
import '../logic/home_cubit.dart';
import '../logic/home_state.dart';
import 'widgets/aliases_list_widget.dart';
import 'widgets/app_bar_widget.dart';
import 'widgets/error_snackbar_widget.dart';
import 'widgets/url_input_form_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            const UrlInputFormWidget(),

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
              child: BlocConsumer<HomeCubit, HomeState>(
                listener: (context, state) {
                  if (state is HomeError) {
                    ErrorSnackBarWidget.show(context, state.message);
                  }
                },

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
          ],
        ),
      ),
    ),
  );
}
