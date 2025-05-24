import 'package:flutter/material.dart';

class DealCard extends StatelessWidget {
  const DealCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        ListTile(
          leading: Icon(Icons.local_offer),
          title: Text('50% off on Groceries'),
          subtitle: Text('Valid until 30/06/2025'),
        ),
        ListTile(
          leading: Icon(Icons.fastfood),
          title: Text('Free Burger'),
          subtitle: Text('Valid until 20/06/2025'),
        ),
        ListTile(
          leading: Icon(Icons.local_drink),
          title: Text('Buy 1 Get 1 Free Drink'),
          subtitle: Text('Valid until 20/06/2025'),
        ),
      ],
    ));
  }
}
