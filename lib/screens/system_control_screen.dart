import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../widgets/parameter_input.dart';
import '../utils/validators.dart';

class SystemControlScreen extends StatefulWidget {
  const SystemControlScreen({Key? key}) : super(key: key);

  @override
  _SystemControlScreenState createState() => _SystemControlScreenState();
}

class _SystemControlScreenState extends State<SystemControlScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Control'),
      ),
      body: Consumer<AppStateProvider>(
        builder: (context, appState, child) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                ParameterInput(
                  label: 'Temperature (°C)',
                  initialValue: appState.systemState.temperature.toString(),
                  validator: validateTemperature,
                  onSaved: (value) {
                    if (value != null) {
                      appState.updateSystemState(appState.systemState.copyWith(
                        temperature: double.parse(value),
                      ));
                    }
                  },
                ),
                const SizedBox(height: 16),
                ParameterInput(
                  label: 'Pressure (Pa)',
                  initialValue: appState.systemState.pressure.toString(),
                  validator: validatePressure,
                  onSaved: (value) {
                    if (value != null) {
                      appState.updateSystemState(appState.systemState.copyWith(
                        pressure: double.parse(value),
                      ));
                    }
                  },
                ),
                const SizedBox(height: 16),
                ParameterInput(
                  label: 'Gas Flow Rate (sccm)',
                  initialValue: appState.systemState.gasFlowRate.toString(),
                  validator: validateFlowRate,
                  onSaved: (value) {
                    if (value != null) {
                      appState.updateSystemState(appState.systemState.copyWith(
                        gasFlowRate: double.parse(value),
                      ));
                    }
                  },
                ),
                const SizedBox(height: 16),
                ParameterInput(
                  label: 'Substrate Rotation Speed (rpm)',
                  initialValue: appState.systemState.substrateRotationSpeed.toString(),
                  validator: validateRotationSpeed,
                  onSaved: (value) {
                    if (value != null) {
                      appState.updateSystemState(appState.systemState.copyWith(
                        substrateRotationSpeed: double.parse(value),
                      ));
                    }
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  child: Text(appState.systemState.isRunning ? 'Stop System' : 'Start System'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      appState.updateSystemState(appState.systemState.copyWith(
                        isRunning: !appState.systemState.isRunning,
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appState.systemState.isRunning ? Colors.red : Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'System Status: ${appState.systemState.isRunning ? "Running" : "Stopped"}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}