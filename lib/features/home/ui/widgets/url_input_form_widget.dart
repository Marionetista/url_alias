import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/constants/ui_tools.dart';
import '../../../../common/utils/app_utils.dart';
import '../../logic/home_cubit.dart';
import '../../logic/home_state.dart';

class UrlInputFormWidget extends StatefulWidget {
  const UrlInputFormWidget({super.key});

  @override
  State<UrlInputFormWidget> createState() => _UrlInputFormWidgetState();
}

class _UrlInputFormWidgetState extends State<UrlInputFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Form(
    key: _formKey,
    child: Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _urlController,
            decoration: InputDecoration(
              hintText: AppMessages.writeYourFavoriteUrl,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignTokens.sizeXXL),
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
                    borderRadius: BorderRadius.circular(DesignTokens.sizeM),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: DesignTokens.sizeL,
                        height: DesignTokens.sizeL,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.acai,
                        ),
                      )
                    : Icon(Icons.send, size: DesignTokens.sizeXL),
              );
            },
          ),
        ),
      ],
    ),
  );
}
