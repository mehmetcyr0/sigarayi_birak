import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/smoking_data_provider.dart';

class SetupDialog extends StatefulWidget {
  const SetupDialog({super.key});

  @override
  State<SetupDialog> createState() => _SetupDialogState();
}

class _SetupDialogState extends State<SetupDialog> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDate;
  late TextEditingController _cigarettesController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _cigarettesController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _cigarettesController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Bilgilerinizi Girin'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
              child: Text(
                'Bırakma Tarihi: ${_selectedDate.toString().split(' ')[0]}',
              ),
            ),
            TextFormField(
              controller: _cigarettesController,
              decoration: const InputDecoration(
                labelText: 'Günlük Sigara Sayısı',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen günlük sigara sayısını girin';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Paket Fiyatı (₺)',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen paket fiyatını girin';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final provider = context.read<SmokingDataProvider>();
              provider.setQuitDate(_selectedDate);
              provider.setDailyCigarettes(
                int.parse(_cigarettesController.text),
              );
              provider.setPricePerPack(
                double.parse(_priceController.text),
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}
