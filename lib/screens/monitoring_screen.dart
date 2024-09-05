import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../models/models.dart';
import '../providers/app_state_provider.dart';
import '../widgets/status_indicator.dart';
import 'package:fl_chart/fl_chart.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({Key? key}) : super(key: key);

  @override
  _MonitoringScreenState createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  final List<Map<String, dynamic>> _events = [];
  late Timer _timer;
  List<FlSpot> temperatureData = [];
  List<FlSpot> pressureData = [];
  List<FlSpot> flowRateData = [];
  int xValue = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => _updateParameters());
  }

  void _initializeData() {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final currentState = appState.systemState;

    for (int i = 0; i < 60; i++) {
      temperatureData.add(FlSpot(i.toDouble(), currentState.temperature));
      pressureData.add(FlSpot(i.toDouble(), currentState.pressure / 10000)); // Scale down pressure
      flowRateData.add(FlSpot(i.toDouble(), currentState.gasFlowRate));
    }
    xValue = 59;
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
      temperature: max(0, min(100, currentState.temperature + (Random().nextDouble() - 0.5) * 5)),
      pressure: max(0, min(1000000, currentState.pressure + (Random().nextDouble() - 0.5) * 10000)),
      gasFlowRate: max(0, min(200, currentState.gasFlowRate + (Random().nextDouble() - 0.5) * 10)),
      substrateRotationSpeed: currentState.substrateRotationSpeed,
      isRunning: currentState.isRunning,
    );

    appState.updateSystemState(newState);

    setState(() {
      xValue++;
      temperatureData.add(FlSpot(xValue.toDouble(), newState.temperature));
      pressureData.add(FlSpot(xValue.toDouble(), newState.pressure / 10000)); // Scale down pressure
      flowRateData.add(FlSpot(xValue.toDouble(), newState.gasFlowRate));

      if (temperatureData.length > 60) {
        temperatureData.removeAt(0);
        pressureData.removeAt(0);
        flowRateData.removeAt(0);
      }

      _events.insert(0, {
        'timestamp': DateTime.now(),
        'message': 'Parameters updated',
        'details': 'Temp: ${newState.temperature.toStringAsFixed(2)}°C, '
            'Pressure: ${(newState.pressure / 1000).toStringAsFixed(2)} kPa, '
            'Flow: ${newState.gasFlowRate.toStringAsFixed(2)} sccm'
      });
      if (_events.length > 50) _events.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('System Monitoring', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<AppStateProvider>(
        builder: (context, appState, child) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StatusIndicator(status: appState.systemState.isRunning ? 'Running' : 'Stopped'),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      children: [
                        Expanded(child: _buildChart()),
                        _buildLegend(),
                      ],
                    ),
                  ),
                ),
                const Padding(
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
                        title: Text(event['message'], style: const TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: Text(event['details'], style: const TextStyle(fontSize: 12)),
                        trailing: Text(
                          '${event['timestamp'].hour.toString().padLeft(2, '0')}:${event['timestamp'].minute.toString().padLeft(2, '0')}:${event['timestamp'].second.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChart() {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true, drawVerticalLine: true),
        titlesData: FlTitlesData(
          bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString(),
                    style: const TextStyle(color: Colors.grey, fontSize: 10));
              },
              reservedSize: 30,
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        minX: xValue - 59.0,
        maxX: xValue.toDouble(),
        minY: 0,
        maxY: 120,  // Adjusted to accommodate all data
        lineBarsData: [
          LineChartBarData(
            spots: temperatureData,
            isCurved: true,
            color: Colors.red,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: pressureData,
            isCurved: true,
            color: Colors.blue,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: flowRateData,
            isCurved: true,
            color: Colors.green,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendItem('Temp (°C)', Colors.red),
          const SizedBox(width: 16),
          _buildLegendItem('Pressure (x10 kPa)', Colors.blue),
          const SizedBox(width: 16),
          _buildLegendItem('Flow (sccm)', Colors.green),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}