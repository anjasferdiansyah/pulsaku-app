import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:testing_flutter/presentation/provider/customer_notifier.dart';

class CustomerScreen extends ConsumerWidget {
  const CustomerScreen({super.key});

  Future<void> showDeleteConfirmationDialog(
     BuildContext context, 
    WidgetRef ref, 
    int customerId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Hapus Konsumen"),
          content: Text("Apakah anda yakin ingin menghapus konsumen ini?"),
          actions: [
            TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            }, 
            child: Text("Batal")),
            TextButton(
              onPressed: (){
                Navigator.pop(context, true);
              }, 
              child: const Text("Hapus", style: TextStyle(color: Colors.red))),
          ],
        );

      }
    );
            if(confirmed == true){
          ref.read(customerNotifierProvider.notifier).removeCustomer(customerId);
        }
  }

  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(customerNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Konsumen", style: TextStyle(color: Colors.white)),
        backgroundColor: ColorScheme.of(context).primary,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            // Input Cari Konsumen
            Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                onChanged: (value) {
                  ref.read(customerNotifierProvider.notifier).searchCustomerByName(value);
                },
                decoration: InputDecoration(
                  labelText: 'Cari Konsumen',
                  fillColor: Colors.white,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.search),
                  ),
                ),
              ),
            ),

            // Daftar Konsumen dengan Lazy Scroll
            Expanded(
              child: customersAsync.when(

                
                data: (customers) {
                  final activeCustomers = customers.where((customer) => customer.isDeleted == false).toList();
                  Logger().i("Customers: $customers");
                  if(activeCustomers.isEmpty){
                    return const Center(
                      child: Text("Belum ada konsumen")
                    );
                  }
                  return ListView.builder(
                  itemCount: activeCustomers.length,
                  padding: EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final customer = activeCustomers[index];
                    return Dismissible(
                      key: ValueKey(customer.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                     confirmDismiss: (direction) async {
                    await showDeleteConfirmationDialog(context, ref, customer.id ?? 0);
                    return false; // Tidak langsung hapus saat swipe
                  },
                      child: Card(
                        color: ColorScheme.of(context).primary,
                        child: ListTile(
                          title: Text(customer.name ?? "", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          subtitle: Text(customer.phone ?? "", style: const TextStyle(color: Colors.white, fontSize: 16),),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () => context.go('/customer/update-customer/${customer.id}', extra: customer),
                          ),
                        ),
                      )
                    );
                  
                  },
                );
                },
                
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: Text("Terjadi kesalahan: $error"),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/customer/add-customer'),
        child: const Icon(Icons.add),
      ),

    );
  }
}
