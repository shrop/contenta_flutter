import '../shared/globals.dart' as globals;
import 'package:contenta_flutter/screens/recipe.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

/// Gather all recipe data to display an individual recipe.
Future<List> fetchRecipeFavs() async {
  /// Return the recipe record from Cloud Firestore.
  final databaseReference = Firestore.instance;
  final QuerySnapshot favorites = await databaseReference
      .collection('recipes')
      .where('favorite', isEqualTo: true)
      .getDocuments();

  final List<DocumentSnapshot> favoriteRecipes = favorites.documents;
  List recipes = [];

  favoriteRecipes.forEach((e) {
    recipes.add(Recipe(
      e.data['id'],
      e.data['title'],
      e.data['difficulty'],
      e.data['totalTime'],
      e.data['ingredients'],
      e.data['instructions'],
      e.data['category'],
      e.data['imageFileName'],
    ));
  });

  return recipes;
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Recipes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey[400],
      ),
      body: Container(
        child: FutureBuilder(
            future: Future.wait([
              fetchRecipeFavs(),
            ]),
            builder: (BuildContext context, AsyncSnapshot recipes) {
              if (recipes.hasData) {
                return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: recipes.data[0].length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Column(children: <Widget>[
                        ListTile(
                          leading: Container(
                            width: 75.0,
                            height: 75.0,
                            child: CachedNetworkImage(
                              imageUrl: globals.API_IMAGES_URL +
                                  recipes.data[0][index].imageFileName,
                              errorWidget: (context, url, error) => Icon(
                                  Icons.photo_size_select_actual,
                                  size: 75.0),
                            ),
                          ),
                          title: Text(recipes.data[0][index].title),
                          subtitle: Text(recipes.data[0][index].category +
                              '\nDIfficulty: ' +
                              recipes.data[0][index].difficulty +
                              ' | Time: ' +
                              recipes.data[0][index].totalTimeMin),
                          isThreeLine: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RecipePage(
                                      recipe: recipes.data[0][index])),
                            );
                          },
                        )
                      ]);
                    });
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
