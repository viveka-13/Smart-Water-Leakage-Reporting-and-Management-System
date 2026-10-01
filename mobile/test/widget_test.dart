import 'package:flutter_test/flutter_test.dart';
import 'package:aquaguard_mobile/main.dart';

void main() {
  testWidgets('AquaGuard opens on the workflow menu', (WidgetTester tester) async {
    await tester.pumpWidget(const AquaGuardApp());
    await tester.pumpAndSettle();

    expect(find.text('AquaGuard Demo'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Create citizen account'), findsOneWidget);
  });
}
