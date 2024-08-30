import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/home_screen.dart';
import 'providers/app_state_provider.dart';
import 'providers/theme_provider.dart';
import 'utils/constants.dart';

// This file is the entry point of the app. It initializes the app and sets up the providers for the app state and theme.
// The provideres are important for managing the state of the app. specifically the app state provider is used to manage the state of the app, while the theme provider is used to manage the theme of the app.
// the way we use this providers through out the app is by using the consumer widget, which listens to changes in the state of the provider and rebuilds the widget tree when the state changes. so when the state of the app changes, the widgets that depend on that state are rebuilt.
// and by the state of the app, we mean the data that is used to build the widgets in the app, like the data that is used to build the home screen, the data that is used to build the monitoring screen, etc.


class AtomicoatApp extends StatelessWidget {
  // here we define the constructor for the AtomicoatApp widget, the constructor takes a key as an argument, which is used to identify the widget in the widget tree.
  const AtomicoatApp({Key? key}) : super(key: key);

  @override
  // the build method is the method that is called when the app is built. it returns the widget that is the root of the widget tree.
  Widget build(BuildContext context) {
    // here we use the Consumer widget to listen to changes in the theme provider, and rebuild the widget tree when the theme changes.
    return Consumer<ThemeProvider>(
      // the builder function is called when the theme changes, and it returns the MaterialApp widget, which is the root of the widget tree.
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Atomicoat Mobile App',
          theme: themeProvider.themeData,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('tr', ''),
          ],
          initialRoute: AppRoutes.home,
          routes: AppRoutes.getRoutes(),
        );
      },
    );
  }
}
