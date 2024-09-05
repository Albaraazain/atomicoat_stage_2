import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/models.dart';
import '../models/recipe.dart';
import '../models/recipe_adapter.dart';

class StorageService {
  static late SharedPreferences _prefs;
  static late Box<Recipe> _recipeBox;
  static late Box<Recipe> _templateBox;
  static const String _systemStateKey = 'system_state';
  static const String _currentUserKey = 'current_user';
  static const String _appSettingsKey = 'app_settings';

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await Hive.initFlutter();
    Hive.registerAdapter(RecipeTypeAdapterCustom());
    Hive.registerAdapter(RecipeStepAdapterCustom());
    _recipeBox = await Hive.openBox<Recipe>('recipes');
    _templateBox = await Hive.openBox<Recipe>('recipe_templates');
  }

  static Future<void> clearHiveData() async {
    await Hive.deleteBoxFromDisk('recipes');
  }

  // Template methods
  static Future<List<Recipe>> getAllTemplates() async {
    return _templateBox.values.toList();
  }

  static Future<void> saveTemplate(Recipe template) async {
    await _templateBox.put(template.id, template);
  }

  static Future<void> deleteTemplate(String id) async {
    await _templateBox.delete(id);
  }

  static Future<Recipe?> getTemplate(String id) async {
    return _templateBox.get(id);
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
    if (_recipeBox == null) {
      throw StateError('Recipe box is not initialized');
    }
    return _recipeBox!.values.toList();
  }

  static Future<void> saveRecipe(Recipe recipe) async {
    if (_recipeBox == null) {
      throw StateError('Recipe box is not initialized');
    }
    await _recipeBox!.put(recipe.id, recipe);
  }

  static Future<void> deleteRecipe(String id) async {
    if (_recipeBox == null) {
      throw StateError('Recipe box is not initialized');
    }
    await _recipeBox!.delete(id);
  }

  static Future<Recipe?> getRecipe(String id) async {
    if (_recipeBox == null) {
      throw StateError('Recipe box is not initialized');
    }
    return _recipeBox!.get(id);
  }
}