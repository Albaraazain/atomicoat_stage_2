import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeStepWidget extends StatefulWidget {
  final RecipeStep step;
  final Function(RecipeStep) onUpdate;
  final VoidCallback onRemove;
  final Function(String, RecipeStep) onAddNestedStep;
  final int depth;

  const RecipeStepWidget({
    Key? key,
    required this.step,
    required this.onUpdate,
    required this.onRemove,
    required this.onAddNestedStep,
    this.depth = 0,
  }) : super(key: key);

  @override
  _RecipeStepWidgetState createState() => _RecipeStepWidgetState();
}

class _RecipeStepWidgetState extends State<RecipeStepWidget> {
  late TextEditingController _durationController;
  late TextEditingController _countController;

  @override
  void initState() {
    super.initState();
    _durationController = TextEditingController(text: widget.step.parameters['duration']?.toString() ?? '');
    _countController = TextEditingController(text: widget.step.parameters['count']?.toString() ?? '');
  }

  @override
  void dispose() {
    _durationController.dispose();
    _countController.dispose();
    super.dispose();
  }

  void _updateStep() {
    final updatedStep = widget.step.copyWith(
      parameters: widget.step.type == 'Loop'
          ? {'count': int.tryParse(_countController.text) ?? 1}
          : {'duration': int.tryParse(_durationController.text) ?? 5},
    );
    widget.onUpdate(updatedStep);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.only(left: widget.depth * 16.0, bottom: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
              children: [
              _buildStepIcon(),
          SizedBox(width: 8),
          Expanded(child: Text(widget.step.type, style: TextStyle(fontWeight: FontWeight.bold))),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: widget.onRemove,
          ),
          ],
        ),
        SizedBox(height: 16),
        _buildStepContent(),
        if (widget.step.type == 'Loop')
    Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(height: 16),
    Text('Nested Steps:', style: TextStyle(fontWeight: FontWeight.bold)),
    ..._buildNestedSteps(),
    SizedBox(height: 8),
    _buildAddNestedStepButton(),
        ],
    ),
              ],
          ),
        ),
    );
  }

  Widget _buildStepIcon() {
    IconData iconData;
    Color iconColor;

    switch (widget.step.type) {
      case 'Valve':
        iconData = Icons.radio_button_checked;
        iconColor = Colors.blue;
        break;
      case 'Purge':
        iconData = Icons.cleaning_services;
        iconColor = Colors.green;
        break;
      case 'Loop':
        iconData = Icons.loop;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.help_outline;
        iconColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, color: iconColor),
    );
  }

  Widget _buildStepContent() {
    if (widget.step.type == 'Loop') {
      return TextField(
        controller: _countController,
        decoration: InputDecoration(
          labelText: 'Repeat Count',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: TextInputType.number,
        onChanged: (_) => _updateStep(),
      );
    } else {
      return TextField(
        controller: _durationController,
        decoration: InputDecoration(
          labelText: 'Duration (seconds)',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: TextInputType.number,
        onChanged: (_) => _updateStep(),
      );
    }
  }

  List<Widget> _buildNestedSteps() {
    return widget.step.nestedSteps?.map((nestedStep) => RecipeStepWidget(
      step: nestedStep,
      onUpdate: (updatedNestedStep) {
        final updatedNestedSteps = List<RecipeStep>.from(widget.step.nestedSteps ?? []);
        final index = updatedNestedSteps.indexWhere((step) => step.id == nestedStep.id);
        if (index != -1) {
          updatedNestedSteps[index] = updatedNestedStep;
          final updatedStep = widget.step.copyWith(nestedSteps: updatedNestedSteps);
          widget.onUpdate(updatedStep);
        }
      },
      onRemove: () {
        final updatedNestedSteps = List<RecipeStep>.from(widget.step.nestedSteps ?? [])
          ..removeWhere((step) => step.id == nestedStep.id);
        final updatedStep = widget.step.copyWith(nestedSteps: updatedNestedSteps);
        widget.onUpdate(updatedStep);
      },
      onAddNestedStep: widget.onAddNestedStep,
      depth: widget.depth + 1,
    )).toList() ?? [];
  }

  Widget _buildAddNestedStepButton() {
    return ElevatedButton.icon(
      icon: Icon(Icons.add, size: 18),
      label: Text('Add Nested Step'),
      onPressed: () => _showAddNestedStepDialog(),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.blue, backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  void _showAddNestedStepDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.radio_button_checked, color: Colors.blue),
                title: Text('Valve'),
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onAddNestedStep('Valve', widget.step);
                },
              ),
              ListTile(
                leading: Icon(Icons.cleaning_services, color: Colors.green),
                title: Text('Purge'),
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onAddNestedStep('Purge', widget.step);
                },
              ),
              ListTile(
                leading: Icon(Icons.loop, color: Colors.orange),
                title: Text('Loop'),
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onAddNestedStep('Loop', widget.step);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}