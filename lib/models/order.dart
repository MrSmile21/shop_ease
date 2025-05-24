import 'package:cloud_firestore/cloud_firestore.dart';

class AppOrder {
  final String id;
  final String status;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final DateTime orderDate;

  AppOrder({
    required this.id,
    required this.status,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.orderDate,
  });

  // Factory constructor to create an Order object from a Firestore DocumentSnapshot
  factory AppOrder.fromFirestore(DocumentSnapshot doc) {
    // Cast data to Map<String, dynamic>
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("Document data was null for Order ID: ${doc.id}");
    }

    // Safely extract data, providing default values if null
    return AppOrder(
      id: doc.id, // Firestore document ID
      status: data['status'] as String? ?? 'unknown',
      productName: data['productName'] as String? ?? 'No Name',
      productImage: data['productImage'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0, // Cast to num then to double
      quantity: (data['quantity'] as int?) ?? 0,
      orderDate: (data['orderDate'] as Timestamp?)?.toDate() ?? DateTime.now(), // Convert Timestamp to DateTime
    );
  }

  // Method to convert an Order object to a Map<String, dynamic> for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'status': status,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
      'orderDate': Timestamp.fromDate(orderDate), // Convert DateTime to Timestamp
    };
  }

  // Optional: For debugging or logging
  @override
  String toString() {
    return 'Order(id: $id, status: $status, productName: $productName, price: $price, quantity: $quantity, orderDate: $orderDate)';
  }
}