import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:service_app/bloc/services_bloc.dart';
import 'package:service_app/data/local_storage.dart';
import 'package:service_app/data/mock_api.dart';
import 'package:service_app/data/repository.dart';
import 'package:service_app/ui/services_screen.dart';

class MockLocalStorage extends Mock implements LocalStorage {}
class MockBox extends Mock implements Box {}

// Test-safe main function that doesn't use Hive
void testMain() {
  // Setup mock localStorage
  final mockLocalStorage = MockLocalStorage();
  final mockBox = MockBox();

  when(() => mockLocalStorage.getFavorites()).thenReturn(<String>{});
  when(() => mockLocalStorage.saveFavorites(any())).thenAnswer((_) async {});

  // Create repository with mock dependencies
  final api = MockApi(pageSize: 10);
  final repo = Repository(api: api, local: mockLocalStorage);

  // Create and run the app with mocked dependencies
  runApp(
    RepositoryProvider.value(
      value: repo,
      child: BlocProvider(
        create: (_) => ServicesBloc(repo: repo),
        child: const MaterialApp(
          title: 'Favorite Services',
          home: ServicesScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    ),
  );
}