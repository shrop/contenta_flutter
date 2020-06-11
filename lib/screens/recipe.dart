import '../shared/globals.dart' as globals;
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecipePage extends StatelessWidget {
  // Declare a field that holds the Recipe.
  final Recipe recipe;

  // In the constructor, require a Recipe.
  RecipePage({Key key, @required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
