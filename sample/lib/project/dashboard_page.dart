import 'package:flutter/material.dart';
import 'package:flutter_application_1/project/my_profile_page.dart';
import 'package:intl/intl.dart';
import 'transactions_content.dart';
import 'settings_content.dart';
import 'dashboard_content.dart';

class DashboardPage extends StatefulWidget {
  final String phoneNumber;

  DashboardPage({required this.phoneNumber});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> transactions = [
    {'name': 'Avaez', 'dateTime': 'Aug 24, 2024 - 12:30 PM', 'amount': 100.00, 'vpa': 'avaez@bank'},
    {'name': 'Adithya', 'dateTime': 'Aug 27, 2024 - 01:15 PM', 'amount': 200, 'vpa': 'adithy@bob'},
    {'name': 'Charlie', 'dateTime': 'Aug 24, 2024 - 02:00 PM', 'amount': 50.75, 'vpa': 'charlie@cnrb'},
    {'name': 'Rahid', 'dateTime': 'Aug 24, 2024 - 02:45 PM', 'amount': 120.00, 'vpa': 'rahid@jana'},
    {'name': 'Ibrahim', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ibrahim@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},{'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    {'name': 'ronaldo', 'dateTime': 'Aug 26, 2024 - 03:30 PM', 'amount': 750, 'vpa': 'ronaldo@hdfc'},
    
    
  ];

  int get totalTransactions => transactions.length;

  double get totalAmount => transactions.fold(0, (sum, transaction) => sum + transaction['amount']);

  void _handleMenuSelection(String value) {
    if (value == 'profile') {
      // Handle My Profile action
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyProfilePage()),
      );
    } else if (value == 'signout') {
      // Handle Sign Out action
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());
    String firstLetter = widget.phoneNumber.isNotEmpty ? widget.phoneNumber[0] : '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 218, 16, 126),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'profile',
                  child: Text('My Profile'),
                ),
                PopupMenuItem<String>(
                  value: 'signout',
                  child: Text('Sign Out'),
                ),
              ];
            },
            child: Padding(

              padding: const EdgeInsets.all(8.0),
              child: Row(

                children: [
                
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      firstLetter,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    widget.phoneNumber,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        title: Text(
          _selectedIndex == 0
              ? 'Dashboard'
              : _selectedIndex == 1
                  ? 'Transactions'
                  : 'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _selectedIndex != 2
          ? CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.yellow[300],
                  expandedHeight: 60.0,
                  flexibleSpace: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'This application shows only today\'s transactions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.white,
                  expandedHeight: 60.0,
                  flexibleSpace: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'AS OF',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 218, 16, 126),
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Text(
                                currentDate,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Today',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 218, 16, 126),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  
                  child: Padding(
                    
                    
                    padding: const EdgeInsets.all(16.0),
                    child: _selectedIndex == 0
                        ? DashboardContent(
                          
                            totalTransactions: totalTransactions,
                            totalAmount: totalAmount, transactions: [],
                          )
                        : _selectedIndex == 1
                            ? TransactionsContent(transactions: transactions, allTransactions: [],)
                            : SettingsContent(),
                  ),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SettingsContent(),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
