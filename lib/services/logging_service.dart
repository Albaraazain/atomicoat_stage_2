import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum LogLevel { debug, info, warning, error }

class LogEntry {
  DateTime _timestamp; // Make timestamp private
  final LogLevel level;
  final String message;
  final String? stackTrace;

  LogEntry({required this.level, required this.message, this.stackTrace})
      : _timestamp = DateTime.now();

  DateTime get timestamp => _timestamp; // Getter for timestamp

  Map<String, dynamic> toJson() => {
    'timestamp': _timestamp.toIso8601String(),
    'level': level.toString(),
    'message': message,
    'stackTrace': stackTrace,
  };

  factory LogEntry.fromJson(Map<String, dynamic> json) => LogEntry(
    level: LogLevel.values
        .firstWhere((e) => e.toString() ==json['level']),
    message: json['message'],
    stackTrace: json['stackTrace'],
  ).._timestamp = DateTime.parse(json['timestamp']);
}

class LoggingService {
  static const int _maxLogEntries = 1000;
  static late SharedPreferences _prefs;
  static const String _logKey = 'app_logs';

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static void log(LogLevel level, String message,
      {dynamic error, StackTrace? stackTrace}) {
    final entry = LogEntry(
        level: level,
        message: message,
        stackTrace: stackTrace?.toString() ?? error?.stackTrace?.toString());

    _saveLog(entry);

    // Print to console in debug mode
    if (kDebugMode) {
      print('${entry.timestamp} - ${entry.level}: ${entry.message}');
      if (entry.stackTrace != null) print(entry.stackTrace);
    }

    // TODO: Implement remote logging here if needed
  }

  static void debug(String message) => log(LogLevel.debug, message);
  static void info(String message) => log(LogLevel.info, message);
  static void warning(String message) => log(LogLevel.warning, message);
  static void error(String message, {dynamic error, StackTrace? stackTrace}) =>
      log(LogLevel.error, message, error: error, stackTrace: stackTrace);

  static Future<void> _saveLog(LogEntry entry) async {
    List<String> logs = _prefs.getStringList(_logKey) ?? [];
    logs.add(jsonEncode(entry.toJson()));
    if (logs.length > _maxLogEntries) {
      logs = logs.sublist(logs.length - _maxLogEntries);
    }
    await _prefs.setStringList(_logKey, logs);
  }

  static Future<List<LogEntry>> getLogs() async {
    final logs = _prefs.getStringList(_logKey) ?? [];
    return logs.map((log) => LogEntry.fromJson(jsonDecode(log))).toList();
  }

  static Future<void> clearLogs() async {
    await _prefs.remove(_logKey);
  }
}