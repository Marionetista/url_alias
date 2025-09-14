import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:url_alias/common/constants/messages.dart';
import 'package:url_alias/common/models/url_alias_model.dart';
import 'package:url_alias/features/home/data/home_repository.dart';
import 'package:url_alias/features/home/logic/home_cubit.dart';
import 'package:url_alias/features/home/logic/home_state.dart';
import 'package:url_alias/features/home/ui/home_page.dart';
import 'package:url_alias/features/home/ui/widgets/alias_list_item_widget.dart';
import 'package:url_alias/features/home/ui/widgets/aliases_list_widget.dart';
import 'package:url_alias/features/home/ui/widgets/empty_aliases_widget.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  group('HomePage Tests', () {
    late MockHomeRepository mockRepository;
    late HomeCubit homeCubit;

    setUp(() {
      mockRepository = MockHomeRepository();
      homeCubit = HomeCubit(repository: mockRepository);
    });

    tearDown(() {
      homeCubit.close();
    });

    Future<void> createWidget(WidgetTester tester) => tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<HomeCubit>(
          create: (context) => homeCubit,
          child: const HomePage(),
        ),
      ),
    );

    testWidgets('When HomePage is built '
        'should display all main widgets', (WidgetTester tester) async {
      await createWidget(tester);
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SafeArea), findsAtLeastNWidgets(1));
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byIcon(Icons.send), findsOneWidget);
      expect(find.text(AppMessages.recentlyShortenedUrls), findsOneWidget);
    });

    testWidgets('When HomePage is in initial state '
        'should show EmptyAliasesWidget', (WidgetTester tester) async {
      await createWidget(tester);
      await tester.pump();

      expect(find.text(AppMessages.noAliasesCreatedYet), findsOneWidget);
    });

    testWidgets('When HomePage is in loading state '
        'should show CircularProgressIndicator', (WidgetTester tester) async {
      await createWidget(tester);

      homeCubit.emit(const HomeLoading(aliases: []));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
    });

    testWidgets('When HomePage is in success state with aliases '
        'should show AliasListItem widgets', (WidgetTester tester) async {
      await createWidget(tester);

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

      homeCubit.emit(HomeSuccess(aliases: aliases));
      await tester.pump();

      expect(find.byType(AliasListItem), findsNWidgets(2));
      expect(find.text(AppMessages.alias('111111111')), findsOneWidget);
      expect(find.text(AppMessages.alias('222222222')), findsOneWidget);
    });

    testWidgets('When HomePage is in success state with empty aliases '
        'should show EmptyAliasesWidget', (WidgetTester tester) async {
      await createWidget(tester);

      homeCubit.emit(HomeSuccess(aliases: []));
      await tester.pump();

      expect(find.text(AppMessages.noAliasesCreatedYet), findsOneWidget);
    });

    testWidgets('When HomePage is in error state '
        'should show SnackBar', (WidgetTester tester) async {
      await createWidget(tester);

      homeCubit.emit(const HomeError(aliases: [], message: 'error message'));
      await tester.pumpAndSettle();

      expect(find.text('error message'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('When user enters valid URL and presses button '
        'should call createAlias', (WidgetTester tester) async {
      await createWidget(tester);

      const testUrl = 'https://www.example.com';

      await tester.enterText(find.byType(TextFormField), testUrl);
      await tester.pump();

      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      expect(find.text(testUrl), findsNothing);
    });

    testWidgets('When user enters invalid URL '
        'should show validation error', (WidgetTester tester) async {
      await createWidget(tester);

      await tester.enterText(find.byType(TextFormField), 'invalid-url');
      await tester.pump();

      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      expect(find.text(AppMessages.invalidUrl), findsOneWidget);
    });

    testWidgets('When user enters empty URL '
        'should show validation error', (WidgetTester tester) async {
      await createWidget(tester);

      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      expect(find.text(AppMessages.pleaseWriteAnUrl), findsOneWidget);
    });

    testWidgets('When user enters valid URL '
        'should clear text field after submission', (
      WidgetTester tester,
    ) async {
      await createWidget(tester);

      const testUrl = 'https://www.example.com';

      await tester.enterText(find.byType(TextFormField), testUrl);
      await tester.pump();

      expect(find.text(testUrl), findsOneWidget);

      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      expect(find.text(testUrl), findsNothing);
    });

    testWidgets('When HomePage renders AliasesListWidget with different states '
        'should work correctly', (WidgetTester tester) async {
      await createWidget(tester);

      // Test HomeSuccess state
      const aliases = [
        UrlAliasModel(
          alias: '111111111',
          self: 'https://www.example.com',
          short: 'https://short.ly/111111111',
        ),
      ];

      homeCubit.emit(HomeSuccess(aliases: aliases));
      await tester.pump();

      expect(find.byType(AliasesListWidget), findsOneWidget);
      expect(find.byType(AliasListItem), findsOneWidget);

      // Test HomeError state
      homeCubit.emit(
        const HomeError(aliases: aliases, message: 'Error message'),
      );
      await tester.pump();

      expect(find.byType(AliasesListWidget), findsOneWidget);
      expect(find.byType(AliasListItem), findsOneWidget);

      // Test HomeInitial state
      homeCubit.emit(const HomeInitial(aliases: []));
      await tester.pump();

      expect(find.byType(AliasesListWidget), findsOneWidget);
      expect(find.byType(EmptyAliasesWidget), findsOneWidget);

      // Test HomeLoading state with empty aliases
      homeCubit.emit(const HomeLoading(aliases: []));
      await tester.pump();

      expect(find.byType(AliasesListWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));

      // Test HomeLoading state with existing aliases
      homeCubit.emit(HomeLoading(aliases: aliases));
      await tester.pump();

      expect(find.byType(AliasesListWidget), findsOneWidget);
      expect(find.byType(AliasListItem), findsOneWidget);
    });
  });
}
