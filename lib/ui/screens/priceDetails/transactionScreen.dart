import 'package:flutter/material.dart';

import 'model/transaction.dart';

class TransactionHistoryScreen extends StatefulWidget {
  @override
  _TransactionHistoryScreenState createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final List<Transaction> transactions = [
    Transaction(date: '2024-01-15', amount: 9.99, status: 'Completed'),
    Transaction(date: '2024-02-15', amount: 9.99, status: 'Completed'),
    Transaction(date: '2024-03-15', amount: 9.99, status: 'Pending'),
    Transaction(date: '2024-04-15', amount: 19.99, status: 'Completed'),
    // Add more transactions here...
  ];

  String? _selectedStatus;
  DateTimeRange? _selectedDateRange;

  List<Transaction> get _filteredTransactions {
    return transactions.where((transaction) {
      if (_selectedStatus != null && transaction.status != _selectedStatus) {
        return false;
      }
      if (_selectedDateRange != null) {
        final transactionDate = DateTime.parse(transaction.date);
        return transactionDate.isAfter(_selectedDateRange!.start) &&
            transactionDate.isBefore(_selectedDateRange!.end);
      }
      return true;
    }).toList();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  void _selectStatus(String? status) {
    setState(() {
      _selectedStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _selectDateRange(context),
                  child: Text(_selectedDateRange == null
                      ? 'Select Date Range'
                      : '${_selectedDateRange!.start.toString().split(' ')[0]} - ${_selectedDateRange!.end.toString().split(' ')[0]}'),
                ),
                DropdownButton<String>(
                  hint: Text('Filter by Status'),
                  value: _selectedStatus,
                  items: ['Completed', 'Pending', 'Failed']
                      .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                  onChanged: _selectStatus,
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = _filteredTransactions[index];
                  return Card(
                    child: ListTile(
                      title: Text('Amount: \$${transaction.amount.toStringAsFixed(2)}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${transaction.date}'),
                          Text('Status: ${transaction.status}'),
                        ],
                      ),
                      trailing: Icon(
                        transaction.status == 'Completed'
                            ? Icons.check_circle
                            : Icons.hourglass_empty,
                        color: transaction.status == 'Completed'
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
