import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopease/main.dart';

void main() {
  testWidgets('ShopEase App launch test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ShopEaseApp());

    // Verify that Splash Page elements are rendered
    expect(find.text('ShopEase'), findsOneWidget);
    expect(find.text('Your Premium Shopping Destination'), findsOneWidget);
    
    // Verify progress indicator is present
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
