import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartWidget extends StatefulWidget {
  final double temperature;
  final double pressure;
  final double gasFlowRate;

  const ChartWidget({
    Key? key,
    required this.temperature,
    required this.pressure,
    required this.gasFlowRate,
  }) : super(key: key);

  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  List<FlSpot> temperatureData = [];
  List<FlSpot> pressureData = [];
  List<FlSpot> flowRateData = [];
  int xValue = 0;

  @override
  void didUpdateWidget(ChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateData();
  }

  void _updateData() {
    setState(() {
      xValue++;
      temperatureData.add(FlSpot(xValue.toDouble(), widget.temperature));
      pressureData.add(FlSpot(xValue.toDouble(), widget.pressure / 1000)); // Divide by 1000 to scale
      flowRateData.add(FlSpot(xValue.toDouble(), widget.gasFlowRate));

      if (temperatureData.length > 20) {
        temperatureData.removeAt(0);
        pressureData.removeAt(0);
        flowRateData.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: temperatureData,
              isCurved: true,
              color: Colors.red,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: pressureData,
              isCurved: true,
              color: Colors.blue,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: flowRateData,
              isCurved: true,
              color: Colors.green,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          titlesData: const FlTitlesData(
            bottomTitles: AxisTitles(
                sideTitles:
                  SideTitles(
                    showTitles: true,
                  ),
            ),

            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  // ... other properties
                )
            ),
            topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  // ... other properties
                )
            ),
            rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  // ... other properties
                )
            ),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }
}