import 'package:contenta_flutter/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(RecipesApp());
}

class RecipesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Umami Recipes',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: ChangeNotifierProvider<BottomNavProvider>(
        child: BottomNav(),
        create: (BuildContext context) => BottomNavProvider(),
      ),
    );
  }
}

