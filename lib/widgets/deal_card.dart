import 'package:flutter/material.dart';

class DealCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.local_offer),
        title: Text('50% Off on Groceries'),
        subtitle: Text('Valid until 12/31/2023'),
      ),
    );
  }
}