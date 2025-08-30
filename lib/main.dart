import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:service_app/ui/services_screen.dart';

import 'bloc/services_bloc.dart';
import 'data/local_storage.dart';
import 'data/mock_api.dart';
import 'data/repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Repository? repo;

  @override
  void initState() {
    super.initState();
    _initRepo();
  }

  Future<void> _initRepo() async {
    final local = await LocalStorage.init();
    final api = MockApi(pageSize: 10);
    repo = Repository(api: api, local: local);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (repo == null) {
      return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
    } else {
      return RepositoryProvider.value(
        value: repo,
        child: BlocProvider(
          create: (_) => ServicesBloc(repo: repo!),
          child: MaterialApp(
              title: 'Favorite Services',
              theme: ThemeData(primarySwatch: Colors.blue),
              home: const ServicesScreen(),
              debugShowCheckedModeBanner: false
          ),
        ),
      );
    }
  }
}
