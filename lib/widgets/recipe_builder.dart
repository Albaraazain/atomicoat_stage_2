import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'recipe_step_widget.dart';

class RecipeBuilder extends StatefulWidget {
  final Recipe recipe;
  final Function(Recipe) onSave;
  final VoidCallback onCancel;

  const RecipeBuilder({
    Key? key,
    required this.recipe,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  _RecipeBuilderState createState() => _RecipeBuilderState();
}

class _RecipeBuilderState extends State<RecipeBuilder> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  List<RecipeStep> _steps = [];

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

  void _addStep() {
    setState(() {
      _steps.add(RecipeStep(type: 'Valve', parameters: {'duration': 5}));
    });
  }

  void _updateStep(int index, RecipeStep updatedStep) {
    setState(() {
      _steps[index] = updatedStep;
    });
  }

  void _removeStep(int index) {
    setState(() {
      _steps.removeAt(index);
    });
  }

  void _moveStep(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final RecipeStep step = _steps.removeAt(oldIndex);
      _steps.insert(newIndex, step);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.id.isEmpty ? 'New Recipe' : 'Edit Recipe'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              final updatedRecipe = widget.recipe.copyWith(
                name: _nameController.text,
                category: _categoryController.text,
                steps: _steps,
                lastModified: DateTime.now(),
              );
              widget.onSave(updatedRecipe);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Recipe Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
          ),
          Expanded(
            child: ReorderableListView(
              children: _steps
                  .asMap()
                  .map((index, step) => MapEntry(
                index,
                RecipeStepWidget(
                  key: ValueKey(step),
                  step: step,
                  onUpdate: (updatedStep) => _updateStep(index, updatedStep),
                  onRemove: () => _removeStep(index),
                ),
              ))
                  .values
                  .toList(),
              onReorder: _moveStep,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStep,
        child: Icon(Icons.add),
      ),
    );
  }
}