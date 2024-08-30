import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeStepWidget extends StatefulWidget {
  final RecipeStep step;
  final Function(RecipeStep) onUpdate;
  final VoidCallback onRemove;

  const RecipeStepWidget({
    Key? key,
    required this.step,
    required this.onUpdate,
    required this.onRemove,
  }) : super(key: key);

  @override
  _RecipeStepWidgetState createState() => _RecipeStepWidgetState();
}

class _RecipeStepWidgetState extends State<RecipeStepWidget> {
  late String _type;
  late Map<String, dynamic> _parameters;

  @override
  void initState() {
    super.initState();
    _type = widget.step.type;
    _parameters = Map.from(widget.step.parameters);
  }

  void _updateStep() {
    widget.onUpdate(RecipeStep(
      type: _type,
      parameters: _parameters,
      nestedSteps: widget.step.nestedSteps,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _type,
              items: ['Valve', 'Purge', 'Loop'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _type = newValue;
                    _parameters = {'duration': 5}; // Reset parameters for new type
                  });
                  _updateStep();
                }
              },
            ),
            if (_type == 'Loop')
              TextFormField(
                initialValue: _parameters['count']?.toString() ?? '1',
                decoration: InputDecoration(labelText: 'Repeat Count'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _parameters['count'] = int.tryParse(value) ?? 1;
                  _updateStep();
                },
              )
            else
              TextFormField(
                initialValue: _parameters['duration']?.toString() ?? '5',
                decoration: InputDecoration(labelText: 'Duration (seconds)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _parameters['duration'] = int.tryParse(value) ?? 5;
                  _updateStep();
                },
              ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: widget.onRemove,
            ),
          ],
        ),
      ),
    );
  }
}