import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class TransactionsContent extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;

  TransactionsContent({required this.transactions, required List allTransactions});

  @override
  _TransactionsContentState createState() => _TransactionsContentState();
}

class _TransactionsContentState extends State<TransactionsContent> {
  static const int _pageSize = 6; // Define batch size
  final PagingController<int, Map<String, dynamic>> _pagingController =
      PagingController(firstPageKey: 0); // Start from page 0

  List<Map<String, dynamic>> _filteredTransactions = [];
  double _filteredTotalAmount = 0.0;

  String? _selectedFilter;
  String? _selectedValue;
  String? _searchQuery;
  List<String> _dropdownValues = [];
  bool _isOkButtonEnabled = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredTransactions = widget.transactions;
    _pagingController.addPageRequestListener((pageKey) {
      _loadTransactions(pageKey); // Trigger to load transactions
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadTransactions(int pageKey) {
    // Calculate the start index and the end index for the next batch of data
    final startIndex = pageKey;
    final endIndex = startIndex + _pageSize;

    // Simulate loading data with a delay (e.g., API call can be made here)
    Future.delayed(Duration(seconds: 2), () {
      final newItems = _filteredTransactions
          .skip(startIndex)
          .take(_pageSize)
          .toList(); // Get the next batch

      final isLastPage = newItems.length < _pageSize; // Check if it's the last page
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey); // Load next page
      }

      // Recalculate the filtered total amount
      _filteredTotalAmount = _calculateTotalAmount(_pagingController.itemList ?? []);
    });
  }

  double _calculateTotalAmount(List<Map<String, dynamic>> transactions) {
    return transactions.fold(0, (sum, transaction) => sum + transaction['amount']);
  }

  void _filterTransactions() {
    setState(() {
      if (_selectedFilter != null && _selectedValue != null) {
        _filteredTransactions = widget.transactions.where((transaction) {
          if (_selectedFilter == 'Name') {
            return transaction['name'] == _selectedValue;
          } else if (_selectedFilter == 'Date') {
            return transaction['dateTime'] == _selectedValue;
          } else if (_selectedFilter == 'VPA') {
            return transaction['vpa'] == _selectedValue;
          }
          return false;
        }).toList();
      } else {
        _filteredTransactions = widget.transactions;
      }

      _pagingController.refresh(); // Refresh the list to apply filter
      _filteredTotalAmount = _calculateTotalAmount(_filteredTransactions);

      _selectedFilter = null;
      _selectedValue = null;
      _searchQuery = null;
      _dropdownValues.clear();
      _searchController.clear();
      _isOkButtonEnabled = false;
    });
  }

  void _updateDropdownValues() {
    setState(() {
      if (_selectedFilter != null) {
        if (_selectedFilter == 'Name') {
          _dropdownValues = widget.transactions
              .map((transaction) => transaction['name'] as String)
              .toSet()
              .toList();
        } else if (_selectedFilter == 'Date') {
          _dropdownValues = widget.transactions
              .map((transaction) => transaction['dateTime'] as String)
              .toSet()
              .toList();
        } else if (_selectedFilter == 'VPA') {
          _dropdownValues = widget.transactions
              .map((transaction) => transaction['vpa'] as String)
              .toSet()
              .toList();
        }

        if (_searchQuery != null && _searchQuery!.isNotEmpty) {
          _dropdownValues = _dropdownValues
              .where((value) =>
                  value.toLowerCase().contains(_searchQuery!.toLowerCase()))
              .toList();
        }
      }
      _isOkButtonEnabled = _selectedValue != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  setState(() {
                    _selectedFilter = value;
                    _searchQuery = '';
                    _selectedValue = null;
                    _searchController.clear();
                    _updateDropdownValues();
                    _isOkButtonEnabled = false;
                  });
                },
                child: Row(
                  children: [
                    Text(_selectedFilter ?? 'FILTER BY'),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
                itemBuilder: (context) => ['Name', 'Date', 'VPA']
                    .map((String value) => PopupMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
              ),
              const SizedBox(width: 16),
              if (_selectedFilter != null)
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by $_selectedFilter',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                            _updateDropdownValues();
                          });
                        },
                      ),
                      if (_dropdownValues.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: _dropdownValues.isEmpty
                                ? [ListTile(title: Text('No results'))]
                                : _dropdownValues.map((value) {
                                    return ListTile(
                                      title: Text(value),
                                      onTap: () {
                                        setState(() {
                                          _selectedValue = value;
                                          _searchQuery = null;
                                          _searchController.text = value;
                                          _dropdownValues.clear();
                                          _isOkButtonEnabled = true;
                                        });
                                      },
                                    );
                                  }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (_isOkButtonEnabled)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: _filterTransactions,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.pink,
                minimumSize: Size(80, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text('OK'),
            ),
          ),
        Expanded(
          child: PagedListView<int, Map<String, dynamic>>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
              itemBuilder: (context, transaction, index) {
                final firstLetter = transaction['name'][0];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
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
                      SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  transaction['dateTime'],
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  transaction['vpa'],
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '₹ ${transaction['amount']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.pink,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filtered Total Amount:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₹ $_filteredTotalAmount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
