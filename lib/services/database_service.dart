import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a shopping list to Firestore
  Future<void> addShoppingList(Map<String, dynamic> listData) async {
    await _firestore.collection('shoppingLists').add(listData);
  }

  // Fetch all shopping lists
  Stream<QuerySnapshot> getShoppingLists() {
    return _firestore.collection('shoppingLists').snapshots();
  }

  // Update a shopping list
  Future<void> updateShoppingList(String id, Map<String, dynamic> updatedData) async {
    await _firestore.collection('shoppingLists').doc(id).update(updatedData);
  }

  // Delete a shopping list
  Future<void> deleteShoppingList(String id) async {
    await _firestore.collection('shoppingLists').doc(id).delete();
  }
}