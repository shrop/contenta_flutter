import '../shared/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeFav extends StatelessWidget {
  final DocumentSnapshot favorite;
  RecipeFav({Key key, @required this.favorite}) : super(key: key);

  /// Update favorite status.
  void _updateFavStatus(String docId, bool favValue) async {
    await Firestore.instance
        .collection('recipes')
        .document(docId)
        .updateData({'favorite': favValue});
  }

  @override
  Widget build(BuildContext context) {
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
                      icon: Icon(Icons.favorite, color: Colors.red),
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
