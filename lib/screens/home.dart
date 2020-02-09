import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Umami Recipes'),
      ),
      body: Text(
        "Hello Recipes!"
      ),
    );
  }
}
