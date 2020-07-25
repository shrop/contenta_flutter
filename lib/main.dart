import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contenta_flutter/shared/bottom_nav.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => BottomNavProvider())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Decoupled Days Recipes',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        home: BottomNav());
  }
}
