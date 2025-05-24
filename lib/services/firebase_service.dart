import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Shopping Lists
  Stream<QuerySnapshot> getShoppingListsStream() {
    return _firestore
        .collection('shopping_lists')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<List<Map<String, dynamic>>> getShoppingLists() async {
    try {
      final snapshot = await _firestore
          .collection('shopping_lists')
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {...data, 'id': doc.id};
      }).toList();
    } catch (e) {
      print('Error getting shopping lists: $e');
      throw Exception('Failed to fetch shopping lists');
    }
  }

  Future<void> addShoppingList(Map<String, dynamic> list) async {
    try {
      await _firestore.collection('shopping_lists').add({
        'title': list['title'] ?? '',
        'category': list['category'] ?? 'General',
        'description': list['description'] ?? '',
        'estimatedTotal': list['estimatedTotal'] ?? 0.0,
        'items': list['items'] ?? [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding shopping list: $e');
      throw Exception('Failed to add shopping list');
    }
  }

  Future<void> updateShoppingListItems(
      String listId, List<Map<String, dynamic>> items) async {
    try {
      await _firestore.collection('shopping_lists').doc(listId).update({
        'items': items,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating shopping list items: $e');
      throw Exception('Failed to update shopping list items');
    }
  }

  Future<DocumentSnapshot> getShoppingList(String listId) async {
    try {
      final docSnapshot =
          await _firestore.collection('shopping_lists').doc(listId).get();
      if (!docSnapshot.exists) {
        throw Exception('Shopping list not found');
      }
      return docSnapshot;
    } catch (e) {
      print('Error getting shopping list: $e');
      throw Exception('Failed to fetch shopping list');
    }
  }

  Future<void> updateShoppingList(
      String listId, Map<String, dynamic> list) async {
    try {
      await _firestore.collection('shopping_lists').doc(listId).update({
        'title': list['title'],
        'category': list['category'],
        'description': list['description'],
        'estimatedTotal': list['estimatedTotal'],
        'items': list['items'],
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating shopping list: $e');
      throw Exception('Failed to update shopping list');
    }
  }

  Future<void> deleteShoppingList(String listId) async {
    try {
      await _firestore.collection('shopping_lists').doc(listId).delete();
    } catch (e) {
      print('Error deleting shopping list: $e');
      throw Exception('Failed to delete shopping list');
    }
  }

  // User Profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

  // Deals
  Stream<QuerySnapshot> getDealsStream() {
    return _firestore.collection('deals').snapshots();
  }

  // Stats
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      final doc = await _firestore.collection('user_stats').doc(userId).get();
      return doc.data() ?? {};
    } catch (e) {
      print('Error getting user stats: $e');
      return {};
    }
  }
}
