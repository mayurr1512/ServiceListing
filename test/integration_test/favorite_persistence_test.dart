import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'integration_test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Favorite Persistence Tests', () {
    testWidgets('favorite and unfavorite functionality', (tester) async {
      testMain();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));

      debugUI(tester); // This will print what's actually on screen

      // // Wait for services to load and verify
      final initialServices = find.byType(ListTile);
      expect(initialServices, findsAtLeast(5));

      // Get the first ListTile
      final firstListTile = initialServices.first;

      final allTextsInTile = find.descendant(
        of: firstListTile,
        matching: find.byType(Text),
      );

      final textWidgets = tester.widgetList<Text>(allTextsInTile);
      final firstServiceTitle = textWidgets.first.data;

      print('First service title: $firstServiceTitle');

      final firstFavoriteButton = find.descendant(
          of: firstListTile,
          matching: find.byType(IconButton)
      );

      await tester.tap(firstFavoriteButton);
      await tester.pumpAndSettle();

      // Switch to favorites tab
      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();

      // Verify the service is in favorites
      final favoriteServices = find.byType(ListTile);
      expect(favoriteServices, findsOneWidget);

      final firstFavoriteService = favoriteServices.first;
      final allTextsInFavoriteTile = find.descendant(
        of: firstFavoriteService,
        matching: find.byType(Text),
      );
      final favoriteTextWidgets = tester.widgetList<Text>(allTextsInFavoriteTile);
      final firstFavoriteServiceTitle = favoriteTextWidgets.first.data;

      expect(firstFavoriteServiceTitle, firstServiceTitle);

      // Unfavorite the service
      final unfavoriteButton = find.descendant(
        of: firstFavoriteService,
        matching: find.byType(IconButton),
      );

      await tester.tap(unfavoriteButton);
      await tester.pumpAndSettle();

      // Verify favorites list is empty
      expect(find.byType(ListTile), findsNothing);

      // Switch back to all services
      await tester.tap(find.text('All Services'));
      await tester.pumpAndSettle();
    });


    testWidgets('unfavoriting removes from favorites', (tester) async {
      // Use the test-safe main function
      testMain();
      await tester.pumpAndSettle();

      // Wait for services to load
      await tester.pump(const Duration(seconds: 2));

      // Favorite a service
      final favoriteButton = find.byKey(const Key('fav_2')).first;
      await tester.tap(favoriteButton);
      await tester.pumpAndSettle();

      // Switch to favorites tab and verify it's there
      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Plumbing'), findsAtLeast(1));

      // Unfavorite the service
      await tester.tap(find.byKey(const Key('fav_2')).first);
      await tester.pumpAndSettle();

      // Verify it's removed from favorites
      expect(find.textContaining('Plumbing'), findsNothing);
    });
  });
}

void debugUI(WidgetTester tester) {
  print('=== DEBUG UI ===');

  // Find all ListTiles first
  final listTiles = find.byType(ListTile);
  final listTileCount = listTiles.evaluate().length;
  print('Found $listTileCount ListTiles');

  // For each ListTile, find Text widgets within it
  for (int i = 0; i < listTileCount; i++) {
    final listTile = listTiles.at(i);
    print('--- ListTile $i ---');

    // Find Text widgets within this ListTile
    final textsInTile = find.descendant(
      of: listTile,
      matching: find.byType(Text),
    );

    final textWidgets = tester.widgetList<Text>(textsInTile);
    for (final text in textWidgets) {
      if (text.data != null && text.data!.isNotEmpty) {
        print('Text: ${text.data}');
      }
    }

    // Find IconButton within this ListTile (favorite button)
    final buttonsInTile = find.descendant(
      of: listTile,
      matching: find.byType(IconButton),
    );

    if (buttonsInTile.evaluate().isNotEmpty) {
      final button = tester.widget<IconButton>(buttonsInTile.first);
      print('Button key: ${button.key}');
    }
  }

  // Also check for any other Text widgets not in ListTiles (like tab labels, search hint, etc.)
  final otherTexts = find.byType(Text);
  final allTextWidgets = tester.widgetList<Text>(otherTexts);

  print('--- Other Text Widgets ---');
  for (final text in allTextWidgets) {
    if (text.data != null &&
        text.data!.isNotEmpty &&
        !text.data!.contains('Search any services') &&
        !text.data!.contains('All Services') &&
        !text.data!.contains('Favorites')) {
      print('Other Text: ${text.data}');
    }
  }

  print('=== END DEBUG ===');
}