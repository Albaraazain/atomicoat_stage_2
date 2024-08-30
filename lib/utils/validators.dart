String? validateTemperature(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a temperature';
  }
  final temperature = double.tryParse(value);
  if (temperature == null) {
    return 'Please enter a valid number';
  }
  if (temperature < 0 || temperature > 1000) {
    return 'Temperature must be between 0°C and 1000°C';
  }
  return null;
}

String? validatePressure(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a pressure';
  }
  final pressure = double.tryParse(value);
  if (pressure == null) {
    return 'Please enter a valid number';
  }
  if (pressure < 0 || pressure > 1000000) {
    return 'Pressure must be between 0 Pa and 1,000,000 Pa';
  }
  return null;
}

String? validateFlowRate(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a flow rate';
  }
  final flowRate = double.tryParse(value);
  if (flowRate == null) {
    return 'Please enter a valid number';
  }
  if (flowRate < 0 || flowRate > 1000) {
    return 'Flow rate must be between 0 sccm and 1000 sccm';
  }
  return null;
}

String? validateRotationSpeed(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a rotation speed';
  }
  final speed = double.tryParse(value);
  if (speed == null) {
    return 'Please enter a valid number';
  }
  if (speed < 0 || speed > 1000) {
    return 'Rotation speed must be between 0 rpm and 1000 rpm';
  }
  return null;
}