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

  /// Gather all recipe data to display an individual recipe.
  Future<List> _getRecipe(String id) async {
    /// Check if the current recipe is in Cloud Firestore.
    final databaseReference = Firestore.instance;
    final QuerySnapshot result = await databaseReference
        .collection('recipes')
        .where('id', isEqualTo: id)
        .limit(1)
        .getDocuments();

    final List<DocumentSnapshot> documents = result.documents;

    /// Save current recipe to Cloud Firestore if it doesn't exist.
    if (documents.length != 1) {
      await databaseReference.collection('recipes').document().setData({
        'id': recipe.id,
        'title': recipe.title,
        'category': recipe.category,
        'difficulty': recipe.difficulty,
        'ingredients': recipe.ingredients,
        'instructions': recipe.instructions,
        'imageFileName': recipe.imageFileName,
        'totalTime': recipe.totalTime,
        'favorite': false
      });
    }

    /// Return the recipe record from Cloud Firestore.
    final QuerySnapshot recipeData = await databaseReference
        .collection('recipes')
        .where('id', isEqualTo: id)
        .limit(1)
        .getDocuments();

    final List<DocumentSnapshot> document = recipeData.documents;
    return document;
  }

  /// Update favorite status.
  void _updateFavStatus(String docId, bool favValue) async {
    await Firestore.instance
        .collection('recipes')
        .document(docId)
        .updateData({'favorite': favValue});
  }

  @override
  Widget build(BuildContext context) {
    final Set<bool> favorited = Set<bool>();
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
        child: FutureBuilder(
            future: _getRecipe(recipe.id),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final bool isFavorite = snapshot.data[0].data['favorite'];
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: globals.API_IMAGES_URL + recipe.imageFileName,
                        errorWidget: (context, url, error) =>
                            Icon(Icons.photo_size_select_actual, size: 75.0),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : null),
                            onPressed: () {
                              setState(() {
                                if (isFavorite) {
                                  favorited.remove(
                                      snapshot.data[0].data['favorite']);
                                  _updateFavStatus(
                                      snapshot.data[0].documentID, false);
                                } else {
                                  favorited
                                      .add(snapshot.data[0].data['favorite']);
                                  _updateFavStatus(
                                      snapshot.data[0].documentID, true);
                                }
                              });
                            },
                          ),
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
                );
              } else {
                // Proivde a spinner while we wait on the Contenta CMS API.
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
