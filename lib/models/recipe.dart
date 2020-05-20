/// Recipe data model.
class Recipe {
  final String id;
  String title;
  String difficulty;
  final int totalTime;
  String category;

  Recipe(this.id, this.title, this.difficulty, this.totalTime, this.category) {
    title ??= 'No title available.';
    difficulty ??= 'N/A';
    category ??= 'N/A';
  }
}
