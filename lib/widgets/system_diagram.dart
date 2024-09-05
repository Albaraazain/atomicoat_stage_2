import 'package:flutter/material.dart';

class SystemDiagram extends StatelessWidget {
  final Function(String) onComponentClick;

  const SystemDiagram({Key? key, required this.onComponentClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Main pipeline
            Positioned(
              left: constraints.maxWidth * 0.05,
              top: constraints.maxHeight * 0.2,
              right: constraints.maxWidth * 0.05,
              child: Container(
                height: 2,
                color: Colors.black,
              ),
            ),

            // N2 GEN
            _buildComponent(constraints, 'n2gen', 'N2\nGEN', 0.05, 0.15, Colors.blue[100]!, width: 0.1, height: 0.1),

            // MFC
            _buildComponent(constraints, 'mfc', 'MFC', 0.2, 0.15, Colors.green[100]!, width: 0.1, height: 0.1),

            // Frontline Heater
            _buildComponent(constraints, 'frontline_heater', 'Frontline\nHeater', 0.35, 0.15, Colors.orange[100]!, width: 0.25, height: 0.1),

            // CHAMBER
            _buildComponent(constraints, 'chamber', 'CHAMBER', 0.65, 0.15, Colors.purple[100]!, width: 0.15, height: 0.1),

            // PC
            _buildComponent(constraints, 'pc', 'PC', 0.85, 0.15, Colors.cyan[100]!, width: 0.05, height: 0.1),

            // PU (Pump)
            _buildComponent(constraints, 'pump', 'PU', 0.95, 0.15, Colors.indigo[100]!, width: 0.05, height: 0.1),

            // Connections from Frontline Heater to valves
            _buildConnection(constraints, 0.425, 0.25, 0.425, 0.35),
            _buildConnection(constraints, 0.575, 0.25, 0.575, 0.35),

            // Valves
            _buildValve(constraints, 'v1', 'V1', 0.4, 0.35),
            _buildValve(constraints, 'v2', 'V2', 0.55, 0.35),

            // Connections from valves to heaters
            _buildConnection(constraints, 0.425, 0.4, 0.425, 0.5),
            _buildConnection(constraints, 0.575, 0.4, 0.575, 0.5),

            // Heaters
            _buildComponent(constraints, 'h1', 'H1', 0.375, 0.5, Colors.red[100]!, width: 0.1, height: 0.08),
            _buildComponent(constraints, 'h2', 'H2', 0.525, 0.5, Colors.red[100]!, width: 0.1, height: 0.08),

            // Connection to Back heater
            _buildConnection(constraints, 0.8, 0.25, 0.8, 0.35),

            // Back (Backline Heater)
            _buildComponent(constraints, 'backline_heater', 'Back', 0.75, 0.35, Colors.orange[100]!, width: 0.1, height: 0.08),
          ],
        );
      },
    );
  }

  Widget _buildComponent(BoxConstraints constraints, String id, String label, double x, double y, Color color, {required double width, required double height}) {
    return Positioned(
      left: constraints.maxWidth * x,
      top: constraints.maxHeight * y,
      child: GestureDetector(
        onTap: () => onComponentClick(id),
        child: Container(
          width: constraints.maxWidth * width,
          height: constraints.maxHeight * height,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildValve(BoxConstraints constraints, String id, String label, double x, double y) {
    return Positioned(
      left: constraints.maxWidth * x,
      top: constraints.maxHeight * y,
      child: GestureDetector(
        onTap: () => onComponentClick(id),
        child: Container(
          width: constraints.maxWidth * 0.05,
          height: constraints.maxWidth * 0.05,
          decoration: BoxDecoration(
            color: Colors.green[100],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnection(BoxConstraints constraints, double startX, double startY, double endX, double endY) {
    return Positioned(
      left: constraints.maxWidth * startX,
      top: constraints.maxHeight * startY,
      child: Container(
        width: 2,
        height: constraints.maxHeight * (endY - startY),
        color: Colors.black,
      ),
    );
  }
}