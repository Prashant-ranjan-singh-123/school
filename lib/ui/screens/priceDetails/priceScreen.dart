import 'package:flutter/material.dart';

class PricingScreen extends StatefulWidget {
  @override
  _PricingScreenState createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  int? _selectedPlanIndex;

  final List<Map<String, String>> pricingPlans = [
    {
      'title': 'Basic',
      'price': '\$9.99/month',
      'description': 'Essential features for individuals.',
    },
    {
      'title': 'Standard',
      'price': '\$19.99/month',
      'description': 'Great for small teams and startups.',
    },
    {
      'title': 'Premium',
      'price': '\$29.99/month',
      'description': 'Full features for larger organizations.',
    },
  ];

  void _selectPlan(int index) {
    setState(() {
      _selectedPlanIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pricing Plans'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: pricingPlans.length,
                itemBuilder: (context, index) {
                  final plan = pricingPlans[index];
                  final isSelected = _selectedPlanIndex == index;

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: isSelected
                          ? BorderSide(color: Colors.blue, width: 2)
                          : BorderSide.none,
                    ),
                    child: ListTile(
                      title: Text(
                        plan['title']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.blue : Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(plan['price']!),
                          SizedBox(height: 4),
                          Text(plan['description']!),
                        ],
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_circle, color: Colors.blue)
                          : Icon(Icons.circle_outlined),
                      onTap: () => _selectPlan(index),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedPlanIndex != null
                  ? () {
                // Handle subscription logic here
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Subscribed to ${pricingPlans[_selectedPlanIndex!]['title']} Plan'),
                ));
              }
                  : null,
              child: Text('Subscribe'),
            ),
          ],
        ),
      ),
    );
  }
}