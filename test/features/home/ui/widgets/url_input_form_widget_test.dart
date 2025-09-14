import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:url_alias/common/constants/messages.dart';
import 'package:url_alias/features/home/data/home_repository.dart';
import 'package:url_alias/features/home/logic/home_cubit.dart';
import 'package:url_alias/features/home/logic/home_state.dart';
import 'package:url_alias/features/home/ui/widgets/url_input_form_widget.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  group('UrlInputFormWidget Tests', () {
    late HomeCubit homeCubit;
    late MockHomeRepository mockRepository;

    setUp(() {
      mockRepository = MockHomeRepository();
      homeCubit = HomeCubit(repository: mockRepository);
    });

    tearDown(() {
      homeCubit.close();
    });

    Future<void> createWidget(WidgetTester tester) => tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<HomeCubit>(
            create: (context) => homeCubit,
            child: const UrlInputFormWidget(),
          ),
        ),
      ),
    );

    testWidgets('When widget is created should show TextFormField and button', (
      WidgetTester tester,
    ) async {
      await createWidget(tester);

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text(AppMessages.writeYourFavoriteUrl), findsOneWidget);
    });

    testWidgets('When user enters invalid URL and presses button '
        'should show validation error', (WidgetTester tester) async {
      await createWidget(tester);

      const invalidUrl = 'invalid-url';

      await tester.enterText(find.byType(TextFormField), invalidUrl);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text(AppMessages.invalidUrl), findsOneWidget);
    });

    testWidgets('When user enters empty URL and presses button '
        'should show validation error', (WidgetTester tester) async {
      await createWidget(tester);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text(AppMessages.pleaseWriteAnUrl), findsOneWidget);
    });

    testWidgets('When user enters valid URL and presses button '
        'should call createAlias', (WidgetTester tester) async {
      await createWidget(tester);

      const testUrl = 'https://www.example.com';

      await tester.enterText(find.byType(TextFormField), testUrl);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text(testUrl), findsNothing);
    });

    testWidgets('When cubit is in loading state '
        'should show CircularProgressIndicator in button', (
      WidgetTester tester,
    ) async {
      await createWidget(tester);

      homeCubit.emit(const HomeLoading(aliases: []));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.send), findsNothing);
    });

    testWidgets('When cubit is in loading state '
        'should disable button', (WidgetTester tester) async {
      await createWidget(tester);

      homeCubit.emit(const HomeLoading(aliases: []));
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('When cubit is not in loading state '
        'should enable button', (WidgetTester tester) async {
      await createWidget(tester);

      homeCubit.emit(const HomeInitial(aliases: []));
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('When user enters valid URL '
        'should not show validation error', (WidgetTester tester) async {
      await createWidget(tester);

      const validUrl = 'https://www.example.com';

      await tester.enterText(find.byType(TextFormField), validUrl);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text(AppMessages.invalidUrl), findsNothing);
      expect(find.text(AppMessages.pleaseWriteAnUrl), findsNothing);
    });

    testWidgets('When form is submitted successfully '
        'should clear text field', (WidgetTester tester) async {
      await createWidget(tester);

      const testUrl = 'https://www.example.com';

      await tester.enterText(find.byType(TextFormField), testUrl);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      final textField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textField.controller?.text, isEmpty);
    });
  });
}
