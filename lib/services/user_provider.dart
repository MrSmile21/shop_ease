import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Map<String, dynamic>? get userProfile => _user?.toMap();

  Future<void> fetchUserProfile(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final docSnapshot =
          await _firestore.collection('users').doc(userId).get();

      if (docSnapshot.exists) {
        _user = UserModel.fromMap(docSnapshot.data()!);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('users').doc(userId).update(data);
      await fetchUserProfile(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear user data on logout
  void clearUser() {
    _user = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  void clearUserData() {
    _user = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
