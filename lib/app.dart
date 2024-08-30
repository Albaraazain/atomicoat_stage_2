import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/home_screen.dart';
import 'providers/app_state_provider.dart';
import 'providers/theme_provider.dart';
import 'utils/constants.dart';

class AtomicoatApp extends StatelessWidget {
  const AtomicoatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
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
            Locale('es', ''),
          ],
          initialRoute: AppRoutes.home,
          routes: AppRoutes.getRoutes(),
        );
      },
    );
  }
}