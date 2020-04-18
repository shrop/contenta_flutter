import 'package:http/http.dart';
import 'package:json_api/client.dart';
import 'package:json_api/http.dart';
import 'package:json_api/routing.dart';

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
    final response = await client.fetchCollection('recipes');
    final recipes = response.data.unwrap();
    httpClient.close();

    return recipes;
  }
}
