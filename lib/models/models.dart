class SystemState {
  final double temperature;
  final double pressure;
  final double gasFlowRate;
  final double substrateRotationSpeed;
  final bool isRunning;

  SystemState({
    this.temperature = 25.0,
    this.pressure = 101325.0,
    this.gasFlowRate = 100.0,
    this.substrateRotationSpeed = 0.0,
    this.isRunning = false,
  });

  SystemState copyWith({
    double? temperature,
    double? pressure,
    double? gasFlowRate,
    double? substrateRotationSpeed,
    bool? isRunning,
  }) {
    return SystemState(
      temperature: temperature ?? this.temperature,
      pressure: pressure ?? this.pressure,
      gasFlowRate: gasFlowRate ?? this.gasFlowRate,
      substrateRotationSpeed: substrateRotationSpeed ?? this.substrateRotationSpeed,
      isRunning: isRunning ?? this.isRunning,
    );
  }

  Map<String, dynamic> toJson() => {
    'temperature': temperature,
    'pressure': pressure,
    'gasFlowRate': gasFlowRate,
    'substrateRotationSpeed': substrateRotationSpeed,
    'isRunning': isRunning,
  };

  factory SystemState.fromJson(Map<String, dynamic> json) => SystemState(
    temperature: json['temperature'],
    pressure: json['pressure'],
    gasFlowRate: json['gasFlowRate'],
    substrateRotationSpeed: json['substrateRotationSpeed'],
    isRunning: json['isRunning'],
  );
}

class UserProfile {
  final String name;
  final String role;

  UserProfile({required this.name, required this.role});

  Map<String, dynamic> toJson() => {
    'name': name,
    'role': role,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'],
    role: json['role'],
  );
}

class AppSettings {
  final String language;

  AppSettings({this.language = 'English'});

  AppSettings copyWith({String? language}) {
    return AppSettings(language: language ?? this.language);
  }

  Map<String, dynamic> toJson() => {
    'language': language,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    language: json['language'],
  );
}