import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_flutter/domain/entities/customer.dart';
import 'package:testing_flutter/presentation/provider/customer_notifier.dart';

class AddOrUpdateCustomerScreen extends ConsumerStatefulWidget {

  final Customer? existingCustomer;

  const AddOrUpdateCustomerScreen({super.key, this.existingCustomer});

  @override
  ConsumerState<AddOrUpdateCustomerScreen> createState() => _AddOrUpdateCustomerScreenState();
}

class _AddOrUpdateCustomerScreenState extends ConsumerState<AddOrUpdateCustomerScreen> {




  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _phoneController = TextEditingController();

  

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

    @override
  void initState() {
    super.initState();
    // Inisialisasi TextEditingController dengan data existingCustomer jika ada
    _nameController = TextEditingController(
      text: widget.existingCustomer?.name ?? "",
    );
    _phoneController = TextEditingController(
      text: widget.existingCustomer?.phone ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingCustomer != null;
    
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit Konsumen" : "Tambah Konsumen")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Konsumen"),
                validator: (value) =>
                    value?.isEmpty == true ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration:
                    const InputDecoration(labelText: "Nomor Telepon Konsumen"),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value?.isEmpty == true ? "Nomor telepon wajib diisi" : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final customer = Customer(id: widget.existingCustomer?.id, name: _nameController.text, phone: _phoneController.text);

                    if(isEditing){
                      ref 
                        .read(customerNotifierProvider.notifier)
                        .update(customer)
                        .then((_) => {
                          if(context.mounted) Navigator.pop(context)
                        });
                    }
                    else{
                      ref
                        .read(customerNotifierProvider.notifier)
                        .add(customer)
                        .then((_) => {
                          if(context.mounted) Navigator.pop(context)
                        });
                    }
                  }
                },
                child: Text(isEditing ? "Simpan Perubahan" : "Tambah Konsumen"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
