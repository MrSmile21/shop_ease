import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

class DealsProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> _deals = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<QuerySnapshot>? _dealsSubscription;

  List<Map<String, dynamic>> get deals => _deals;
  bool get isLoading => _isLoading;
  String? get error => _error;

  DealsProvider() {
    _subscribeToDeals();
  }

  void _subscribeToDeals() {
    _isLoading = true;
    notifyListeners();

    try {
      _dealsSubscription = _firebaseService.getDealsStream().listen(
        (snapshot) {
          _deals = snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          _isLoading = false;
          notifyListeners();
        },
        onError: (error) {
          _error = 'Failed to fetch deals';
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _error = 'Failed to subscribe to deals';
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _dealsSubscription?.cancel();
    super.dispose();
  }
}
