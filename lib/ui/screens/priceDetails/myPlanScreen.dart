import 'package:flutter/material.dart';

class MyPlanScreen extends StatelessWidget {
  final String currentPlan = 'Standard Plan';
  final String renewalDate = 'December 15, 2024';
  final List<String> features = [
    'Access to all basic features',
    'Priority support',
    '10 GB cloud storage',
    'Team collaboration'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Plan',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentPlan,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Renewal Date: $renewalDate',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Features:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: features
                          .map((feature) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Icon(Icons.check, color: Colors.green),
                            SizedBox(width: 8),
                            Expanded(child: Text(feature)),
                          ],
                        ),
                      ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Upgrade Plan screen
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Upgrade Plan option selected'),
                    ));
                  },
                  child: Text('Upgrade Plan'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Manage Plan screen
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Manage Plan option selected'),
                    ));
                  },
                  child: Text('Manage Plan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
