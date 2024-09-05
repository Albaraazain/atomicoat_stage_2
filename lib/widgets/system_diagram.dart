import 'package:flutter/material.dart';

class SystemDiagram extends StatelessWidget {
  final Function(String) onComponentClick;

  const SystemDiagram({Key? key, required this.onComponentClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;

        return Stack(
          children: [
            // Main pipeline
            Positioned(
              left: width * 0.05,
              top: height * 0.2,
              right: width * 0.05,
              child: Container(height: 2, color: Colors.black),
            ),

            // Components on the main line
            _buildComponent(width, height, 'n2gen', 'N2\nGEN', 0.05, 0.15, 0.08, 0.1, Colors.blue[100]!),
            _buildComponent(width, height, 'mfc', 'MFC', 0.18, 0.15, 0.08, 0.1, Colors.green[100]!),
            _buildComponent(width, height, 'frontline_heater', 'Frontline\nHeater', 0.31, 0.15, 0.23, 0.1, Colors.orange[100]!),
            _buildComponent(width, height, 'chamber', 'CHAMBER', 0.59, 0.15, 0.13, 0.1, Colors.purple[100]!),
            _buildComponent(width, height, 'backline_heater', 'Back', 0.77, 0.15, 0.08, 0.1, Colors.orange[100]!),
            _buildComponent(width, height, 'pc', 'PC', 0.88, 0.15, 0.05, 0.1, Colors.cyan[100]!),
            _buildComponent(width, height, 'pump', 'PU', 0.95, 0.15, 0.05, 0.1, Colors.indigo[100]!),

            // Connections from Frontline Heater to valves
            _buildConnection(width, height, 0.385, 0.25, 0.385, 0.4),
            _buildConnection(width, height, 0.465, 0.25, 0.465, 0.4),

            // Valves
            _buildValve(width, height, 'v1', 'V1', 0.36, 0.4),
            _buildValve(width, height, 'v2', 'V2', 0.44, 0.4),

            // Connections from valves to heaters
            _buildConnection(width, height, 0.385, 0.53, 0.465, 0.6),
            _buildConnection(width, height, 0.465, 0.53, 0.465, 0.6),

            // Heaters
            _buildComponent(width, height, 'h1', 'H1', 0.34, 0.6, 0.09, 0.08, Colors.red[100]!),
            _buildComponent(width, height, 'h2', 'H2', 0.42, 0.6, 0.09, 0.08, Colors.red[100]!),
          ],
        );
      },
    );
  }

  Widget _buildComponent(double width, double height, String id, String label, double x, double y, double widthFactor, double heightFactor, Color color) {
    return Positioned(
      left: width * x,
      top: height * y,
      child: GestureDetector(
        onTap: () => onComponentClick(id),
        child: Container(
          width: width * widthFactor,
          height: height * heightFactor,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildValve(double width, double height, String id, String label, double x, double y) {
    return Positioned(
      left: width * x,
      top: height * y,
      child: GestureDetector(
        onTap: () => onComponentClick(id),
        child: Container(
          width: width * 0.05,
          height: width * 0.05,
          decoration: BoxDecoration(
            color: Colors.green[100],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnection(double width, double height, double startX, double startY, double endX, double endY) {
    return Positioned(
      left: width * startX,
      top: height * startY,
      child: Container(
        width: 2,
        height: height * (endY - startY),
        color: Colors.black,
      ),
    );
  }
}