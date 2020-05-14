import 'package:http/http.dart';
import 'package:json_api/client.dart';
import 'package:json_api/http.dart';
import 'package:json_api/query.dart';
import 'package:json_api/routing.dart';

class Recipe {
  String id;
  String title;

  Recipe(this.id, this.title);

  @override
  String toString() {
    return '{ ${this.id}, ${this.title} }';
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

    //final categories = response.document.data.included.toList();
    httpClient.close();

    List recipes = [];
    for (var i = 0; i < results.length; i++) {
      recipes.add(Recipe(results[i].id, results[i].attributes['title']));
    }

    return recipes;
  }
}
