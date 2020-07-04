import '../shared/globals.dart' as globals;
import 'package:contenta_flutter/screens/recipe.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Gather all recipe data to display an individual recipe.
Future<List> fetchRecipeFavs() async {
  /// Return the recipe record from Cloud Firestore.
  final databaseReference = Firestore.instance;
  final QuerySnapshot recipes = await databaseReference
      .collection('recipes')
      .where('favorite', isEqualTo: true)
      .getDocuments();

  final List<DocumentSnapshot> favorites = recipes.documents;
  return favorites;
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
            builder: (BuildContext context, AsyncSnapshot favorites) {
              if (favorites.hasData) {
                return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: favorites.data[0].length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Column(children: <Widget>[
                        ListTile(
                          leading: Container(
                            width: 75.0,
                            height: 75.0,
                            child: CachedNetworkImage(
                              imageUrl: globals.API_IMAGES_URL +
                                  favorites
                                      .data[0][index].data['imageFileName'],
                              errorWidget: (context, url, error) => Icon(
                                  Icons.photo_size_select_actual,
                                  size: 75.0),
                            ),
                          ),
                          title: Text(favorites.data[0][index].data['title']),
                          subtitle: Text(favorites
                                  .data[0][index].data['category'] +
                              '\nDIfficulty: ' +
                              favorites.data[0][index].data['difficulty'] +
                              ' | Time: ' +
                              favorites.data[0][index].data['totalTimeMin']),
                          isThreeLine: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RecipePage(
                                      recipe: favorites.data[0][index])),
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
