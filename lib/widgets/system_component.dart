import 'package:flutter/material.dart';

class SystemComponent extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          onEnter: (_) => onHover(),
          onExit: (_) => onHoverExit(),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Colors.green : Colors.red,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Center(
              child: Text(
                name,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}