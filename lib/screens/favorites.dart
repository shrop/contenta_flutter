import '../shared/globals.dart' as globals;
import 'package:contenta_flutter/screens/recipe2.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Return a Stream of favorited recipes.
Stream _getFavs() {
  return Firestore.instance
      .collection('recipes')
      .where('favorite', isEqualTo: true)
      .snapshots();
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
        child: StreamBuilder<QuerySnapshot>(
            stream: _getFavs(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Column(children: <Widget>[
                        ListTile(
                          leading: Container(
                            width: 75.0,
                            height: 75.0,
                            child: CachedNetworkImage(
                              imageUrl: globals.API_IMAGES_URL +
                                  snapshot.data.documents[index]
                                      .data['imageFileName'],
                              errorWidget: (context, url, error) => Icon(
                                  Icons.photo_size_select_actual,
                                  size: 75.0),
                            ),
                          ),
                          title: Text(
                              snapshot.data.documents[index].data['title']),
                          subtitle: Text(
                              snapshot.data.documents[index].data['category'] +
                                  '\nDIfficulty: ' +
                                  snapshot.data.documents[index]
                                      .data['difficulty'] +
                                  ' | Time: ' +
                                  snapshot.data.documents[index]
                                      .data['totalTimeMin']),
                          isThreeLine: true,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecipePage2(
                                      favorite: snapshot.data.documents[index]),
                                ));
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
