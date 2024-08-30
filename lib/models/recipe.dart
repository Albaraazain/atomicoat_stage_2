import 'package:hive/hive.dart';

part 'recipe.g.dart';

@HiveType(typeId: 0)
class Recipe extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String category;

  @HiveField(3)
  List<RecipeStep> steps;

  @HiveField(4)
  DateTime lastModified;

  @HiveField(5)
  String version;

  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.steps,
    required this.lastModified,
    required this.version,
  });

  Recipe copyWith({
    String? id,
    String? name,
    String? category,
    List<RecipeStep>? steps,
    DateTime? lastModified,
    String? version,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      steps: steps ?? this.steps,
      lastModified: lastModified ?? this.lastModified,
      version: version ?? this.version,
    );
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] ?? DateTime.now().toString(),
      name: map['name'] ?? '',
      category: map['category'] ?? 'Default',
      steps: (map['steps'] as List<dynamic>?)?.map((step) => RecipeStep.fromMap(step)).toList() ?? [],
      lastModified: DateTime.parse(map['lastModified'] ?? DateTime.now().toIso8601String()),
      version: map['version'] ?? '1.0',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'steps': steps.map((step) => step.toMap()).toList(),
      'lastModified': lastModified.toIso8601String(),
      'version': version,
    };
  }
}

@HiveType(typeId: 1)
class RecipeStep {
  @HiveField(0)
  String type;

  @HiveField(1)
  Map<String, dynamic> parameters;

  @HiveField(2)
  List<RecipeStep>? nestedSteps;

  RecipeStep({
    required this.type,
    required this.parameters,
    this.nestedSteps,
  });

  factory RecipeStep.fromMap(Map<String, dynamic> map) {
    return RecipeStep(
      type: map['type'],
      parameters: Map<String, dynamic>.from(map['parameters']),
      nestedSteps: (map['nestedSteps'] as List<dynamic>?)?.map((step) => RecipeStep.fromMap(step)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'parameters': parameters,
      'nestedSteps': nestedSteps?.map((step) => step.toMap()).toList(),
    };
  }
}