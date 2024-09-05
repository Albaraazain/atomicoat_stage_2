class SystemState {
  final double temperature;
  final double pressure;
  final double gasFlowRate;
  final double substrateRotationSpeed;
  final bool isRunning;
  final Map<String, bool> componentStatus;
  final Map<String, double> componentTemperatures;
  final Map<String, double> componentSetTemperatures;

  SystemState({
    this.temperature = 25.0,
    this.pressure = 101325.0,
    this.gasFlowRate = 100.0,
    this.substrateRotationSpeed = 0.0,
    this.isRunning = false,
    Map<String, bool> componentStatus = const {},
    Map<String, double> componentTemperatures = const {},
    Map<String, double> componentSetTemperatures = const {},
  }) : this.componentStatus = {
    'heater': false,
    'pump': false,
    'valve': false,
    ...componentStatus,
  },
        this.componentTemperatures = {
          'frontline_heater': 25.0,
          'h1': 25.0,
          'h2': 32.0,
          'backline_heater': 25.0,
          ...componentTemperatures,
        },
        this.componentSetTemperatures = {
          'frontline_heater': 25.0,
          'h1': 25.0,
          'h2': 32.0,
          'backline_heater': 25.0,
          ...componentSetTemperatures,
        };

  bool isComponentActive(String componentId) {
    return componentStatus[componentId] ?? false;
  }

  double getComponentTemperature(String componentId) {
    return componentTemperatures[componentId] ?? 0.0;
  }

  double getComponentSetTemperature(String componentId) {
    return componentSetTemperatures[componentId] ?? 0.0;
  }

  SystemState copyWith({
    double? temperature,
    double? pressure,
    double? gasFlowRate,
    double? substrateRotationSpeed,
    bool? isRunning,
    Map<String, bool>? componentStatus,
    Map<String, double>? componentTemperatures,
    Map<String, double>? componentSetTemperatures,
  }) {
    return SystemState(
      temperature: temperature ?? this.temperature,
      pressure: pressure ?? this.pressure,
      gasFlowRate: gasFlowRate ?? this.gasFlowRate,
      substrateRotationSpeed: substrateRotationSpeed ?? this.substrateRotationSpeed,
      isRunning: isRunning ?? this.isRunning,
      componentStatus: componentStatus ?? this.componentStatus,
      componentTemperatures: componentTemperatures ?? this.componentTemperatures,
      componentSetTemperatures: componentSetTemperatures ?? this.componentSetTemperatures,
    );
  }

  Map<String, dynamic> toJson() => {
    'temperature': temperature,
    'pressure': pressure,
    'gasFlowRate': gasFlowRate,
    'substrateRotationSpeed': substrateRotationSpeed,
    'isRunning': isRunning,
    'componentStatus': componentStatus,
    'componentTemperatures': componentTemperatures,
    'componentSetTemperatures': componentSetTemperatures,
  };

  factory SystemState.fromJson(Map<String, dynamic> json) => SystemState(
    temperature: json['temperature'],
    pressure: json['pressure'],
    gasFlowRate: json['gasFlowRate'],
    substrateRotationSpeed: json['substrateRotationSpeed'],
    isRunning: json['isRunning'],
    componentStatus: Map<String, bool>.from(json['componentStatus']),
    componentTemperatures: Map<String, double>.from(json['componentTemperatures']),
    componentSetTemperatures: Map<String, double>.from(json['componentSetTemperatures']),
  );

  get n2GenFlowRate => 30.1;

  get n2GenPurity => 30.4;
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