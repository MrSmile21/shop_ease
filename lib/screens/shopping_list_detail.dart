import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import '../services/shopping_list_provider.dart'; // Import ShoppingListProvider
import '../services/firebase_service.dart'; // Import FirebaseService

class ShoppingListDetailScreen extends StatefulWidget {
  final String listId;
  final String listName;

  const ShoppingListDetailScreen({
    super.key,
    required this.listId,
    required this.listName,
  });

  @override
  State<ShoppingListDetailScreen> createState() =>
      _ShoppingListDetailScreenState();
}

class _ShoppingListDetailScreenState extends State<ShoppingListDetailScreen> {
  // FIX: Get FirebaseService from Provider instead of instantiating directly
  late final FirebaseService _firebaseService;
  late final ShoppingListProvider _shoppingListProvider;

  List<Map<String, dynamic>> _items = [];
  final TextEditingController _itemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to access Provider safely after build method has run
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _firebaseService = Provider.of<FirebaseService>(context, listen: false);
      _shoppingListProvider = Provider.of<ShoppingListProvider>(context, listen: false);
      _loadItems();
    });
  }

  Future<void> _loadItems() async {
    // FIX: Use _shoppingListProvider to get items
    final fetchedItems = await _shoppingListProvider.getShoppingListItems(widget.listId);
    setState(() {
      _items = fetchedItems;
    });
  }

  Future<void> _addItem(String name) async {
    if (name.trim().isNotEmpty) {
      final newItem = {
        'name': name.trim(),
        'completed': false,
      };
      // FIX: Use _shoppingListProvider to add item
      await _shoppingListProvider.addItemToShoppingList(widget.listId, newItem);
      _itemController.clear();
      _loadItems(); // Refresh items after adding
    }
  }

  Future<void> _toggleItemStatus(String itemName, bool completed) async {
    // FIX: Use _shoppingListProvider to update item status
    await _shoppingListProvider.updateShoppingListItemStatus(widget.listId, itemName, completed);
    _loadItems(); // Refresh items after updating
  }

  Future<void> _deleteItem(String itemName) async {
    // FIX: Use _shoppingListProvider to delete item
    await _shoppingListProvider.deleteItemFromShoppingList(widget.listId, itemName);
    _loadItems(); // Refresh items after deleting
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listName),
      ),
      body: Column(
        children: [
          Expanded(
            child: _items.isEmpty
                ? const Center(
                    child: Text(
                      'No items in this list\nTap + to add items',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Dismissible(
                        key: Key(item['name']),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _deleteItem(item['name']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item['name']} removed'),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: CheckboxListTile(
                            title: Text(
                              item['name'],
                              style: TextStyle(
                                decoration: item['completed']
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: item['completed'] ? Colors.grey : null,
                              ),
                            ),
                            value: item['completed'],
                            onChanged: (bool? newValue) {
                              if (newValue != null) {
                                _toggleItemStatus(item['name'], newValue);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Item'),
              content: TextField(
                controller: _itemController,
                decoration: const InputDecoration(
                  labelText: 'Item name',
                  hintText: 'Enter item name',
                ),
                autofocus: true,
                onSubmitted: (value) {
                  _addItem(value);
                  Navigator.pop(context);
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _addItem(_itemController.text);
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}