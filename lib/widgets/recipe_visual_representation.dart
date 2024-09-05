import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeVisualRepresentation extends StatelessWidget {
  final List<RecipeStep> steps;
  final Function(String) onStepTap;

  const RecipeVisualRepresentation({
    Key? key,
    required this.steps,
    required this.onStepTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Recipe Visualization',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          _buildStepsList(steps, 0),
        ],
      ),
    );
  }

  Widget _buildStepsList(List<RecipeStep> steps, int depth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps.map((step) => _buildStepItem(step, depth)).toList(),
    );
  }

  Widget _buildStepItem(RecipeStep step, int depth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => onStepTap(step.id),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16 + depth * 20.0),
            child: Row(
              children: [
                _buildStepIcon(step.type),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.type,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(_getStepDescription(step)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (step.type == 'Loop' && step.nestedSteps != null)
          _buildStepsList(step.nestedSteps!, depth + 1),
      ],
    );
  }

  Widget _buildStepIcon(String type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
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

  String _getStepDescription(RecipeStep step) {
    switch (step.type) {
      case 'Valve':
      case 'Purge':
        return 'Duration: ${step.parameters['duration']} seconds';
      case 'Loop':
        return 'Repeat ${step.parameters['count']} times';
      default:
        return '';
    }
  }
}