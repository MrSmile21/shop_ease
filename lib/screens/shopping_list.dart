// lib/screens/shopping_list.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/shopping_list_provider.dart';
import '../widgets/shopping_list_item.dart';
import 'shopping_list_detail.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Provider will automatically handle the subscription in its constructor.
    // No need to call a subscription method here.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Lists'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search lists...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: _buildListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateListDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListView() {
    return Consumer<ShoppingListProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.shoppingLists.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(child: Text(provider.error!));
        }

        final filteredLists = provider.shoppingLists.where((list) {
          final title = (list['title'] as String).toLowerCase();
          final items = (list['items'] as List<dynamic>?)?.map((item) {
                if (item is Map<String, dynamic>) {
                  return item;
                } else if (item is String) {
                  return <String, dynamic>{'name': item};
                } else if (item == null) {
                  return <String, dynamic>{'name': ''};
                }
                return <String, dynamic>{'name': item.toString()};
              }).toList() ??
              <Map<String, dynamic>>[];
          return title.contains(_searchQuery) ||
              items.any((item) => ((item['name'] as String?) ?? '')
                  .toLowerCase()
                  .contains(_searchQuery));
        }).toList();

        return filteredLists.isEmpty && !provider.isLoading
            ? const Center(
                child: Text(
                  'No shopping lists yet\nTap + to create one',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: filteredLists.length,
                itemBuilder: (context, index) {
                  final list = filteredLists[index];
                  return Dismissible(
                    key: ValueKey(list['id']), // Use ValueKey for unique keys
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      provider.deleteShoppingList(list['id']);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${list['title']} deleted'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              // Re-add list with all its original data
                              provider.addShoppingList({
                                'title': list['title'],
                                'items': List<Map<String, dynamic>>.from(
                                    list['items'] ?? []),
                                'category': list['category'],
                                'description': list['description'],
                                'estimatedTotal': list['estimatedTotal'],
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: ShoppingListItem(
                      id: list['id'],
                      title: list['title'],
                      items:
                          (list['items'] is String)
    ? (list['items'] as String)
        .split(',') // Split the string into a list of strings
        .map((s) => {'name': s.trim()}) // Transform each string into a Map<String, dynamic>
        .toList()
    : (list['items'] is List) // Check if it's a List
        ? (list['items'] as List)
            .map((item) {
              // Ensure each item in the list is converted to a Map<String, dynamic>
              if (item is String) {
                // If an item in the list is a String, convert it to a Map
                return {'name': item.trim()};
              } else if (item is Map<String, dynamic>) {
                // If it's already a Map, return it
                return item;
              } else {
                // Handle unexpected types within the list (e.g., numbers, bools)
                print('Warning: Unexpected type in items list: ${item.runtimeType}. Returning empty map.');
                return <String, dynamic>{}; // Return an empty map or handle as appropriate
              }
            })
            .toList()
        : [],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShoppingListDetailScreen(
                              listId: list['id'], // CORRECTED: Pass the list ID
                              listName: list['title'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
      },
    );
  }

  void _showCreateListDialog(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New List'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'List Name',
              hintText: 'Enter list name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.list),
            ),
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a list name';
              }
              final provider =
                  Provider.of<ShoppingListProvider>(context, listen: false);
              if (provider.shoppingLists.any((list) =>
                  list['title'].toLowerCase() == value.trim().toLowerCase())) {
                return 'A list with this name already exists';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final name = _nameController.text.trim();
                final provider =
                    Provider.of<ShoppingListProvider>(context, listen: false);
                // Call addShoppingList with a Map, providing initial data
                provider.addShoppingList(<String, dynamic>{
                  'title': name,
                  'items': <Map<String,
                      dynamic>>[], // Initialize with an empty list of items
                  'category': 'General',
                  'description': '',
                  'estimatedTotal': 0.0,
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$name list created successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
