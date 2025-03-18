import 'package:flutter/material.dart';

class ShoppingListItem extends StatelessWidget {
  final String title;
  final List<String> items;

  // Constructor with named parameters
  ShoppingListItem({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Add margin for better spacing
      elevation: 2, // Add a slight shadow
      child: ExpansionTile(
        leading: Icon(Icons.shopping_cart, color: Colors.blue), // Add an icon
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // Bold and larger text
        ),
        children: [
          Divider(height: 1, thickness: 1), // Add a divider
          ...items.map((item) => ListTile(
            leading: Icon(Icons.check_box_outline_blank, color: Colors.grey), // Add a checkbox icon
            title: Text(
              item,
              style: TextStyle(fontSize: 14), // Smaller text for items
            ),
          )).toList(),
        ],
      ),
    );
  }
}