import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/models.dart';
import '../models/recipe.dart';
import '../models/recipe_adapter.dart';

class StorageService {
  static late SharedPreferences _prefs;
  static late Box<Recipe> _recipeBox;
  static const String _systemStateKey = 'system_state';
  static const String _currentUserKey = 'current_user';
  static const String _appSettingsKey = 'app_settings';

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await Hive.initFlutter();
    Hive.registerAdapter(RecipeTypeAdapter());
    _recipeBox = await Hive.openBox<Recipe>('recipes');
  }

  // SystemState methods
  static Future<SystemState?> getSystemState() async {
    final String? stateJson = _prefs.getString(_systemStateKey);
    return stateJson != null ? SystemState.fromJson(jsonDecode(stateJson)) : null;
  }

  static Future<void> saveSystemState(SystemState state) async {
    await _prefs.setString(_systemStateKey, jsonEncode(state.toJson()));
  }

  // UserProfile methods
  static Future<UserProfile?> getCurrentUser() async {
    final String? userJson = _prefs.getString(_currentUserKey);
    return userJson != null ? UserProfile.fromJson(jsonDecode(userJson)) : null;
  }

  static Future<void> saveCurrentUser(UserProfile? user) async {
    if (user != null) {
      await _prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
    } else {
      await _prefs.remove(_currentUserKey);
    }
  }

  // AppSettings methods
  static Future<AppSettings?> getAppSettings() async {
    final String? settingsJson = _prefs.getString(_appSettingsKey);
    return settingsJson != null ? AppSettings.fromJson(jsonDecode(settingsJson)) : null;
  }

  static Future<void> saveAppSettings(AppSettings settings) async {
    await _prefs.setString(_appSettingsKey, jsonEncode(settings.toJson()));
  }

  // Recipe methods
  static Future<List<Recipe>> getAllRecipes() async {
    return _recipeBox.values.toList();
  }

  static Future<void> saveRecipe(Recipe recipe) async {
    await _recipeBox.put(recipe.id, recipe);
  }

  static Future<void> deleteRecipe(String id) async {
    await _recipeBox.delete(id);
  }
}