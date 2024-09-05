import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PLCImageScreen extends StatefulWidget {
  const PLCImageScreen({super.key});

  @override
  _PLCImageScreenState createState() => _PLCImageScreenState();
}

class _PLCImageScreenState extends State<PLCImageScreen> {
  final Map<String, double> plcValues = {
    'Temperature': 25.5,
    'Pressure': 101.3,
    'Flow Rate': 50.0,
  };

  final List<Offset> valvePositions = [
    const Offset(252, 180),
    const Offset(266, 180),
    const Offset(110, 225),
    const Offset(155, 225),
    const Offset(110, 245),
    const Offset(155, 245),
  ];

  List<bool> valveStates = List.generate(6, (index) => false);

  void _startMachine() {
    setState(() {
      for (int i = 0; i < valveStates.length; i++) {
        valveStates[i] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagram View'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: SvgPicture.asset(
                    "assets/images/MFC.svg",
                    fit: BoxFit.contain,
                  ),
                ),
                CustomPaint(
                  painter: ValveIndicatorPainter(valvePositions, valveStates),
                  child: Container(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              onPressed: _startMachine,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Start Machine'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleImageTap(BuildContext context, TapUpDetails details) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PLC Values'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: plcValues.entries.map((entry) =>
              Text('${entry.key}: ${entry.value}')
          ).toList(),
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class ValveIndicatorPainter extends CustomPainter {
  final List<Offset> valvePositions;
  final List<bool> valveStates;

  ValveIndicatorPainter(this.valvePositions, this.valveStates);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < valvePositions.length; i++) {
      if (valveStates[i]) {
        _drawGlowingCircle(canvas, valvePositions[i], Colors.green);
      } else {
        final paint = Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill;
        canvas.drawCircle(valvePositions[i], 3, paint);
      }
    }
  }

  void _drawGlowingCircle(Canvas canvas, Offset center, Color color) {
    final List<double> opacities = [0.1, 0.2, 0.3, 0.4, 0.6, 0.8, 1.0];
    final List<double> radiuses = [8, 7, 6, 5, 4, 3, 2];

    for (int i = 0; i < opacities.length; i++) {
      final paint = Paint()
        ..color = color.withOpacity(opacities[i])
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radiuses[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}