import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:json_api/json_api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RecipesList(),
    );
  }
}

class RecipesState extends State<RecipesList> {

  Future<List> recipeResults() async {
    // Get recipes from the Contenta CMS API.
    final resultsList = new List();
    final httpClient = Client();
    final jsonApiClient = JsonApiClient(httpClient);
    final companiesUri = Uri.parse('https://dev-contentacms.pantheonsite.io/api/recipes');
    final response = await jsonApiClient.fetchCollection(companiesUri);
    httpClient.close();

    // Get and return a list of Recipe titles.
    final resource = response.data.unwrap().asMap();
    resource.forEach((k, v) => resultsList.add(resource[k].attributes["title"]));
    return resultsList;
  }

  @override
  Widget build(BuildContext context) {
    final bool alreadySaved = false;
    return Scaffold (
      appBar: AppBar(
        title: Text('Recipe Magazine'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: null),
        ],
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
                    return new Column(
                      children: <Widget>[
                        new ListTile(
                          leading: Icon(Icons.image),
                          title: new Text(
                            snapshot.data[index],
                          ),
                          trailing: Icon(   // Add the lines from here...
                            alreadySaved ? Icons.favorite : Icons.favorite_border,
                            color: alreadySaved ? Colors.red : null,
                          ),
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