import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: 10, // Replace with actual notifications count
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: index % 2 == 0 ? Colors.blue : Colors.orange,
                child: Icon(
                  index % 2 == 0 ? Icons.shopping_cart : Icons.local_offer,
                  color: Colors.white,
                ),
              ),
              title: Text(
                index % 2 == 0
                    ? 'New Deal Available!'
                    : 'Shopping List Updated',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    index % 2 == 0
                        ? 'Check out the new deals on electronics'
                        : 'Your shopping list "Groceries" has been updated',
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '2 hours ago',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              onTap: () {
                // Handle notification tap
              },
            ),
          );
        },
      ),
    );
  }
}
