import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contenta_flutter/shared/bottom_nav.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
