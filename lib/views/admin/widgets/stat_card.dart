import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final int count;

  const StatCard({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        width: 100,
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
