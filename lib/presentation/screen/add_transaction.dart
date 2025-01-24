import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_flutter/domain/entities/transaction.dart';
import 'package:testing_flutter/domain/entities/customer.dart';
import 'package:testing_flutter/presentation/provider/customer_notifier.dart';
import 'package:testing_flutter/presentation/provider/transaction_notifier.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // State for selected customer and customers list
  String? _selectedCustomerId;
  List<Customer> _customers = [];

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    try {
      final customers = await ref.read(customerNotifierProvider.notifier).getAllCustomers();
      final activeCustomers = customers.where((customer) => customer.isDeleted == false).toList();
      setState(() {
        _customers = activeCustomers;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch customers: $e')),
      );
    }
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _amountController.dispose();
    _sellingPriceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _addTransaction() async {
    if (_formKey.currentState!.validate()) {
      final transaction = Transaction(
        customerId: int.tryParse(_selectedCustomerId ?? '0') ?? 0,
        amount: double.tryParse(_amountController.text.trim()) ?? 0.0,
        sellingPrice: double.tryParse(_sellingPriceController.text.trim()) ?? 0.0,
        status: false,
        date: DateTime.now(),
        note: _noteController.text.trim(),
      );

      try {
        await ref
            .read(transactionProvider.notifier)
            .addNewTransaction(transaction);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaksi berhasil ditambahkan')),
          );
          Navigator.pop(context); // Navigate back to the previous screen
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add transaction: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCustomerId,
                decoration: const InputDecoration(
                  labelText: 'Pilih Konsumen',
                  border: OutlineInputBorder(),
                ),
                items: _customers.map((customer) {
                  return DropdownMenuItem(
                    value: customer.id.toString(),
                    child: Text(customer.name ?? ""),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCustomerId = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tolong pilih konsumen';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tolong masukkan jumlah';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Tolong masukan angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sellingPriceController,
                decoration: const InputDecoration(
                  labelText: 'Harga Jual',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tolong masukkan harga jual';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Tolong masukan angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Catatan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addTransaction,
                child: const Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
