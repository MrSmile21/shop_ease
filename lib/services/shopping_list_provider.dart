import 'package:flutter/material.dart';
import 'database_service.dart';

class ShoppingListProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Map<String, dynamic>> _shoppingLists = [];

  List<Map<String, dynamic>> get shoppingLists => _shoppingLists;

  Future<void> fetchShoppingLists() async {
    final snapshot = await _databaseService.getShoppingLists().first;
    _shoppingLists = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    notifyListeners();
  }

  Future<void> addShoppingList(Map<String, dynamic> listData) async {
    await _databaseService.addShoppingList(listData);
    await fetchShoppingLists();
  }
}