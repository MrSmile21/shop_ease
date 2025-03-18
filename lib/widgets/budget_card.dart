import 'package:flutter/material.dart';

class BudgetCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Monthly Budget', style: TextStyle(fontSize: 18)),
            LinearProgressIndicator(value: 0.7),
            Text('\$450 remaining of \$1500'),
          ],
        ),
      ),
    );
  }
}