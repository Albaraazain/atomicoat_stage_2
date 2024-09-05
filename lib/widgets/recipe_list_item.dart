import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeListItem extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSimulate;
  final VoidCallback onSaveAsTemplate;

  const RecipeListItem({
    Key? key,
    required this.recipe,
    required this.onEdit,
    required this.onDelete,
    required this.onSimulate,
    required this.onSaveAsTemplate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        title: Text(
          recipe.name,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          recipe.category,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.more_horiz, color: Colors.black),
          onPressed: () => _showOptions(context),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit, color: Colors.black),
                title: Text('Edit', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  onEdit();
                },
              ),
              ListTile(
                leading: Icon(Icons.play_arrow, color: Colors.black),
                title: Text('Simulate', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  onSimulate();
                },
              ),
              ListTile(
                leading: Icon(Icons.content_copy, color: Colors.black),
                title: Text('Save as Template', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  onSaveAsTemplate();
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}