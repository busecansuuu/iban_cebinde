import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iban_cepte/bank_model.dart';
import 'package:iban_cepte/iban_model.dart';
import 'package:iban_cepte/iban_database.dart';

class AddIbanPage extends StatefulWidget {
  final IbanModel? ibanToEdit;

  const AddIbanPage({super.key, this.ibanToEdit});

  @override
  State<AddIbanPage> createState() => _AddIbanPageState();
}

class _AddIbanPageState extends State<AddIbanPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _ibanController = TextEditingController();
  bool _isLoading = false;
  BankModel? _selectedBank;

  @override
  void initState() {
    super.initState();
    if (widget.ibanToEdit != null) {
      _titleController.text = widget.ibanToEdit!.title;
      _ibanController.text = widget.ibanToEdit!.iban;
    }
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
    // IBAN'ın geri kalanının sadece sayı olduğunu kontrol et
    final numbers = iban.substring(2);
    if (!RegExp(r'^[0-9]+$').hasMatch(numbers)) {
      return 'IBAN sadece sayılardan oluşmalıdır';
    }
    return null;
  }

  Future<void> _saveIban() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final iban = IbanModel(
      title: _titleController.text.trim(),
      iban: _ibanController.text.trim().toUpperCase(),
      bankCode: _ibanController.text.trim().substring(4, 9),
      bankName: '',
      bankLogoPath: 'assets/banks/default.png',
    );

    if (widget.ibanToEdit != null) {
      // Düzenleme modu
      final index = IbanDatabase.ibans.indexOf(widget.ibanToEdit!);
      if (index != -1) {
        IbanDatabase.ibans[index] = iban;
      }
    } else {
      // Yeni ekleme modu
      IbanDatabase.ibans.add(iban);
    }

    await IbanDatabase.saveIbans();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ibanToEdit != null ? 'IBAN Düzenle' : 'IBAN Ekle'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              const Text(
                'Banka Seçin',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: BankModel.banks.length,
                itemBuilder: (context, index) {
                  final bank = BankModel.banks[index];
                  final isSelected = _selectedBank?.code == bank.code;
                  return InkWell(
                    onTap: () => setState(() => _selectedBank = bank),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            bank.logoPath,
                            height: 40,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.account_balance,
                                size: 40,
                                color: Colors.grey,
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          Text(
                            bank.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveIban,
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
                    : Text(widget.ibanToEdit != null ? 'Güncelle' : 'Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
