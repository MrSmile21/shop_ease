import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/shopping_list_provider.dart';
import '../widgets/shopping_list_item.dart';

class ShoppingListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shoppingListProvider = Provider.of<ShoppingListProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Shopping List')),
      body: shoppingListProvider.shoppingLists.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: shoppingListProvider.shoppingLists.length,
              itemBuilder: (context, index) {
                final list = shoppingListProvider.shoppingLists[index];
                return ShoppingListItem(
                  title: list['name'], // Pass the title
                  items: List<String>.from(list['items']), // Pass the items
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await shoppingListProvider.addShoppingList({
            'name': 'New List',
            'items': ['Item 1', 'Item 2'],
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}