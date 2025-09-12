import 'package:flutter/material.dart';

import '../../../common/constants/app_colors.dart';
import '../../../common/constants/design_tokens.dart';
import '../../../common/utils/app_utils.dart';
import 'widgets/app_bar_widget.dart';

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
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20.0, vertical: 20.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
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
                      const SizedBox(width: 8),
                      SizedBox(
                        width: DesignTokens.sizeXXXL,
                        height: DesignTokens.sizeXXXL,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Icon(Icons.send, size: DesignTokens.sizeXL),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: DesignTokens.sizeXXL),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
