import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/storage_service.dart';
import '../widgets/recipe_list_item.dart';
import '../widgets/recipe_builder.dart';
import '../widgets/recipe_simulation.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  List<Recipe> _recipes = [];
  List<Recipe> _templates = [];
  Recipe? _currentRecipe;
  bool _isEditMode = false;
  bool _showTemplates = false;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
    _loadTemplates();
  }

  Future<void> _loadRecipes() async {
    final recipes = await StorageService.getAllRecipes();
    setState(() {
      _recipes = recipes;
    });
  }

  Future<void> _loadTemplates() async {
    final templates = await StorageService.getAllTemplates();
    setState(() {
      _templates = templates;
    });
  }

  void _createNewRecipe({Recipe? template}) {
    setState(() {
      _currentRecipe = template?.copyWith(
        id: DateTime.now().toString(),
        name: 'New Recipe',
        lastModified: DateTime.now(),
      ) ??
          Recipe(
            id: DateTime.now().toString(),
            name: 'New Recipe',
            category: 'Default',
            steps: [],
            lastModified: DateTime.now(),
            version: '1.0',
          );
      _isEditMode = true;
    });
  }

  void _editRecipe(Recipe recipe) {
    setState(() {
      _currentRecipe = recipe;
      _isEditMode = true;
    });
  }

  Future<void> _saveRecipe(Recipe recipe) async {
    await StorageService.saveRecipe(recipe);
    _loadRecipes();
    setState(() {
      _currentRecipe = null;
      _isEditMode = false;
    });
  }

  Future<void> _deleteRecipe(Recipe recipe) async {
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
            child: Text('Delete', style: TextStyle(color: Colors.red)),
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

  void _showSimulation(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipeSimulation(recipe: recipe)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _isEditMode ? 'Edit Recipe' : 'Recipes',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 28),
        ),
        leading: _isEditMode
            ? IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            setState(() {
              _currentRecipe = null;
              _isEditMode = false;
            });
          },
        )
            : null,
        actions: [
          if (_isEditMode)
            TextButton(
              child: Text('Save', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
              onPressed: () {
                if (_currentRecipe != null) {
                  _saveRecipe(_currentRecipe!);
                }
              },
            )
          else
            IconButton(
              icon: Icon(Icons.add, color: Colors.black),
              onPressed: _createNewRecipe,
            ),
        ],
      ),
      body: _isEditMode
          ? RecipeBuilder(
        recipe: _currentRecipe!,
        onSave: _saveRecipe,
        onUpdate: (Recipe updatedRecipe) {
          setState(() {
            _currentRecipe = updatedRecipe;
          });
        },
      )
          : Column(
        children: [
          _buildToggle(),
          Expanded(
            child: _showTemplates ? _buildTemplateList() : _buildRecipeList(),
          ),
        ],
      ),
    );
  }
  Widget _buildToggle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildToggleButton('Recipes', !_showTemplates),
          SizedBox(width: 16),
          _buildToggleButton('Templates', _showTemplates),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showTemplates = text == 'Templates';
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.white,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeList() {
    return ListView.builder(
      itemCount: _recipes.length,
      itemBuilder: (context, index) {
        final recipe = _recipes[index];
        return RecipeListItem(
          recipe: recipe,
          onEdit: () => _editRecipe(recipe),
          onDelete: () => _deleteRecipe(recipe),
          onSimulate: () => _showSimulation(recipe),
          onSaveAsTemplate: () async {
            await StorageService.saveTemplate(recipe.copyWith(
              id: DateTime.now().toString(),
              name: '${recipe.name} (Template)',
            ));
            _loadTemplates();
          },
        );
      },
    );
  }

  Widget _buildTemplateList() {
    return ListView.builder(
      itemCount: _templates.length,
      itemBuilder: (context, index) {
        final template = _templates[index];
        return ListTile(
          title: Text(template.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
          subtitle: Text(template.category, style: TextStyle(color: Colors.grey[600])),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 18),
          onTap: () => _createNewRecipe(template: template),
        );
      },
    );
  }
}