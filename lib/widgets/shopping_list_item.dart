import 'package:flutter/material.dart';

class ShoppingListItem extends StatelessWidget {
  final String id;
  final String title;
  final List<Map<String, dynamic>> items;
  final VoidCallback onTap;

  const ShoppingListItem({
    super.key,
    required this.id,
    required this.title,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
          vertical: 8, horizontal: 16), // Add margin for better spacing
      elevation: 2, // Add a slight shadow
      child: ExpansionTile(
        leading: Icon(Icons.shopping_cart, color: Colors.blue), // Add an icon
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16), // Bold and larger text
        ),
        children: [
          Divider(height: 1, thickness: 1), // Add a divider
          ...items.map((item) => ListTile(
                leading: Icon(
                  item['completed'] == true
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: item['completed'] == true ? Colors.green : Colors.grey,
                ),
                title: Text(
                  item['name'],
                  style: TextStyle(
                    fontSize: 14,
                    decoration: item['completed'] == true
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              )),
        ],
        onExpansionChanged: (expanded) {
          // Call onTap when the expansion tile is tapped
          if (expanded) {
            onTap();
          }
        },
      ),
    );
  }
}
