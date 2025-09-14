import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_alias/common/models/url_alias_model.dart';
import 'package:url_alias/features/home/ui/widgets/alias_list_item_widget.dart';
import 'package:url_alias/features/home/ui/widgets/aliases_list_widget.dart';
import 'package:url_alias/features/home/ui/widgets/empty_aliases_widget.dart';

void main() {
  group('AliasesListWidget Tests', () {
    const aliases = [
      UrlAliasModel(
        alias: '111111111',
        self: 'https://www.example.com',
        short: 'https://short.ly/111111111',
      ),
      UrlAliasModel(
        alias: '222222222',
        self: 'https://www.github.com',
        short: 'https://short.ly/222222222',
      ),
    ];

    Future<void> createWidget(
      WidgetTester tester,
      List<UrlAliasModel> aliases, {
      bool isLoading = false,
    }) => tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AliasesListWidget(aliases: aliases, isLoading: isLoading),
        ),
      ),
    );
    testWidgets('When aliases list is empty should show EmptyAliasesWidget', (
      WidgetTester tester,
    ) async {
      await createWidget(tester, []);

      expect(find.byType(EmptyAliasesWidget), findsOneWidget);
      expect(find.byType(AliasListItem), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets(
      'When aliases list has items should show AliasListItem widgets',
      (WidgetTester tester) async {
        await createWidget(tester, []);

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: AliasesListWidget(aliases: aliases)),
          ),
        );

        expect(find.byType(AliasListItem), findsNWidgets(2));
        expect(find.byType(EmptyAliasesWidget), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      },
    );

    testWidgets('When isLoading is true and aliases is empty '
        'should show CircularProgressIndicator', (WidgetTester tester) async {
      await createWidget(tester, [], isLoading: true);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(EmptyAliasesWidget), findsNothing);
      expect(find.byType(AliasListItem), findsNothing);
    });

    testWidgets('When isLoading is true and aliases has items '
        'should show AliasListItem widgets', (WidgetTester tester) async {
      await createWidget(tester, [aliases.first], isLoading: true);

      expect(find.byType(AliasListItem), findsOneWidget);
      expect(find.byType(EmptyAliasesWidget), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets(
      'When isLoading is false and aliases is empty should show EmptyAliasesWidget',
      (WidgetTester tester) async {
        await createWidget(tester, [], isLoading: false);

        expect(find.byType(EmptyAliasesWidget), findsOneWidget);
        expect(find.byType(AliasListItem), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      },
    );

    testWidgets('When aliases list has items should display correct content', (
      WidgetTester tester,
    ) async {
      await createWidget(tester, [aliases.first]);

      expect(find.text('Alias: ${aliases.first.alias}'), findsOneWidget);
      expect(find.text('Original: ${aliases.first.self}'), findsOneWidget);
      expect(find.text('Short:${aliases.first.short}'), findsOneWidget);
    });
  });
}
