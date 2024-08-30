import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:async';

import 'app.dart';
import 'providers/app_state_provider.dart';
import 'providers/theme_provider.dart';
import 'services/storage_service.dart';
import 'services/logging_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await Hive.initFlutter();
  await LoggingService.initialize();

  bool initializationSuccessful = false;
  int retryCount = 0;
  const maxRetries = 3;

  while (!initializationSuccessful && retryCount < maxRetries) {
    try {
      await StorageService.initialize();
      initializationSuccessful = true;
    } catch (e) {
      retryCount++;
      LoggingService.error('Failed to initialize StorageService', error: e);
      if (retryCount < maxRetries) {
        await StorageService.clearHiveData();
      }
    }
  }

  if (!initializationSuccessful) {
    runApp(ErrorApp());
    return;
  }

  // Set up error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    LoggingService.error('Flutter error', error: details.exception, stackTrace: details.stack);
  };

  runZonedGuarded(
        () {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppStateProvider()),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ],
          child: const AtomicoatApp(),
        ),
      );
    },
        (error, stackTrace) {
      LoggingService.error('Uncaught error', error: error, stackTrace: stackTrace);
    },
  );
}

class ErrorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Failed to initialize the app. Please try again later.'),
        ),
      ),
    );
  }
}