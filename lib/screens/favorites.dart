import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Umami',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF767775),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.black,
        ),
        itemCount: 2,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(
              'https://dev-contentacms.pantheonsite.io/sites/default/files/716259-pxhere.jpg',
            ),
            title: Text('Blue cheese and walnut pizza'),
            subtitle: Text('Snack\nDifficulty: Easy Time: 14 mins'),
            isThreeLine: true,
          );
        },
      ),
    );
  }
}
