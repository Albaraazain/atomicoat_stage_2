import 'package:flutter/material.dart';
import '../models/models.dart';

class ComponentDetailDialog extends StatelessWidget {
  final String componentId;
  final SystemState systemState;
  final Function(String) onToggleComponent;

  const ComponentDetailDialog({
    Key? key,
    required this.componentId,
    required this.systemState,
    required this.onToggleComponent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isActive = systemState.isComponentActive(componentId);

    return AlertDialog(
      title: Text('$componentId Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status: ${isActive ? 'Active' : 'Inactive'}'),
          const SizedBox(height: 8),
          Text('Temperature: ${systemState.temperature.toStringAsFixed(2)}°C'),
          const SizedBox(height: 8),
          Text('Pressure: ${systemState.pressure.toStringAsFixed(2)} Pa'),
          const SizedBox(height: 8),
          Text('Gas Flow Rate: ${systemState.gasFlowRate.toStringAsFixed(2)} sccm'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => onToggleComponent(componentId),
            child: Text(isActive ? 'Deactivate' : 'Activate'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}