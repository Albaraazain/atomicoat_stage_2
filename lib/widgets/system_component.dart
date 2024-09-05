import 'package:flutter/material.dart';
import 'dart:math' as math;

class SystemComponent extends StatefulWidget {
  final String id;
  final String name;
  final Offset position;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onHover;
  final VoidCallback onHoverExit;

  const SystemComponent({
    Key? key,
    required this.id,
    required this.name,
    required this.position,
    required this.isActive,
    required this.onTap,
    required this.onHover,
    required this.onHoverExit,
  }) : super(key: key);

  @override
  _SystemComponentState createState() => _SystemComponentState();
}

class _SystemComponentState extends State<SystemComponent> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 1.1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _isHovered = true);
          _controller.forward();
          widget.onHover();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _controller.reverse();
          widget.onHoverExit();
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: CustomPaint(
                  painter: ComponentPainter(
                    isActive: widget.isActive,
                    isHovered: _isHovered,
                  ),
                  child: Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.center,
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ComponentPainter extends CustomPainter {
  final bool isActive;
  final bool isHovered;

  ComponentPainter({required this.isActive, required this.isHovered});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Draw outer circle
    final outerPaint = Paint()
      ..color = isActive ? Colors.green.shade400 : Colors.red.shade400
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, outerPaint);

    // Draw inner circle
    final innerPaint = Paint()
      ..color = isActive ? Colors.green.shade600 : Colors.red.shade600
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.8, innerPaint);

    // Draw highlight
    if (isHovered) {
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;
      canvas.drawCircle(center, radius - 2, highlightPaint);
    }

    // Draw connector points
    final connectorPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final connectorRadius = radius * 0.15;

    canvas.drawCircle(Offset(size.width / 2, 0), connectorRadius, connectorPaint);
    canvas.drawCircle(Offset(size.width, size.height / 2), connectorRadius, connectorPaint);
    canvas.drawCircle(Offset(size.width / 2, size.height), connectorRadius, connectorPaint);
    canvas.drawCircle(Offset(0, size.height / 2), connectorRadius, connectorPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}