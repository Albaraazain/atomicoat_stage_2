import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/app_state_provider.dart';
import '../services/storage_service.dart';
import '../widgets/recipe_list_item.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  List<Recipe> _recipes = [];
  String _sortBy = 'name';

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final recipes = await StorageService.getAllRecipes();
    setState(() {
      _recipes = recipes;
      _sortRecipes();
    });
  }

  void _sortRecipes() {
    _recipes.sort((a, b) {
      switch (_sortBy) {
        case 'name':
          return a.name.compareTo(b.name);
        case 'category':
          return a.category.compareTo(b.category);
        case 'temperature':
          return a.temperature.compareTo(b.temperature);
        default:
          return 0;
      }
    });
  }

  void _addRecipe() async {
    final result = await showDialog<Recipe>(
      context: context,
      builder: (BuildContext context) => RecipeDialog(),
    );
    if (result != null) {
      await StorageService.saveRecipe(result);
      _loadRecipes();
    }
  }

  void _editRecipe(Recipe recipe) async {
    final result = await showDialog<Recipe>(
      context: context,
      builder: (BuildContext context) => RecipeDialog(recipe: recipe),
    );
    if (result != null) {
      await StorageService.saveRecipe(result);
      _loadRecipes();
    }
  }

  void _deleteRecipe(Recipe recipe) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Delete Recipe'),
        content: Text('Are you sure you want to delete ${recipe.name}?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await StorageService.deleteRecipe(recipe.id);
      _loadRecipes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              setState(() {
                _sortBy = result;
                _sortRecipes();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'name',
                child: Text('Sort by Name'),
              ),
              const PopupMenuItem<String>(
                value: 'category',
                child: Text('Sort by Category'),
              ),
              const PopupMenuItem<String>(
                value: 'temperature',
                child: Text('Sort by Temperature'),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _recipes.length,
        itemBuilder: (context, index) {
          final recipe = _recipes[index];
          return RecipeListItem(
            recipe: recipe,
            onEdit: () => _editRecipe(recipe),
            onDelete: () => _deleteRecipe(recipe),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRecipe,
        child: Icon(Icons.add),
      ),
    );
  }
}

class RecipeDialog extends StatefulWidget {
  final Recipe? recipe;

  const RecipeDialog({Key? key, this.recipe}) : super(key: key);

  @override
  _RecipeDialogState createState() => _RecipeDialogState();
}

class _RecipeDialogState extends State<RecipeDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _category;
  late double _temperature;
  late double _pressure;
  late double _flowRate;

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _name = widget.recipe!.name;
      _category = widget.recipe!.category;
      _temperature = widget.recipe!.temperature;
      _pressure = widget.recipe!.pressure;
      _flowRate = widget.recipe!.flowRate;
    } else {
      _name = '';
      _category = 'Standard';
      _temperature = 25.0;
      _pressure = 101325.0;
      _flowRate = 100.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.recipe == null ? 'Add Recipe' : 'Edit Recipe'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              initialValue: _name,
              decoration: InputDecoration(labelText: 'Recipe Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) => _name = value!,
            ),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: InputDecoration(labelText: 'Category'),
              items: ['Standard', 'High-Temp', 'Low-Pressure', 'Experimental']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _category = value!;
                });
              },
            ),
            TextFormField(
              initialValue: _temperature.toString(),
              decoration: InputDecoration(labelText: 'Temperature (°C)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a temperature';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onSaved: (value) => _temperature = double.parse(value!),
            ),
            TextFormField(
              initialValue: _pressure.toString(),
              decoration: InputDecoration(labelText: 'Pressure (Pa)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a pressure';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onSaved: (value) => _pressure = double.parse(value!),
            ),
            TextFormField(
              initialValue: _flowRate.toString(),
              decoration: InputDecoration(labelText: 'Flow Rate (sccm)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a flow rate';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onSaved: (value) => _flowRate = double.parse(value!),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(widget.recipe == null ? 'Add' : 'Save'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final recipe = Recipe(
                id: widget.recipe?.id ?? DateTime.now().toString(),
                name: _name,
                category: _category,
                temperature: _temperature,
                pressure: _pressure,
                flowRate: _flowRate,
              );
              Navigator.of(context).pop(recipe);
            }
          },
        ),
      ],
    );
  }
}