import '../shared/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipePage2 extends StatefulWidget {
  final DocumentSnapshot favorite;
  RecipePage2({Key key, @required this.favorite}) : super(key: key);

  @override
  _RecipePageState2 createState() => _RecipePageState2(favorite);
}

class _RecipePageState2 extends State<RecipePage2> {
  final DocumentSnapshot favorite;
  _RecipePageState2(this.favorite);

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
    final bool isFavorite = favorite.data['favorite'];
    final ingredients = favorite.data['ingredients']
        .reduce((value, element) => value + ',' + element);

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
                  imageUrl:
                      globals.API_IMAGES_URL + favorite.data['imageFileName'],
                  errorWidget: (context, url, error) =>
                      Icon(Icons.photo_size_select_actual, size: 75.0),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null),
                      onPressed: () {
                        _updateFavStatus(favorite.documentID, false);
                        Navigator.pop(context);
                      },
                    ),
                    Icon(Icons.share),
                  ],
                ),
                Text(
                  favorite.data['title'],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Category: " +
                      favorite.data['category'] +
                      "\nDifficulty: " +
                      favorite.data['difficulty'] +
                      "\nTime: " +
                      favorite.data['totalTimeMin'],
                ),
                Text(
                  'Ingredients: ' + ingredients,
                ),
                Text(
                  'Instructions: ' + favorite.data['instructions'],
                ),
              ],
            ),
          ),
        ));
  }
}
