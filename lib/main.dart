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
  await StorageService.initialize();
  await LoggingService.initialize();

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