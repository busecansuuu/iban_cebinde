import 'package:flutter/material.dart';
import 'package:iban_cepte/iban_database.dart';
import 'package:iban_cepte/iban_model.dart';

class EditIbanPage extends StatefulWidget {
  final IbanModel iban;

  const EditIbanPage({super.key, required this.iban});

  @override
  State<EditIbanPage> createState() => _EditIbanPageState();
}

class _EditIbanPageState extends State<EditIbanPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _ibanController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.iban.title;
    _ibanController.text = widget.iban.iban;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ibanController.dispose();
    super.dispose();
  }

  String? _validateIban(String? value) {
    if (value == null || value.isEmpty) {
      return 'IBAN gerekli';
    }
    final iban = value.trim().toUpperCase();
    if (iban.length != 26) {
      return 'IBAN 26 karakter olmalıdır';
    }
    if (!iban.startsWith('TR')) {
      return 'IBAN TR ile başlamalıdır';
    }
    return null;
  }

  Future<void> _updateIban() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final updatedIban = IbanModel(
      title: _titleController.text.trim(),
      iban: _ibanController.text.trim().toUpperCase(),
      bankCode: widget.iban.bankCode,
      bankName: widget.iban.bankName,
      bankLogoPath: widget.iban.bankLogoPath,
    );

    final index = IbanDatabase.ibans.indexOf(widget.iban);
    if (index != -1) {
      IbanDatabase.ibans[index] = updatedIban;
      await IbanDatabase.saveIbans();
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IBAN Düzenle'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Başlık',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Başlık gerekli';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ibanController,
                maxLength: 26,
                decoration: InputDecoration(
                  labelText: 'IBAN',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.credit_card),
                  hintText: 'TR...',
                  counterText: '',
                ),
                validator: _validateIban,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateIban,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Güncelle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 