import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class PLCTroubleshooterScreen extends StatefulWidget {
  const PLCTroubleshooterScreen({super.key});

  @override
  _PLCTroubleshooterScreenState createState() => _PLCTroubleshooterScreenState();
}

class _PLCTroubleshooterScreenState extends State<PLCTroubleshooterScreen> {
  Map<String, bool> componentErrors = {
    'N2Generator': false,
    'MFC': false,
    'Heater': true,
    'Chamber': false,
    'Trap': false,
  };

  Map<String, String> errorReasons = {
    'Heater': 'Temperature exceeds normal range',
  };

  bool showErrors = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PLC Troubleshooter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showComponentStatusDialog,
            tooltip: 'Show Component Status',
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Stack(
            children: [
              SvgPicture.asset(
                'assets/images/MFC.svg',
                width: MediaQuery.of(context).size.width * 0.9,
              ),
              if (showErrors)
                ...componentErrors.entries.map((entry) {
                  return _buildErrorIndicator(entry.key, entry.value);
                }).toList(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            showErrors = true;
          });
        },
        label: const Text('Diagnose'),
        icon: const Icon(Icons.search),
        tooltip: 'Diagnose',
      ),
    );
  }

  Widget _buildErrorIndicator(String component, bool hasError) {
    final Map<String, Offset> componentPositions = {
      'N2Generator': const Offset(50, 100),
      'MFC': const Offset(200, 100),
      'Heater': const Offset(350, 80),
      'Chamber': const Offset(550, 100),
      'Trap': const Offset(800, 100),
    };

    if (!hasError) return const SizedBox.shrink();

    return Positioned(
      left: componentPositions[component]!.dx,
      top: componentPositions[component]!.dy,
      child: GestureDetector(
        onTap: () => _showErrorDetails(component),
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              'Error',
              style: TextStyle(color: Colors.white, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDetails(String component) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 10),
            Text('Error in $component'),
          ],
        ),
        content: Text(
          errorReasons[component] ?? 'Unknown error',
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showComponentStatusDialog() {
    final String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: const Text('Component Status'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Timestamp: $timestamp'),
                const SizedBox(height: 10),
                ...componentErrors.entries.map((entry) {
                  final status = entry.value ? 'Error' : 'No Error';
                  final reason = entry.value ? 'Reason: ${errorReasons[entry.key] ?? "Unknown error"}' : '';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${entry.key}: $status', style: const TextStyle(fontSize: 16, color: Colors.black87)),
                        if (reason.isNotEmpty) Text(reason, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: Text(
                'Close',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}