import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:json_api/json_api.dart';

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
          future: recipeResults(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              // List Recipe titles.
              return new ListView.builder
                (
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    final bool alreadySaved = _saved.contains(snapshot.data[index].id); // Add 9 lines from here...

                    return new Column(
                      children: <Widget>[
                        new ListTile(
                          leading: Icon(Icons.image),
                          title: new Text(
                            snapshot.data[index].attributes['title'],
                          ),
                          trailing: Icon(   // Add the lines from here...
                            alreadySaved ? Icons.favorite : Icons.favorite_border,
                            color: alreadySaved ? Colors.red : null,
                          ),
                          onTap: () {
                            setState(() {
                              if (alreadySaved) {
                                _saved.remove(snapshot.data[index].id);
                              } else {
                                _saved.add(snapshot.data[index].id);
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