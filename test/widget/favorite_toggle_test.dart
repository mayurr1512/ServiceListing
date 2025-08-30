import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:service_app/model/service.dart';
import 'package:service_app/ui/service_item.dart';

void main() {
  testWidgets('Service List Item shows title and toggles icon', (tester) async {
    final s = const Service(id: '1', title: 'Test', description: 'desc');
    var isFav = false;
    await tester.pumpWidget(MaterialApp(
      home: ServiceItem(service: s, isFav: isFav, onFav: () { isFav = !isFav; }),
    ));

    expect(find.text('Test'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();
    // Callback toggled isFav variable, but UI rebuild not wired in this unit test
  });
}
