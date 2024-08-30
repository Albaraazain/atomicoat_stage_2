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
  // here we initialize the Hive database, which is used for local storage, specifically for storing recipes
  await Hive.initFlutter();
  //  here we initialize the storage service, which is used for storing and retrieving data from the local storage
  await StorageService.initialize();
  // here we initialize the logging service, which is used for logging messages and errors, which is logged to the console in debug mode
  await LoggingService.initialize();

  // Set up error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    LoggingService.error('Flutter error', error: details.exception, stackTrace: details.stack);
  };

  // now this is where the app is run in a zone, which is a way to catch errors that are not caught by the app. its kinda like a try-catch block
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