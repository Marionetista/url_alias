import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_alias/common/models/url_alias_model.dart';
import 'package:url_alias/features/home/ui/widgets/alias_list_item_widget.dart';

void main() {
  group('AliasListItem Widget Tests', () {
    late UrlAliasModel testAlias;

    setUp(
      () => testAlias = const UrlAliasModel(
        alias: '123456789',
        self: 'https://www.example.com',
        short: 'https://short.ly/123456789',
      ),
    );

    Future<void> createWidget(WidgetTester tester) => tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: AliasListItem(alias: testAlias)),
      ),
    );

    testWidgets('should display alias information correctly', (
      WidgetTester tester,
    ) async {
      await createWidget(tester);
      await tester.pumpAndSettle();

      expect(find.text('Alias: 123456789'), findsOneWidget);

      expect(find.text('Original: https://www.example.com'), findsOneWidget);

      expect(find.text('Short:https://short.ly/123456789'), findsOneWidget);

      expect(find.byIcon(Icons.copy), findsOneWidget);
    });

    testWidgets(
      'should copy short URL to clipboard when copy button is pressed',
      (WidgetTester tester) async {
        await createWidget(tester);
        await tester.pumpAndSettle();

        final copyButton = find.byIcon(Icons.copy);
        expect(copyButton, findsOneWidget);

        await tester.tap(copyButton);
        await tester.pumpAndSettle();

        expect(find.text('Short URL copied to clipboard'), findsOneWidget);
      },
    );
  });
}
