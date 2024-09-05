import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeBuilder extends StatefulWidget {
  final Recipe recipe;
  final Function(Recipe) onSave;
  final Function(Recipe) onUpdate;

  const RecipeBuilder({
    Key? key,
    required this.recipe,
    required this.onSave,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _RecipeBuilderState createState() => _RecipeBuilderState();
}

class _RecipeBuilderState extends State<RecipeBuilder> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  List<RecipeStep> _steps = [];

  final Color teslaRed = Color(0xFFE82127);
  final Color teslaGray = Color(0xFFF4F4F4);
  final Color teslaDarkGray = Color(0xFF333333);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.recipe.name);
    _categoryController = TextEditingController(text: widget.recipe.category);
    _steps = List.from(widget.recipe.steps);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _addStep(String type, {RecipeStep? parentStep}) {
    setState(() {
      RecipeStep newStep;
      switch (type) {
        case 'Purge':
        case 'Valve':
          newStep = RecipeStep(type: type, parameters: {'duration': 5});
          break;
        case 'Loop':
          newStep = RecipeStep(
              type: 'Loop', parameters: {'count': 1}, nestedSteps: []);
          break;
        default:
          newStep =
              RecipeStep(type: 'Instruction', parameters: {'instruction': ''});
      }

      if (parentStep != null) {
        final parentIndex = _steps.indexOf(parentStep);
        if (parentIndex != -1) {
          _steps[parentIndex].nestedSteps ??= [];
          _steps[parentIndex].nestedSteps!.add(newStep);
        }
      } else {
        _steps.add(newStep);
      }
    });
    _updateRecipe();
  }

  void _removeStep(RecipeStep step, {RecipeStep? parentStep}) {
    setState(() {
      if (parentStep != null) {
        parentStep.nestedSteps?.remove(step);
      } else {
        _steps.remove(step);
      }
    });
    _updateRecipe();
  }

  void _updateStep(RecipeStep oldStep, RecipeStep updatedStep,
      {RecipeStep? parentStep}) {
    setState(() {
      if (parentStep != null) {
        final index = parentStep.nestedSteps?.indexOf(oldStep) ?? -1;
        if (index != -1) {
          parentStep.nestedSteps![index] = updatedStep;
        }
      } else {
        final index = _steps.indexOf(oldStep);
        if (index != -1) {
          _steps[index] = updatedStep;
        }
      }
    });
    _updateRecipe();
  }

  void _updateRecipe() {
    final updatedRecipe = widget.recipe.copyWith(
      name: _nameController.text,
      category: _categoryController.text,
      steps: _steps,
    );
    widget.onUpdate(updatedRecipe);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(_nameController, 'Recipe Name'),
          SizedBox(height: 16),
          _buildTextField(_categoryController, 'Category'),
          SizedBox(height: 24),
          Text('Steps', style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w300, color: teslaDarkGray)),
          SizedBox(height: 16),
          ..._steps.map((step) => _buildStepCard(step)),
          SizedBox(height: 16),
          _buildAddStepButton(),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: teslaDarkGray, fontSize: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: teslaDarkGray.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: teslaRed, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      style: TextStyle(color: teslaDarkGray, fontSize: 16),
      onChanged: (_) => _updateRecipe(),
    );
  }

  Widget _buildStepCard(RecipeStep step, {RecipeStep? parentStep}) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: teslaGray,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  step.type,
                  style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: teslaDarkGray),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: teslaRed),
                  onPressed: () => _removeStep(step, parentStep: parentStep),
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildStepContent(step),
            if (step.type == 'Loop') ...[
              SizedBox(height: 16),
              Text(
                'Nested Steps',
                style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: teslaDarkGray),
              ),
              ...(step.nestedSteps ?? []).map((nestedStep) =>
                  _buildStepCard(nestedStep, parentStep: step)),
              _buildAddNestedStepButton(step),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(RecipeStep step) {
    switch (step.type) {
      case 'Purge':
      case 'Valve':
        return _buildTeslaTextField(
          'Duration (seconds)',
          TextInputType.number,
          step.parameters['duration'].toString(),
              (value) {
            final updatedStep = step.copyWith(
                parameters: {'duration': int.tryParse(value) ?? 0});
            _updateStep(step, updatedStep);
          },
        );
      case 'Loop':
        return _buildTeslaTextField(
          'Repeat Count',
          TextInputType.number,
          step.parameters['count'].toString(),
              (value) {
            final updatedStep = step.copyWith(
                parameters: {'count': int.tryParse(value) ?? 1});
            _updateStep(step, updatedStep);
          },
        );
      default:
        return _buildTeslaTextField(
          'Instruction',
          TextInputType.multiline,
          step.parameters['instruction'] as String? ?? '',
              (value) {
            final updatedStep = step.copyWith(
                parameters: {'instruction': value});
            _updateStep(step, updatedStep);
          },
          maxLines: 3,
        );
    }
  }

  Widget _buildTeslaTextField(String label,
      TextInputType keyboardType,
      String initialValue,
      Function(String) onChanged, {
        int maxLines = 1,
      }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: teslaDarkGray.withOpacity(0.7), fontSize: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: teslaDarkGray.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: teslaRed, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      style: TextStyle(color: teslaDarkGray, fontSize: 16),
      keyboardType: keyboardType,
      maxLines: maxLines,
      controller: TextEditingController(text: initialValue),
      onChanged: onChanged,
    );
  }

  Widget _buildAddStepButton() {
    return Center(
      child: ElevatedButton(
        child: Text(
          'ADD STEP',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: teslaRed,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        onPressed: () => _showAddStepDialog(),
      ),
    );
  }

  Widget _buildAddNestedStepButton(RecipeStep parentStep) {
    return TextButton(
      child: Text(
        'ADD NESTED STEP',
        style: TextStyle(color: teslaRed, fontWeight: FontWeight.bold),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      onPressed: () => _showAddStepDialog(parentStep: parentStep),
    );
  }

  void _showAddStepDialog({RecipeStep? parentStep}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Step', style: TextStyle(color: teslaDarkGray)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogOption('Purge', parentStep),
              _buildDialogOption('Valve', parentStep),
              _buildDialogOption('Loop', parentStep),
              _buildDialogOption('Instruction', parentStep),
            ],
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        );
      },
    );
  }

  Widget _buildDialogOption(String type, RecipeStep? parentStep) {
    return ListTile(
      title: Text(type, style: TextStyle(color: teslaDarkGray)),
      onTap: () {
        Navigator.pop(context);
        _addStep(type, parentStep: parentStep);
      },
    );
  }


}