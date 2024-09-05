import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/storage_service.dart';

class AppStateProvider with ChangeNotifier {
  SystemState _systemState = SystemState();
  UserProfile? _currentUser;
  AppSettings _appSettings = AppSettings();

  Timer? _updateTimer;

  SystemState get systemState => _systemState;
  UserProfile? get currentUser => _currentUser;
  AppSettings get appSettings => _appSettings;

  AppStateProvider() {
    _loadInitialState();
    _startPeriodicUpdates();
  }

  Future<void> _loadInitialState() async {
    // here we load the initial state from storage the syntax basically says if the value is null then use the value after the ?? operator and the awit is used to wait for the value to be returned
    _systemState = await StorageService.getSystemState() ?? SystemState();
    _currentUser = await StorageService.getCurrentUser();
    _appSettings = await StorageService.getAppSettings() ?? AppSettings();
    notifyListeners();
  }

  void _startPeriodicUpdates() {
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (_) => _updateSystemState());
  }

  void _updateSystemState() {
    if (_systemState.isRunning) {
      _systemState = _systemState.copyWith(
        temperature: _systemState.temperature + (Random().nextDouble() - 0.5),
        pressure: _systemState.pressure + (Random().nextDouble() - 0.5) * 100,
        gasFlowRate: _systemState.gasFlowRate + (Random().nextDouble() - 0.5) * 5,
      );
      notifyListeners();
    }
  }

  void updateSystemState(SystemState newState) {
    _systemState = newState;
    StorageService.saveSystemState(newState);
    notifyListeners();
  }

  void toggleComponentStatus(String componentId) {
    final updatedComponentStatus = Map<String, bool>.from(_systemState.componentStatus);
    updatedComponentStatus[componentId] = !(updatedComponentStatus[componentId] ?? false);

    _systemState = _systemState.copyWith(componentStatus: updatedComponentStatus);
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

  void toggleSystemRunning() {
    _systemState = _systemState.copyWith(
      isRunning: !_systemState.isRunning,
    );
    // Perform any additional logic needed when starting/stopping the system
    notifyListeners();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

}