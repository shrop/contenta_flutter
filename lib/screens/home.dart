import 'package:contenta_flutter/screens/recipe.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Umami Recipes'),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.black,
        ),
        itemCount: 20,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(
              'https://dev-contentacms.pantheonsite.io/sites/default/files/716259-pxhere.jpg',
            ),
            title: Text('Blue cheese and walnut pizza'),
            subtitle: Text('Snack\nDifficulty: Easy Time: 14 mins'),
            isThreeLine: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipePage()),
              );
            },
          );
        },
      ),
    );
  }
}
