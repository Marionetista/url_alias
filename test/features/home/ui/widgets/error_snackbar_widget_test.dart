import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_alias/features/home/ui/widgets/error_snackbar_widget.dart';

void main() {
  group('ErrorSnackBarWidget Tests', () {
    testWidgets('should show error SnackBar with correct message', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'error';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: TestWidget(errorMessage: errorMessage)),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text(errorMessage), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);

      final snackBarFinder = find.byType(SnackBar);
      expect(snackBarFinder, findsOneWidget);

      final snackBar = tester.widget<SnackBar>(snackBarFinder);
      expect(snackBar.content, isA<Text>());
      expect((snackBar.content as Text).data, errorMessage);
    });

    testWidgets('should hide SnackBar when Close button is pressed', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Test error message';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: TestWidget(errorMessage: errorMessage)),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text(errorMessage), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.text(errorMessage), findsNothing);
    });
  });
}

class TestWidget extends StatelessWidget {
  const TestWidget({required this.errorMessage, super.key});

  final String errorMessage;

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: () => ErrorSnackBarWidget.show(context, errorMessage),
    child: const Text('Show Error'),
  );
}
