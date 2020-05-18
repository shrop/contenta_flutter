import 'package:http/http.dart';
import 'package:json_api/client.dart';
import 'package:json_api/http.dart';
import 'package:json_api/query.dart';
import 'package:json_api/routing.dart';

/// Recipe data model.
class Recipe {
  final String id;
  String title;
  String difficulty;
  final int totalTime;
  String category;

  Recipe(this.id, this.title, this.difficulty, this.totalTime, this.category) {
    title ??= 'No title available.';
    difficulty ??= 'N/A';
    category ??= 'N/A';
  }
}

/// Get recipes from the Contenta CMS API and return with a custom data model.
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

    // Gather list of recipe results.
    final results = response.document.data.unwrap();
    // Gather list of related content (JSON API included).
    final includes = response.document.data.included;

    httpClient.close();

    List recipes = [];
    String category;

    for (var i = 0; i < results.length; i++) {
      // Get category name from JSON API includes.
      for (var x = 0; x < includes.length; x++) {
        if (results[i].toOne['category'].id == includes[x].id) {
          category = null;
          category = includes[x].attributes['name'];
        }
      }

      // Setup the recipe list of objects.
      recipes.add(Recipe(
          results[i].id,
          results[i].attributes['title'],
          results[i].attributes['difficulty'],
          results[i].attributes['totalTime'],
          category));
    }

    return recipes;
  }
}
