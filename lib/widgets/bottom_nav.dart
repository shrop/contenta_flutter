import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contenta_flutter/screens/home.dart';
import 'package:contenta_flutter/screens/favorites.dart';
import 'package:contenta_flutter/screens/about.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  var currentTab = [
    HomePage(),
    FavoritesPage(),
    AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<BottomNavProvider>(context);
    return Scaffold(
      body: currentTab[provider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[400],
        selectedItemColor: Color(0xFFED652C),
        unselectedItemColor: Colors.white,
        currentIndex: provider.currentIndex,
        onTap: (index) {
          provider.currentIndex = index;
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Recipes'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favorites'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            title: Text('About'),
          ),
        ],
      ),
    );
  }
}

class BottomNavProvider with ChangeNotifier {
  int _currentIndex = 0;

  get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
