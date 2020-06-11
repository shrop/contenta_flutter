import 'package:recase/recase.dart';

/// Recipe data model.
class Recipe {
  final String id;
  String title;
  String difficulty;
  final int totalTime;
  final List ingredients;
  final String instructions;
  String category;
  String imageFileName;

  Recipe(this.id, this.title, this.difficulty, this.totalTime, this.ingredients,
      this.instructions, this.category, this.imageFileName) {
    // Handle null values.
    title = title ??= 'No title available.';
    category = category ??= 'N/A';
    // Titlecase difficulty so it looks nicer in the UI.
    difficulty = difficulty != null ? ReCase(difficulty).titleCase : 'N/A';
  }

  // Getter helper to display totalTime like '10 min';
  String get totalTimeMin => totalTime.toString() + ' min';
}
