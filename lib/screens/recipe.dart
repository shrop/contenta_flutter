import '../shared/globals.dart' as globals;
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipePage extends StatefulWidget {
  final Recipe recipe;
  RecipePage({Key key, @required this.recipe}) : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState(recipe);
}

class _RecipePageState extends State<RecipePage> {
   final Recipe recipe;
   _RecipePageState(this.recipe);

  /// Save new recipes to Cloud Firestore.
  void saveNewRecipe(String id) async {
    final databaseReference = Firestore.instance;
    final QuerySnapshot result = await databaseReference
      .collection('recipes')
      .where('id', isEqualTo: id)
      .limit(1)
      .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    /// Save current recipe to Cloud Firestore if it doesn't exist.
    if (documents.length != 1) {
      databaseReference.collection('recipes')
      .document()
      .setData({
        'id': recipe.id,
        'title': recipe.title,
        'category': recipe.category,
        'difficulty': recipe.difficulty,
        'ingredients': recipe.ingredients,
        'instructions': recipe.instructions,
        'imageFileName': recipe.imageFileName,
        'totalTime': recipe.totalTime
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Save new recipes to Cloud Firestore.
    saveNewRecipe(recipe.id);

    final ingredients =
        recipe.ingredients.reduce((value, element) => value + ',' + element);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Recipe Detail',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey[400],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: globals.API_IMAGES_URL + recipe.imageFileName,
                errorWidget: (context, url, error) =>
                    Icon(Icons.photo_size_select_actual, size: 75.0),
              ),
              Row(
                children: [
                  Icon(Icons.favorite),
                  Icon(Icons.share),
                ],
              ),
              Text(
                recipe.title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                "Category: " +
                    recipe.category +
                    "\nDifficulty: " +
                    recipe.difficulty +
                    "\nTime: " +
                    recipe.totalTimeMin,
              ),
              Text(
                'Ingredients: ' + ingredients,
              ),
              Text(
                'Instructions: ' + recipe.instructions,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
