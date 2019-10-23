import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:json_api/json_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.yellow[400],
      ),
      home: RecipesList(),
    );
  }
}

class RecipesState extends State<RecipesList> {
  final Set<String> _saved = Set<String>();

  Future<Map> recipeResults() async {
    // Get recipes from the Contenta CMS API.
    final httpClient = Client();
    final jsonApiClient = JsonApiClient(httpClient);
    final companiesUri = Uri.parse('https://dev-contentacms.pantheonsite.io/api/recipes');
    final response = await jsonApiClient.fetchCollection(companiesUri);
    httpClient.close();

    final results = response.data.unwrap().asMap();
    return results;
  }

  Future<List> getFavs() async {
    final favs = new List();
    await Firestore.instance
      .collection('recipes')
      .getDocuments()
      .then((QuerySnapshot docs) {
        if (docs.documents.isNotEmpty) {
          docs.documents.forEach((doc) => favs.add(doc.documentID));
        }
    });
    return favs;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold (
      appBar: AppBar(
        title: Text('Recipe Magazine'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder(
          future: Future.wait([
            recipeResults(),
            getFavs(),
          ]),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              // List Recipe titles.
              return new ListView.builder
                (
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data[0].length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    //final bool alreadySaved = _saved.contains(snapshot.data[index].id); // Add 9 lines from here...

                    final bool alreadySaved = snapshot.data[1].contains(snapshot.data[0][index].id);

                    return new Column(
                      children: <Widget>[
                        new ListTile(
                          leading: Icon(Icons.image),
                          title: new Text(
                            snapshot.data[0][index].attributes['title'],
                          ),
                          trailing: Icon(   // Add the lines from here...
                            alreadySaved ? Icons.favorite : Icons.favorite_border,
                            color: alreadySaved ? Colors.red : null,
                          ),
                          onTap: () {
                            setState(() {
                            if (alreadySaved) {
                                _saved.remove(snapshot.data[0][index].id);
                                Firestore.instance.collection('recipes').document(snapshot.data[0][index].id)
                                  .delete();
                              } else {
                                _saved.add(snapshot.data[0][index].id);
                                Firestore.instance.collection('recipes').document(snapshot.data[0][index].id)
                                  .setData({ 'id': snapshot.data[0][index].id });
                              }
                            });
                          },
                        ),
                      ]
                    );
                  }
                );
            } else {
              // Proivde a spinner while we wait on the Contenta CMS API.
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class RecipesList extends StatefulWidget {
  @override
  RecipesState createState() => RecipesState();
}
