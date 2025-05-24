// lib/services/shopping_list_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'firebase_service.dart'; // Ensure this path is correct

class ShoppingListProvider with ChangeNotifier {
  final FirebaseService _firebaseService; // This should be injected

  List<Map<String, dynamic>> _shoppingLists = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _shoppingListSubscription;

  // Constructor now requires FirebaseService
  ShoppingListProvider(this._firebaseService) {
    // Inject FirebaseService
    _subscribeToShoppingLists();
  }

  List<Map<String, dynamic>> get shoppingLists => _shoppingLists;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _subscribeToShoppingLists() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _shoppingListSubscription?.cancel();

    _shoppingListSubscription =
        _firebaseService.getShoppingListsStream().listen(
      (snapshot) {
        _shoppingLists = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            ...data,
          };
        }).toList();
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Failed to load shopping lists: $e';
        _isLoading = false;
        notifyListeners();
        print('Error subscribing to shopping lists: $e');
      },
    );
  }

  // Add methods for CRUD operations (these will interact with Firestore)
  // FIX: Change parameter from String to Map<String, dynamic>
  Future<void> addShoppingList(Map<String, dynamic> listData) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firebaseService.addShoppingList(listData);
      _error = null;
    } catch (e) {
      _error = 'Failed to add shopping list: $e';
      print('Error adding shopping list: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteShoppingList(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Use _firebaseService for deletion
      await _firebaseService.deleteShoppingList(id);
      _error = null;
    } catch (e) {
      _error = 'Failed to delete shopping list: $e';
      print('Error deleting shopping list: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to get items for a specific shopping list
  Future<List<Map<String, dynamic>>> getShoppingListItems(String listId) async {
    try {
      final doc = await _firebaseService.getShoppingList(listId);
      if (doc.exists) {
        return List<Map<String, dynamic>>.from(doc.get('items') ?? []);
      }
      return [];
    } catch (e) {
      print('Error fetching shopping list items: $e');
      return [];
    }
  }

  // Method to add an item to a specific shopping list
  Future<void> addItemToShoppingList(
      String listId, Map<String, dynamic> newItem) async {
    _isLoading = true;
    notifyListeners();
    try {
      final currentItems = await getShoppingListItems(listId);
      final updatedItems = [...currentItems, newItem];
      await _firebaseService.updateShoppingListItems(listId, updatedItems);
      _error = null;
    } catch (e) {
      _error = 'Failed to add item to shopping list: $e';
      print('Error adding item to shopping list: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to update an item's status (e.g., completed)
  Future<void> updateShoppingListItemStatus(
      String listId, String itemName, bool completed) async {
    _isLoading = true;
    notifyListeners();
    try {
      final currentItems = await getShoppingListItems(listId);
      final updatedItems = currentItems.map((item) {
        if (item['name'] == itemName) {
          return {...item, 'completed': completed};
        }
        return item;
      }).toList();
      await _firebaseService.updateShoppingListItems(listId, updatedItems);
      _error = null;
    } catch (e) {
      _error = 'Failed to update item status: $e';
      print('Error updating item status: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to delete an item from a shopping list
  Future<void> deleteItemFromShoppingList(
      String listId, String itemName) async {
    _isLoading = true;
    notifyListeners();
    try {
      final currentItems = await getShoppingListItems(listId);
      final updatedItems =
          currentItems.where((item) => item['name'] != itemName).toList();
      await _firebaseService.updateShoppingListItems(listId, updatedItems);
      _error = null;
    } catch (e) {
      _error = 'Failed to delete item: $e';
      print('Error deleting item from list: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _shoppingListSubscription?.cancel();
    super.dispose();
  }
}
