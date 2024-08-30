import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/app_state_provider.dart';
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
  String _sortBy = 'name';
  Recipe? _currentRecipe;

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
        case 'lastModified':
          return b.lastModified.compareTo(a.lastModified);
        default:
          return 0;
      }
    });
  }

  void _createNewRecipe() {
    setState(() {
      _currentRecipe = Recipe(
        id: DateTime.now().toString(),
        name: 'New Recipe',
        category: 'Default',
        steps: [],
        lastModified: DateTime.now(),
        version: '1.0',
      );
    });
  }

  void _editRecipe(Recipe recipe) {
    setState(() {
      _currentRecipe = recipe;
    });
  }

  Future<void> _saveRecipe(Recipe recipe) async {
    await StorageService.saveRecipe(recipe);
    _loadRecipes();
    setState(() {
      _currentRecipe = null;
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
                value: 'lastModified',
                child: Text('Sort by Last Modified'),
              ),
            ],
          ),
        ],
      ),
      body: _currentRecipe == null
          ? _buildRecipeList()
          : RecipeBuilder(
        recipe: _currentRecipe!,
        onSave: _saveRecipe,
        onCancel: () => setState(() => _currentRecipe = null),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewRecipe,
        child: Icon(Icons.add),
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
        );
      },
    );
  }

  void _showSimulation(Recipe recipe) {
    showDialog(
      context: context,
      builder: (BuildContext context) => RecipeSimulation(recipe: recipe),
    );
  }
}