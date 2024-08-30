import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../widgets/parameter_input.dart';
import '../widgets/system_diagram.dart';
import '../widgets/component_detail_dialog.dart';
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ComponentDetailDialog(
          componentId: componentId,
          systemState: appState.systemState,
          onToggleComponent: (id) {
            appState.toggleComponentStatus(id);
            Navigator.of(context).pop();
          },
        );
      },
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
          return Column(
            children: [
              _buildSystemStatusIndicator(appState),
              Expanded(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: _showDiagram
                      ? SystemDiagram(
                    key: ValueKey('diagram'),
                    systemState: appState.systemState,
                    onComponentClick: (componentId) => _handleComponentClick(context, componentId),
                  )
                      : _buildStandardView(appState),
                ),
              ),
              _buildSystemControlButton(appState),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSystemStatusIndicator(AppStateProvider appState) {
    return Container(
      padding: EdgeInsets.all(8),
      color: appState.systemState.isRunning ? Colors.green : Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            appState.systemState.isRunning ? Icons.check_circle : Icons.error,
            color: Colors.white,
          ),
          SizedBox(width: 8),
          Text(
            appState.systemState.isRunning ? 'System Running' : 'System Stopped',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardView(AppStateProvider appState) {
    return Form(
      key: _formKey,
      child: ListView(
        key: ValueKey('standard'),
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildControlSection('Temperature Controls', [
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
          ]),
          SizedBox(height: 16),
          _buildControlSection('Pressure Controls', [
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
          ]),
          SizedBox(height: 16),
          _buildControlSection('Flow Controls', [
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
          ]),
          SizedBox(height: 16),
          _buildFeatures(),
          SizedBox(height: 16),
          _buildPresetConfigurations(),
        ],
      ),
    );
  }

  Widget _buildControlSection(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildFeatures() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Features', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• Real-time input validation'),
            Text('• Unit conversion (°C/°F, kPa/psi)'),
            Text('• Preset configurations'),
            Text('• Safety interlocks'),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetConfigurations() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Preset Configurations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(onPressed: () {}, child: Text('Low Temp Coat')),
                ElevatedButton(onPressed: () {}, child: Text('High Temp Coat')),
                ElevatedButton(onPressed: () {}, child: Text('Purge Cycle')),
                ElevatedButton(onPressed: () {}, child: Text('Custom Preset 1')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemControlButton(AppStateProvider appState) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        child: Text(appState.systemState.isRunning ? 'Stop System' : 'Start System'),
        style: ElevatedButton.styleFrom(
          backgroundColor: appState.systemState.isRunning ? Colors.red : Colors.green,
          minimumSize: Size(double.infinity, 50),
        ),
        onPressed: () {
          if (_showDiagram) {
            // In diagram view, just toggle the system state
            appState.toggleSystemRunning();
          } else {
            // In standard view, validate the form before toggling
            if (_formKey.currentState != null && _formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              appState.toggleSystemRunning();
            }
          }
        },
      ),
    );
  }
}