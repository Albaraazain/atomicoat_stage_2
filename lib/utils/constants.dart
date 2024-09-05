import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/system_control_screen.dart';
import '../screens/recipe_screen.dart';
import '../screens/monitoring_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/plc_troubleshooter_screen.dart';
import '../screens/plc_image_screen.dart';
import '../screens/message_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String systemControl = '/system_control';
  static const String recipe = '/recipe';
  static const String monitoring = '/monitoring';
  static const String settings = '/settings';
  static const String plcTroubleshooter = '/plc_troubleshooter';
  static const String plcImage = '/plc_image';
  static const String machineStatusChat = '/machine_status_chat';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      systemControl: (context) => const SystemControlScreen(),
      recipe: (context) => const RecipeScreen(),
      monitoring: (context) => const MonitoringScreen(),
      settings: (context) => const SettingsScreen(),
      plcTroubleshooter: (context) => const PLCTroubleshooterScreen(),
      plcImage: (context) => const PLCImageScreen(),
      machineStatusChat: (context) => const MachineStatusChatScreen(),
    };
  }
}

class ApiConstants {
  static const String baseUrl = 'https://api.atomicoat.com/v1';
  static const int timeout = 10000; // milliseconds
}

class StorageKeys {
  static const String userProfile = 'user_profile';
  static const String appSettings = 'app_settings';
  static const String systemState = 'system_state';
}

class Debug {
  static const bool showPerformanceOverlay = false;
}