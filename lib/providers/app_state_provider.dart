import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/storage_service.dart';

class AppStateProvider with ChangeNotifier {
  SystemState _systemState = SystemState();
  UserProfile? _currentUser;
  AppSettings _appSettings = AppSettings();

  SystemState get systemState => _systemState;
  UserProfile? get currentUser => _currentUser;
  AppSettings get appSettings => _appSettings;

  AppStateProvider() {
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    _systemState = await StorageService.getSystemState() ?? SystemState();
    _currentUser = await StorageService.getCurrentUser();
    _appSettings = await StorageService.getAppSettings() ?? AppSettings();
    notifyListeners();
  }

  void updateSystemState(SystemState newState) {
    _systemState = newState;
    StorageService.saveSystemState(newState);
    notifyListeners();
  }

  void updateCurrentUser(UserProfile? user) {
    _currentUser = user;
    StorageService.saveCurrentUser(user);
    notifyListeners();
  }

  void updateAppSettings(AppSettings settings) {
    _appSettings = settings;
    StorageService.saveAppSettings(settings);
    notifyListeners();
  }
}