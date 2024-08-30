import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final String status;

  StatusIndicator({required this.status});

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'running':
        return Colors.green;
      case 'idle':
        return Colors.blue;
      case 'error':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: _getStatusColor(),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(
          'Status: $status',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}