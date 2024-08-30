import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeListItem extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSimulate;

  const RecipeListItem({
    Key? key,
    required this.recipe,
    required this.onEdit,
    required this.onDelete,
    required this.onSimulate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(recipe.name),
        subtitle: Text('${recipe.category} - Last modified: ${recipe.lastModified.toLocal()}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: onSimulate,
            ),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(recipe.name),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Category: ${recipe.category}'),
                    Text('Version: ${recipe.version}'),
                    Text('Last Modified: ${recipe.lastModified.toLocal()}'),
                    Text('Steps: ${recipe.steps.length}'),
                  ],
                ),
                actions: [
                  TextButton(
                    child: Text('Close'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}