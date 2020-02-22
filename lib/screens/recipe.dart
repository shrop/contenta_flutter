import 'package:flutter/material.dart';

class RecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Recipe Detail',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey[400],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Image.network(
                'https://dev-contentacms.pantheonsite.io/sites/default/files/716259-pxhere.jpg',
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Icon(Icons.favorite),
                  Icon(Icons.share),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(30.0),
              alignment: Alignment.topCenter,
              child: Text(
                "Blue cheese and walnut pizza",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: Text(
                "Category: Snack\nDifficulty: Easy\nTime: 14 mins",
              ),
            ),
            Container(
              margin: EdgeInsets.all(30.0),
              alignment: Alignment.topCenter,
              child: Text(
                "Ingredients: Olive oil, portion of pizza dough - makes 2 pizzas, 150 g Saint Agur Blue cheese, crumbled, 6 tablespoons of crushed walnuts",
              ),
            ),
            Container(
              margin: EdgeInsets.all(30.0),
              alignment: Alignment.topCenter,
              child: Text(
                "Instructions: Make 1 pizza per person.,Dust your work surface with fine yellow cornmeal.,Divide the pizza dough into two and roll out into two thin 25.5 cm (10 inch) pizzas.,Prick the pizza all over with a fork. This prevents it puffing up too much and burning while it is cooking.,Place the pizza dough on a pizza peel that has been dusted with fine yellow cornmeal.,Preheat the pizza stone under a very hot grill.,With a deft move, slide the pizza dough from the pizza peel, on to the preheated pizza stone.,Cook for about 2 minutes on one side only, until lightly browned.,Remove from the oven.,Drizzle the top of the pizza with a little olive oil.,Arrange the walnuts over the pizza and top with the crumbled blue cheese.,Bake the pizza until the cheese starts to melt and bubble-this only takes a few minutes under a very hot grill.,Keep the fist pizza warm at the bottom of the oven whilst you make the second.",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
