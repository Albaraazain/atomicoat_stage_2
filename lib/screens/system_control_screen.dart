import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../widgets/parameter_input.dart';
import '../widgets/system_diagram.dart';
import '../utils/validators.dart';

class SystemControlScreen extends StatefulWidget {
  const SystemControlScreen({Key? key}) : super(key: key);

  @override
  _SystemControlScreenState createState() => _SystemControlScreenState();
}

class _SystemControlScreenState extends State<SystemControlScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _showDiagram = true;

  void _handleComponentClick(BuildContext context, String componentId) {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    appState.toggleComponentStatus(componentId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Toggled $componentId'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Control'),
        actions: [
          IconButton(
            icon: Icon(_showDiagram ? Icons.list : Icons.image),
            onPressed: () {
              setState(() {
                _showDiagram = !_showDiagram;
              });
            },
          ),
        ],
      ),
      body: Consumer<AppStateProvider>(
        builder: (context, appState, child) {
          return _showDiagram
              ? SystemDiagram(
            systemState: appState.systemState,
            onComponentClick: (componentId) => _handleComponentClick(context, componentId),
          )
              : Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                ParameterInput(
                  label: 'Temperature (°C)',
                  initialValue: appState.systemState.temperature.toStringAsFixed(2),
                  validator: validateTemperature,
                  onSaved: (value) {
                    if (value != null) {
                      appState.updateSystemState(appState.systemState.copyWith(
                        temperature: double.parse(value),
                      ));
                    }
                  },
                ),
                SizedBox(height: 16),
                ParameterInput(
                  label: 'Pressure (Pa)',
                  initialValue: appState.systemState.pressure.toStringAsFixed(2),
                  validator: validatePressure,
                  onSaved: (value) {
                    if (value != null) {
                      appState.updateSystemState(appState.systemState.copyWith(
                        pressure: double.parse(value),
                      ));
                    }
                  },
                ),
                SizedBox(height: 16),
                ParameterInput(
                  label: 'Gas Flow Rate (sccm)',
                  initialValue: appState.systemState.gasFlowRate.toStringAsFixed(2),
                  validator: validateFlowRate,
                  onSaved: (value) {
                    if (value != null) {
                      appState.updateSystemState(appState.systemState.copyWith(
                        gasFlowRate: double.parse(value),
                      ));
                    }
                  },
                ),
                SizedBox(height: 16),
                ParameterInput(
                  label: 'Substrate Rotation Speed (rpm)',
                  initialValue: appState.systemState.substrateRotationSpeed.toStringAsFixed(2),
                  validator: validateRotationSpeed,
                  onSaved: (value) {
                    if (value != null) {
                      appState.updateSystemState(appState.systemState.copyWith(
                        substrateRotationSpeed: double.parse(value),
                      ));
                    }
                  },
                ),
                SizedBox(height: 20),
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}