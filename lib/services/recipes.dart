import '../models/recipe.dart';
import 'package:http/http.dart';
import 'package:json_api/client.dart';
import 'package:json_api/http.dart';
import 'package:json_api/query.dart';
import 'package:json_api/routing.dart';

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
        parameters: Include(['category', 'image']));

    // Gather list of recipe results.
    final results = response.document.data.unwrap();
    // Gather list of related content (JSON API included).
    final includes = response.document.data.included;

    httpClient.close();

    // Add results to a custom list of objects.
    List recipes = [];
    String category;
    String imageFileName;

    // Process each result and include objects.
    for (var i = 0; i < results.length; i++) {
      for (var x = 0; x < includes.length; x++) {
        // Get the category name from JSON API includes.
        if (results[i].toOne['category'].id == includes[x].id) {
          category = null;
          category = includes[x].attributes['name'];
        }
        // Get the image URL from JSON API includes.
        if (results[i].toOne['image'].id == includes[x].id) {
          imageFileName = null;
          imageFileName = includes[x].attributes['name'];
        }
      }

      // Setup the recipe list of objects.
      recipes.add(Recipe(
          results[i].id,
          results[i].attributes['title'],
          results[i].attributes['difficulty'],
          results[i].attributes['totalTime'],
          category,
          imageFileName));
    }

    return recipes;
  }
}
