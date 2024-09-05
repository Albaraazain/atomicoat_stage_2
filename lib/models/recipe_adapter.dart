import 'package:hive/hive.dart';
import 'recipe.dart';

class RecipeTypeAdapterCustom extends TypeAdapter<Recipe> {
  @override
  final int typeId = 0;

  @override
  Recipe read(BinaryReader reader) {
    return Recipe(
      id: reader.readString(),
      name: reader.readString(),
      category: reader.readString(),
      steps: (reader.readList()).cast<RecipeStep>(),
      lastModified: DateTime.parse(reader.readString()),
      version: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Recipe obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.category);
    writer.writeList(obj.steps);
    writer.writeString(obj.lastModified.toIso8601String());
    writer.writeString(obj.version);
  }
}

class RecipeStepAdapterCustom extends TypeAdapter<RecipeStep> {
  @override
  final int typeId = 1;

  @override
  RecipeStep read(BinaryReader reader) {
    return RecipeStep(
      type: reader.readString(),
      parameters: Map<String, dynamic>.from(reader.readMap()),
      nestedSteps: (reader.readList() as List<dynamic>?)?.cast<RecipeStep>(),
    );
  }

  @override
  void write(BinaryWriter writer, RecipeStep obj) {
    writer.writeString(obj.type);
    writer.writeMap(obj.parameters);
    writer.writeList(obj.nestedSteps ?? []);
  }
}