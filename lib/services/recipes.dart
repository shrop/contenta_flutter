import 'package:http/http.dart';
import 'package:json_api/client.dart';
import 'package:json_api/http.dart';
import 'package:json_api/query.dart';
import 'package:json_api/routing.dart';

class Recipe {
  String id;
  String title;
  String difficulty;
  int totalTime;

  Recipe(this.id, this.title, this.difficulty, this.totalTime);

  @override
  String toString() {
    return '{ ${this.id}, ${this.title}, ${this.difficulty}, ${this.totalTime} }';
  }
}

class RecipeService {
  Future<List> fetchRecipes() async {
    // Get recipes from the Contenta CMS API.
    final routing = StandardRouting(
        Uri.parse('https://dev-contentacms.pantheonsite.io/api/'));
    final httpClient = Client();
    // Some helping logging.
    final httpHandler = LoggingHttpHandler(DartHttp(httpClient),
        onRequest: (r) => print('${r.method} ${r.uri}'),
        onResponse: (r) => print('${r.statusCode}'));
    final client = RoutingClient(JsonApiClient(httpHandler), routing);
    final response = await client.fetchCollection('recipes',
        parameters: Include(['category']));
    final results = response.document.data.unwrap();

    httpClient.close();

    List recipes = [];
    for (var i = 0; i < results.length; i++) {
      // @TODO Get category name from JSON API includes.

      // Add Recipe data to a Recipe object in a list.
      recipes.add(Recipe(
          results[i].id,
          results[i].attributes['title'],
          results[i].attributes['difficulty'],
          results[i].attributes['totalTime']));
    }

    return recipes;
  }
}
