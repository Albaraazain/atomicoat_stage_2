import 'package:hive/hive.dart';
import 'recipe.dart';

class RecipeTypeAdapter extends TypeAdapter<Recipe> {
  @override
  final int typeId = 0;

  @override
  Recipe read(BinaryReader reader) {
    return Recipe(
      id: reader.readString(),
      name: reader.readString(),
      category: reader.readString(),
      temperature: reader.readDouble(),
      pressure: reader.readDouble(),
      flowRate: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, Recipe obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.category);
    writer.writeDouble(obj.temperature);
    writer.writeDouble(obj.pressure);
    writer.writeDouble(obj.flowRate);
  }
}