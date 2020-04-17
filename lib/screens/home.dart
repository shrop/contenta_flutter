import 'package:contenta_flutter/screens/recipe.dart';
import 'package:flutter/material.dart';
import 'package:contenta_flutter/services/recipes.dart';
import 'package:recase/recase.dart';

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
                            leading: Icon(Icons.image),
                            title: Text(
                              snapshot.data[0][index].attributes['title'] ??
                                  'Title not available.',
                            ),
                            subtitle: Text('DIfficulty: ' +
                                ((ReCase(snapshot.data[0][index]
                                            .attributes['difficulty'] ??
                                        'None'))
                                    .titleCase) +
                                ' | Time: ' +
                                snapshot.data[0][index].attributes['totalTime']
                                    .toString() +
                                ' min'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RecipePage()),
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
        ));
  }
}
