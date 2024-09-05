import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../widgets/system_diagram.dart';
import '../widgets/component_detail_dialog.dart';

class SystemControlScreen extends StatelessWidget {
  const SystemControlScreen({Key? key}) : super(key: key);

  void _handleComponentClick(BuildContext context, String componentId) {
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ComponentDetailDialog(
          componentId: componentId,
          systemState: appState.systemState,
          onToggleComponent: (id) {
            appState.toggleComponentStatus(id);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AppStateProvider>(
          builder: (context, appState, child) {
            return Stack(
              children: [
                // Back button
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),

                // System Diagram
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SystemDiagram(
                      onComponentClick: (componentId) => _handleComponentClick(context, componentId),
                    ),
                  ),
                ),

                // Minimal status indicator
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appState.systemState.isRunning ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}