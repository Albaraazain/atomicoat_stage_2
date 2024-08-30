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
  double temperature;

  @HiveField(4)
  double pressure;

  @HiveField(5)
  double flowRate;

  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.temperature,
    required this.pressure,
    required this.flowRate,
  });

  // Factory constructor to create a Recipe from a Map
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] ?? DateTime.now().toString(),
      name: map['name'] ?? '',
      category: map['category'] ?? 'Default',
      temperature: map['temperature']?.toDouble() ?? 0.0,
      pressure: map['pressure']?.toDouble() ?? 0.0,
      flowRate: map['flowRate']?.toDouble() ?? 0.0,
    );
  }

  // Method to convert a Recipe to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'temperature': temperature,
      'pressure': pressure,
      'flowRate': flowRate,
    };
  }
}