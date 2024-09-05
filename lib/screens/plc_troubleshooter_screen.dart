import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';

class PLCTroubleshooterScreen extends StatefulWidget {
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
        title: Text('PLC Troubleshooter'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
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
        label: Text('Diagnose'),
        icon: Icon(Icons.search),
        tooltip: 'Diagnose',
      ),
    );
  }

  Widget _buildErrorIndicator(String component, bool hasError) {
    final Map<String, Offset> componentPositions = {
      'N2Generator': Offset(50, 100),
      'MFC': Offset(200, 100),
      'Heater': Offset(350, 80),
      'Chamber': Offset(550, 100),
      'Trap': Offset(800, 100),
    };

    if (!hasError) return SizedBox.shrink();

    return Positioned(
      left: componentPositions[component]!.dx,
      top: componentPositions[component]!.dy,
      child: GestureDetector(
        onTap: () => _showErrorDetails(component),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: Center(
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
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 10),
            Text('Error in $component'),
          ],
        ),
        content: Text(
          errorReasons[component] ?? 'Unknown error',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        actions: [
          TextButton(
            child: Text(
              'Close',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              textStyle: TextStyle(fontWeight: FontWeight.bold),
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
          title: Text('Component Status'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Timestamp: $timestamp'),
                SizedBox(height: 10),
                ...componentErrors.entries.map((entry) {
                  final status = entry.value ? 'Error' : 'No Error';
                  final reason = entry.value ? 'Reason: ${errorReasons[entry.key] ?? "Unknown error"}' : '';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${entry.key}: $status', style: TextStyle(fontSize: 16, color: Colors.black87)),
                        if (reason.isNotEmpty) Text(reason, style: TextStyle(fontSize: 14, color: Colors.black54)),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                textStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}