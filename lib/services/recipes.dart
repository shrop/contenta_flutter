import 'package:json_api/client.dart';
import 'package:http/http.dart';

Future<Map> recipeResults() async {
  // Get recipes from the Contenta CMS API.
  final httpClient = Client();
  final jsonApiClient = JsonApiClient(httpClient);
  final recipesUri =
      Uri.parse('https://dev-contentacms.pantheonsite.io/api/recipes');
  final response = await jsonApiClient.fetchCollection(recipesUri);
  httpClient.close();

  final results = response.data.unwrap().asMap();
  return results;
}
