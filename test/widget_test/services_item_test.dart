import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:service_app/model/service.dart';
import 'package:service_app/ui/service_item.dart';

void main() {
  group('ServiceItem Widget Tests', () {
    final testService = Service(
      id: '1',
      title: 'Test Service',
      description: 'Test Description',
    );

    testWidgets('displays service title and description', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ServiceItem(
              service: testService,
              isFav: false,
              onFav: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Service'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('shows favorite icon when not favorited', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ServiceItem(
              service: testService,
              isFav: false,
              onFav: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('shows filled favorite icon when favorited', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ServiceItem(
              service: testService,
              isFav: true,
              onFav: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('calls onFav callback when favorite button is tapped', (tester) async {
      bool favTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ServiceItem(
              service: testService,
              isFav: false,
              onFav: () => favTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump();

      expect(favTapped, isTrue);
    });
  });
}