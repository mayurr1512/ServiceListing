import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:service_app/bloc/services_bloc.dart';
import 'package:service_app/bloc/services_event.dart';
import 'package:service_app/bloc/services_state.dart';
import 'package:service_app/ui/services_screen.dart';

class MockServicesBloc extends MockBloc<ServicesEvent, ServicesState>
    implements ServicesBloc {}

void main() {
  group('Search Functionality Tests', () {
    late MockServicesBloc mockBloc;

    setUp(() {
      mockBloc = MockServicesBloc();
    });

    testWidgets('search field is visible and functional', (tester) async {
      whenListen(
        mockBloc,
        Stream.value(const ServicesState()),
        initialState: const ServicesState(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<ServicesBloc>.value(
              value: mockBloc,
              child: const ServicesScreen(),
            ),
          ),
        ),
      );

      final searchIconInTextField = find.descendant(
        of: find.byType(TextField),
        matching: find.byIcon(Icons.search),
      );

      expect(searchIconInTextField, findsOneWidget);
    });

    testWidgets('triggers SearchServices event when typing', (tester) async {
      whenListen(
        mockBloc,
        Stream.value(const ServicesState()),
        initialState: const ServicesState(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<ServicesBloc>.value(
              value: mockBloc,
              child: const ServicesScreen(),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      verify(() => mockBloc.add(const SearchServices('test'))).called(1);
    });

    testWidgets('clear button appears when text is entered', (tester) async {
      whenListen(
        mockBloc,
        Stream.value(const ServicesState()),
        initialState: const ServicesState(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<ServicesBloc>.value(
              value: mockBloc,
              child: const ServicesScreen(),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('clear button triggers LoadServices event', (tester) async {
      whenListen(
        mockBloc,
        Stream.value(const ServicesState(query: 'test')),
        initialState: const ServicesState(query: 'test'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<ServicesBloc>.value(
              value: mockBloc,
              child: const ServicesScreen(),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      // Find the IconButton by type and icon
      final clearIconButton = find.byWidgetPredicate(
            (widget) => widget is IconButton && widget.icon is Icon && (widget.icon as Icon).icon == Icons.clear,
      );

      // Verify the clear IconButton is found
      expect(clearIconButton, findsOneWidget);

      // Tap the IconButton (not just the icon)
      await tester.tap(clearIconButton);
      await tester.pump();

      // Verify LoadServices event was called
      verify(() => mockBloc.add(const LoadServices())).called(1);
    });
  });
}