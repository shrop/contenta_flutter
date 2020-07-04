import '../shared/globals.dart' as globals;
import 'package:contenta_flutter/screens/recipe.dart';
import 'package:flutter/material.dart';
import 'package:contenta_flutter/services/recipes.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Umami Recipes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey[400],
      ),
      body: Container(
        child: FutureBuilder(
            future: Future.wait([
              RecipeService().fetchRecipes(),
            ]),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: snapshot.data[0].length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Column(children: <Widget>[
                        ListTile(
                          leading: Container(
                            width: 75.0,
                            height: 75.0,
                            child: CachedNetworkImage(
                              imageUrl: globals.API_IMAGES_URL +
                                  snapshot.data[0][index].imageFileName,
                              errorWidget: (context, url, error) => Icon(
                                  Icons.photo_size_select_actual,
                                  size: 75.0),
                            ),
                          ),
                          title: Text(snapshot.data[0][index].title),
                          subtitle: Text(snapshot.data[0][index].category +
                              '\nDIfficulty: ' +
                              snapshot.data[0][index].difficulty +
                              ' | Time: ' +
                              snapshot.data[0][index].totalTimeMin),
                          isThreeLine: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RecipePage(
                                      recipe: snapshot.data[0][index])),
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
