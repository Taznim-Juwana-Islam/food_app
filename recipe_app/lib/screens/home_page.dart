import 'package:flutter/material.dart';
import 'recipe_details_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe App')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecipeDetailsPage()),
            );
          },
          child: Text('Go to Recipe Details'),
        ),
      ),
    );
  }
}
