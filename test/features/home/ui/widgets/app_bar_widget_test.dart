// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   testWidgets('Should find the correct widgets', callback)
// }

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_alias/common/constants/app_colors.dart';
import 'package:url_alias/common/constants/design_tokens.dart';
import 'package:url_alias/features/home/ui/widgets/app_bar_widget.dart';

void main() {
  testWidgets('When the widget is built '
      'Should find the correct widgets', (tester) async {
    await _createWidget(tester);

    expect(find.text('Aliases'), findsOneWidget);
  });

  testWidgets('When the widget is built '
      'Should find the correct custom colors and sizes', (tester) async {
    await _createWidget(tester);

    final appBar = tester.widget<AppBar>(find.byType(AppBar));

    expect(appBar.backgroundColor, equals(AppColors.pinky));

    final text = tester.widget<Text>(find.text('Aliases'));
    final style = text.style!;

    expect(style.color, equals(AppColors.whitePinky));
    expect(style.fontWeight, equals(FontWeight.bold));
    expect(style.fontSize, equals(DesignTokens.fonstXL));
  });
}

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(home: Scaffold(appBar: AppBarWidget())),
  );
}
