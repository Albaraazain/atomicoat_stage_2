import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/models.dart';
import 'system_component.dart';

class SystemDiagram extends StatefulWidget {
  final SystemState systemState;
  final Function(String) onComponentClick;

  const SystemDiagram({
    Key? key,
    required this.systemState,
    required this.onComponentClick,
  }) : super(key: key);

  @override
  _SystemDiagramState createState() => _SystemDiagramState();
}

class _SystemDiagramState extends State<SystemDiagram> {
  final TransformationController _transformationController = TransformationController();
  String? hoveredComponent;

  final List<Map<String, dynamic>> components = [
    {'id': 'heater', 'name': 'Heater', 'position': Offset(100, 100)},
    {'id': 'pump', 'name': 'Pump', 'position': Offset(200, 200)},
    {'id': 'valve', 'name': 'Valve', 'position': Offset(300, 300)},
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onDoubleTap: _handleDoubleTap,
          child: InteractiveViewer(
            transformationController: _transformationController,
            boundaryMargin: EdgeInsets.all(double.infinity),
            minScale: 0.5,
            maxScale: 4.0,
            child: Stack(
              children: [
                SvgPicture.asset(
                  'assets/images/system_diagram.svg',
                  width: 600,
                  height: 400,
                ),
                ...components.map((component) => SystemComponent(
                  id: component['id'],
                  name: component['name'],
                  position: component['position'],
                  isActive: widget.systemState.isComponentActive(component['id']),
                  onTap: () => widget.onComponentClick(component['id']),
                  onHover: () => setState(() => hoveredComponent = component['id']),
                  onHoverExit: () => setState(() => hoveredComponent = null),
                )),
              ],
            ),
          ),
        ),
        if (hoveredComponent != null)
          Positioned(
            left: 10,
            top: 10,
            child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.black.withOpacity(0.7),
              child: Text(
                'Component: $hoveredComponent',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        Positioned(
          right: 16,
          bottom: 16,
          child: Column(
            children: [
              FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => _handleZoom(1.2),
                mini: true,
              ),
              SizedBox(height: 8),
              FloatingActionButton(
                child: Icon(Icons.remove),
                onPressed: () => _handleZoom(0.8),
                mini: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleZoom(double scale) {
    final zoom = _transformationController.value.scaled(scale);
    _transformationController.value = zoom;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      _transformationController.value = Matrix4.identity()..scale(2.0);
    }
  }
}