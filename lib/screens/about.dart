import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(30.0),
              alignment: Alignment.topCenter,
              child: Image.asset('assets/images/logo.png'),
            ),
            Container(
              margin: EdgeInsets.all(30.0),
              alignment: Alignment.topCenter,
              child: Image.asset('assets/images/umami-bundle.png'),
            ),
            Container(
              margin: EdgeInsets.all(30.0),
              alignment: Alignment.topCenter,
              child: Text(
                "Umami is a fictional food magazine that has been created to demonstrate how you might build a Drupal site using functionality provided 'out of the box'.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
