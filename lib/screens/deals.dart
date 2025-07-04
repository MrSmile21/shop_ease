import 'package:flutter/material.dart';
import '../widgets/deal_card.dart';

class DealsScreen extends StatelessWidget {
  const DealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Deals')),
      body: ListView.builder(
        itemCount: 1, // Replace with actual deals length
        itemBuilder: (context, index) => DealCard(),
      ),
    );
  }
}