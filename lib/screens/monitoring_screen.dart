import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../models/models.dart';
import '../providers/app_state_provider.dart';
import '../widgets/chart_widget.dart';
import '../widgets/status_indicator.dart';
import '../models/system_state.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({Key? key}) : super(key: key);

  @override
  _MonitoringScreenState createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  List<Map<String, dynamic>> _events = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) => _updateParameters());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateParameters() {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final currentState = appState.systemState;

    // Simulate parameter changes
    final newState = SystemState(
      temperature: currentState.temperature + (Random().nextDouble() - 0.5),
      pressure: currentState.pressure + (Random().nextDouble() - 0.5) * 1000,
      gasFlowRate: currentState.gasFlowRate + (Random().nextDouble() - 0.5) * 10,
      substrateRotationSpeed: currentState.substrateRotationSpeed,
      isRunning: currentState.isRunning,
    );

    appState.updateSystemState(newState);

    setState(() {
      _events.insert(0, {
        'timestamp': DateTime.now(),
        'message': 'Parameters updated',
        'details': 'Temp: ${newState.temperature.toStringAsFixed(2)}°C, '
            'Pressure: ${newState.pressure.toStringAsFixed(2)} Pa, '
            'Flow: ${newState.gasFlowRate.toStringAsFixed(2)} sccm'
      });
      if (_events.length > 50) _events.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('System Monitoring'),
        ),
        body: Consumer<AppStateProvider>(
        builder: (context, appState, child) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
      Padding(
      padding: EdgeInsets.all(16.0),
    child: StatusIndicator(status: appState.systemState.isRunning ? 'Running' : 'Stopped'),
    ),
    Expanded(
    flex: 2,
    child: ChartWidget(
    temperature: appState.systemState.temperature,
    pressure: appState.systemState.pressure,
      gasFlowRate: appState.systemState.gasFlowRate,
    ),
    ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Recent Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  final event = _events[index];
                  return ListTile(
                    title: Text(event['message']),
                    subtitle: Text(event['details']),
                    trailing: Text(
                      '${event['timestamp'].hour}:${event['timestamp'].minute}:${event['timestamp'].second}',
                      style: TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
            ),
          ],
      );
        },
        ),
    );
  }
}