import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SaleReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sale Report'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('From:'),
                          SizedBox(width: 5),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: '13/1/2025',
                                suffixIcon: Icon(Icons.calendar_today),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text('To:'),
                          SizedBox(width: 5),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: '13/1/2025',
                                suffixIcon: Icon(Icons.calendar_today),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Show'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search Here',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Table(
            border: TableBorder.all(),
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(3),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(2),
              5: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey[200]),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Date'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Bill No'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Customer Name'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Phone'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Bill Amount'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Action'),
                  ),
                ],
              ),
              // Add more TableRow for data
            ],
          ),
          // Add a Floating Action Button or other widgets as needed
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.add),
                backgroundColor: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}