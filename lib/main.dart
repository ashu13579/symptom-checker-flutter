import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:symptom_checker/core/theme/app_theme.dart';
import 'package:symptom_checker/presentation/pages/home_page.dart';
import 'package:symptom_checker/presentation/pages/body_map_page.dart';
import 'package:symptom_checker/presentation/pages/symptom_input_page.dart';
import 'package:symptom_checker/presentation/pages/results_page.dart';
import 'package:symptom_checker/presentation/bloc/symptom_bloc.dart';
import 'package:symptom_checker/data/repositories/symptom_repository_impl.dart';
import 'package:symptom_checker/data/datasources/remote_data_source.dart';

void main() {
  runApp(const SymptomCheckerApp());
}

class SymptomCheckerApp extends StatelessWidget {
  const SymptomCheckerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => SymptomRepositoryImpl(
        remoteDataSource: RemoteDataSource(),
      ),
      child: BlocProvider(
        create: (context) => SymptomBloc(
          repository: context.read<SymptomRepositoryImpl>(),
        ),
        child: MaterialApp(
          title: 'Symptom Checker',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: '/',
          routes: {
            '/': (context) => const HomePage(),
            '/body-map': (context) => const BodyMapPage(),
            '/symptom-input': (context) => const SymptomInputPage(),
            '/results': (context) => const ResultsPage(),
          },
        ),
      ),
    );
  }
}