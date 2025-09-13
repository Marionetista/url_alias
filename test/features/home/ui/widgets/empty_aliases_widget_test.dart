import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_alias/features/home/ui/widgets/empty_aliases_widget.dart';

void main() {
  testWidgets('When the widget is built should find the correct widgets', (
    tester,
  ) async {
    await _createWidget(tester);

    expect(
      find.text(
        'No aliases created yet...\n Go on and create your shorten links!',
      ),
      findsOneWidget,
    );
  });
}

Future<void> _createWidget(WidgetTester tester) => tester.pumpWidget(
  const MaterialApp(home: Scaffold(body: EmptyAliasesWidget())),
);
