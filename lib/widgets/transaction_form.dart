import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {

  const TransactionForm({super.key, required this.onSubmit});
  final Function(String, String, double, String, DateTime) onSubmit;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'Pengeluaran';
  String _category = 'Operasional';
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = [
    'Operasional',
    'Gaji',
    'Transportasi',
    'Makan & Minum',
    'Perlengkapan',
    'Lain-lain'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Center(
               child: Container(
                 width: 50,
                 height: 5,
                 decoration: BoxDecoration(
                   color: Colors.grey[300],
                   borderRadius: BorderRadius.circular(10),
                 ),
               ),
             ),
             const SizedBox(height: 20),
             const Text(
               'Tambah Transaksi',
               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
             ),
             const SizedBox(height: 20),

             // Type Selector
             Row(
               children: [
                 Expanded(
                   child: _typeButton('Pemasukan', Colors.green),
                 ),
                 const SizedBox(width: 12),
                 Expanded(
                   child: _typeButton('Pengeluaran', Colors.red),
                 ),
               ],
             ),
             const SizedBox(height: 16),

             // Amount
             TextFormField(
               controller: _amountController,
               keyboardType: TextInputType.number,
               decoration: const InputDecoration(
                 labelText: 'Nominal (Rp)',
                 prefixText: 'Rp ',
                 border: OutlineInputBorder(),
               ),
               validator: (value) {
                 if (value == null || value.isEmpty) return 'Wajib diisi';
                 if (double.tryParse(value) == null) return 'Harus angka';
                 return null;
               },
             ),
             const SizedBox(height: 16),

             // Category & Date Row
             Row(
               children: [
                 Expanded(
                   child: DropdownButtonFormField<String>(
                     initialValue: _category,
                     decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
                     items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                     onChanged: (val) => setState(() => _category = val!),
                   ),
                 ),
                 const SizedBox(width: 12),
                 Expanded(
                   child: InkWell(
                     onTap: () async {
                       final date = await showDatePicker(
                         context: context,
                         initialDate: _selectedDate,
                         firstDate: DateTime(2020),
                         lastDate: DateTime.now(),
                       );
                       if (date != null) setState(() => _selectedDate = date);
                     },
                     child: InputDecorator(
                       decoration: const InputDecoration(labelText: 'Tanggal', border: OutlineInputBorder()),
                       child: Text(DateFormat('dd MMM yyyy').format(_selectedDate)),
                     ),
                   ),
                 ),
               ],
             ),
             const SizedBox(height: 16),

             // Description
             TextFormField(
               controller: _descController,
               decoration: const InputDecoration(
                 labelText: 'Deskripsi',
                 border: OutlineInputBorder(),
               ),
               validator: (val) => (val == null || val.isEmpty) ? 'Wajib diisi' : null,
             ),
             const SizedBox(height: 24),

             // Submit
             SizedBox(
               width: double.infinity,
               height: 50,
               child: ElevatedButton(
                 onPressed: () {
                   if (_formKey.currentState!.validate()) {
                     widget.onSubmit(
                       _type,
                       _category,
                       double.parse(_amountController.text),
                       _descController.text,
                       _selectedDate,
                     );
                     Navigator.pop(context);
                   }
                 },
                 style: ElevatedButton.styleFrom(
                   backgroundColor: _type == 'Pemasukan' ? Colors.green : Colors.red,
                   foregroundColor: Colors.white,
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                 ),
                 child: const Text('Simpan Transaksi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
               ),
             ),
          ],
        ),
      ),
    );
  }

  Widget _typeButton(String type, Color color) {
    final isSelected = _type == type;
    return InkWell(
      onTap: () => setState(() => _type = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.grey[100],
          border: Border.all(color: isSelected ? color : Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            type,
            style: TextStyle(
              color: isSelected ? color : Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
