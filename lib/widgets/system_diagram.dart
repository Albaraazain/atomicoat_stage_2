import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
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

class _SystemDiagramState extends State<SystemDiagram> with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  String? hoveredComponent;
  double _currentScale = 1.0;
  final double _minScale = 0.5;
  final double _maxScale = 4.0;

  final List<Map<String, dynamic>> components = [
    {'id': 'heater', 'name': 'Heater', 'position': Offset(0.2, 0.2)},
    {'id': 'pump', 'name': 'Pump', 'position': Offset(0.4, 0.4)},
    {'id': 'valve', 'name': 'Valve', 'position': Offset(0.6, 0.6)},
  ];

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..addListener(() {
      if (_animation != null) {
        _transformationController.value = _animation!.value;
      }
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _animateResetView() {
    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));
    _animationController.forward(from: 0);
    setState(() {
      _currentScale = 1.0;
    });
  }

  void _handleZoom(double scale) {
    final nextScale = _currentScale * scale;
    if (nextScale < _minScale || nextScale > _maxScale) return;

    final Offset center = Offset(
      constraints.maxWidth / 2,
      constraints.maxHeight / 2,
    );

    final Matrix4 matrix = Matrix4.identity()
      ..translate(center.dx, center.dy)
      ..scale(scale)
      ..translate(-center.dx, -center.dy);

    final Matrix4 nextMatrix = matrix * _transformationController.value;

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: nextMatrix,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward(from: 0);

    setState(() {
      _currentScale = nextScale;
    });
  }

  late BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        this.constraints = constraints;
        final diagramWidth = constraints.maxWidth;
        final diagramHeight = constraints.maxHeight;

        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              GestureDetector(
                onDoubleTap: _animateResetView,
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  boundaryMargin: EdgeInsets.all(double.infinity),
                  minScale: _minScale,
                  maxScale: _maxScale,
                  onInteractionEnd: (details) {
                    setState(() {
                      _currentScale = _transformationController.value.getMaxScaleOnAxis();
                    });
                  },
                  child: Container(
                    width: diagramWidth,
                    height: diagramHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        _buildGrid(diagramWidth, diagramHeight),
                        SvgPicture.asset(
                          'assets/images/system_diagram.svg',
                          width: diagramWidth,
                          height: diagramHeight,
                          fit: BoxFit.contain,
                        ),
                        ...components.map((component) => SystemComponent(
                          id: component['id'],
                          name: component['name'],
                          position: Offset(
                            component['position'].dx * diagramWidth,
                            component['position'].dy * diagramHeight,
                          ),
                          isActive: widget.systemState.isComponentActive(component['id']),
                          onTap: () => widget.onComponentClick(component['id']),
                          onHover: () => setState(() => hoveredComponent = component['id']),
                          onHoverExit: () => setState(() => hoveredComponent = null),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              if (hoveredComponent != null)
                Positioned(
                  left: 20,
                  top: 20,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      'Component: $hoveredComponent',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: 20,
                bottom: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, color: Colors.black54),
                        onPressed: () => _handleZoom(0.8),
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: Colors.black12,
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.black54),
                        onPressed: () => _handleZoom(1.2),
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: Colors.black12,
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh, color: Colors.black54),
                        onPressed: _animateResetView,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGrid(double width, double height) {
    return CustomPaint(
      size: Size(width, height),
      painter: GridPainter(),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5;

    for (double i = 0; i <= size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i <= size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}