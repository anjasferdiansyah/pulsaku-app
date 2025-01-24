import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:testing_flutter/domain/entities/customer.dart';
import 'package:testing_flutter/presentation/provider/customer_notifier.dart';
import 'package:testing_flutter/presentation/provider/transaction_notifier.dart';

class TransactionScreen extends ConsumerStatefulWidget {
  const TransactionScreen({super.key});

  @override
  ConsumerState<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _statusFilter = 'Semua';
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedDateText = 'Pilih Tanggal';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  String getCustomerName(List<Customer> customers, int customerId) {
    final customer = customers.firstWhere(
      (customer) => customer.id == customerId,
      orElse: () =>
          Customer(id: customerId, name: 'Unknown Customer', phone: ''),
    );
    return customer.name ?? 'Unknown Customer';
  }

  


  List filterTransactions(List transactions, List<Customer> customers,
      String filterType, String searchQuery) {
    DateTime now = DateTime.now();
    List filteredTransactions = transactions.where((transaction) {
      // Filter by customer name
      if (searchQuery.isNotEmpty &&
          !getCustomerName(customers, transaction.customerId)
              .toLowerCase()
              .contains(searchQuery.toLowerCase())) {
        return false;
      }

      if (_statusFilter == 'Lunas' && !transaction.status) {
        return false;
      } else if (_statusFilter == 'Belum Lunas' && transaction.status) {
        return false;
      }

      if (_startDate != null && _endDate != null) {
        if (transaction.date.isBefore(_startDate!) ||
            transaction.date.isAfter(_endDate!)) {
          return false;
        }
      }

      // Filter by date range based on filterType
      if (filterType == 'Hari ini') {
        return transaction.date.day == now.day &&
            transaction.date.month == now.month &&
            transaction.date.year == now.year;
      } else if (filterType == 'Minggu ini') {
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(Duration(days: 6));
        return transaction.date.isAfter(startOfWeek) &&
            transaction.date.isBefore(endOfWeek);
      } else if (filterType == 'Bulan ini') {
        return transaction.date.month == now.month &&
            transaction.date.year == now.year;
      }
      return true; // Default: Semua
    }).toList();

    return filteredTransactions;
  }

  Future<void> _showMarkAsPaidConfirmationDialog(
      BuildContext context, int transactionId, bool currentStatus) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(currentStatus ? "Tandai Belum Lunas" : "Tandai Lunas"),
          content: Text(currentStatus
              ? "Apakah Anda yakin ingin menandai transaksi ini sebagai belum lunas?"
              : "Apakah Anda yakin ingin menandai transaksi ini sebagai lunas?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // User cancels
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // User confirms
              },
              child: Text(
                currentStatus ? "Tandai Belum Lunas" : "Tandai Lunas",
                style: TextStyle(color: ColorScheme.light().primary),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // Change the status of the transaction
      ref
          .read(transactionProvider.notifier)
          .changeTransactionStatus(transactionId);
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 1),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (pickedRange != null) {
      setState(() {
        _startDate = pickedRange.start;
        _endDate = pickedRange.end;
            _selectedDateText = '${DateFormat('dd MMM yyyy').format(pickedRange.start)} - ${DateFormat('dd MMM yyyy').format(pickedRange.end)}';
      });
    }
  }

  void _clearFilter(){
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedDateText = 'Pilih Tanggal';
      _statusFilter = 'Semua';
    });
  }

  double sumProfit(totalTrx, totalToBeSettled){
    return (totalTrx - totalToBeSettled);
  }

  String formatCurrency(double amount) {
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'id_ID');
  return formatCurrency.format(amount);
}

  @override
  Widget build(BuildContext context) {
    final transactionAsync = ref.watch(transactionProvider);
    final customerAsync = ref.watch(customerNotifierProvider);
    final transactionState = ref.watch(transactionProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaksi", style: TextStyle(color: Colors.white)),
        backgroundColor: ColorScheme.of(context).primary,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(
              text: "Semua",
            ),
            Tab(text: "Hari ini"),
            Tab(text: "Minggu ini"),
            Tab(text: "Bulan ini"),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Cari transaksi...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Row(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButton<String>(
                items: ["Semua", "Lunas", "Belum Lunas"]
                    .map((item) =>
                        DropdownMenuItem(value: item, child: Text(item)))
                    .toList(),
                value: _statusFilter,
                onChanged: (value) {
                  setState(() {
                    _statusFilter = value!;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _selectDateRange(context),
              child: Text(_selectedDateText),
            ),
            CloseButton(
              color: Colors.red,
              onPressed: () => _clearFilter(),
              )
           
          ]),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: const EdgeInsets.all(
                        8), // Ubah margin agar lebih presisi
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          formatCurrency(transactionState.totalTransaction),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text("Total Transaksi"),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: const EdgeInsets.all(8),
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          formatCurrency(transactionState.totalToBeSettled),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text("Total Setoran"),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: const EdgeInsets.all(8),
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          formatCurrency(sumProfit(transactionState.totalToBeSettled, transactionState.totalTransaction)),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text("Keuntungan"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: transactionAsync.when(
              data: (transactions) {
                Logger().d("Transactions: $transactions");
                return customerAsync.when(
                  data: (customers) {
                    if (transactions.isEmpty) {
                      return const Center(child: Text("Tidak ada transaksi"));
                    } else {
                      final filterType = [
                        'Semua',
                        'Hari ini',
                        'Minggu ini',
                        'Bulan ini'
                      ][_tabController.index];
                      final filteredTransactions = filterTransactions(
                          transactions, customers, filterType, _searchQuery);

                      if (filteredTransactions.isEmpty) {
                        return const Center(
                            child: Text("Tidak ada transaksi sesuai filter"));
                      }

                      return ListView.builder(
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = filteredTransactions[index];
                          final customerName = getCustomerName(
                              customers, transaction.customerId);

                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: ExpansionTile(
                              leading: const Icon(Icons.money_rounded),
                              title: Text(
                                customerName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.blue,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(formatDate(transaction.date)),
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                      color: transaction.status
                                          ? Colors.green
                                          : Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        transaction.status
                                            ? "Lunas"
                                            : "Belum Lunas",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                formatCurrency(transaction.amount),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.note,
                                          color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          transaction.note ??
                                              "Tidak ada catatan",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Tombol untuk mengubah status transaksi
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      // Mengubah status transaksi ketika tombol ditekan
                                      await _showMarkAsPaidConfirmationDialog(
                                        context,
                                        transaction.id,
                                        transaction.status,
                                      );
                                    },
                                    child: Text(transaction.status
                                        ? 'Tandai Belum Lunas'
                                        : 'Tandai Lunas'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Center(
                    child: Text("Error: $error"),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text("Error: $error"),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.go('/transaction/add-transaction'),
      ),
    );
  }
}
