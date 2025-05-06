import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iban_cepte/bank_model.dart';
import 'package:iban_cepte/iban_database.dart';
import 'package:iban_cepte/iban_model.dart';

class QueryIbanPage extends StatefulWidget {
  const QueryIbanPage({super.key});

  @override
  State<QueryIbanPage> createState() => _QueryIbanPageState();
}

class _QueryIbanPageState extends State<QueryIbanPage> {
  final _controller = TextEditingController();
  String? _result;
  bool _isLoading = false;
  IbanModel? _savedIban;

  @override
  void initState() {
    super.initState();
    _controller.text = '';
  }

  void _queryIban() {
    final iban = _controller.text.trim().toUpperCase();
    if (iban.length != 26) {
      setState(() {
        _result = 'IBAN 26 karakter olmalıdır';
        _isLoading = false;
        _savedIban = null;
      });
      return;
    }

    if (!iban.startsWith('TR')) {
      setState(() {
        _result = 'IBAN TR ile başlamalıdır';
        _isLoading = false;
        _savedIban = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _savedIban = null;
    });

    // Önce kayıtlı IBAN'ları kontrol et
    final savedIban = IbanDatabase.ibans.firstWhere(
      (i) => i.iban == iban,
      orElse: () => IbanModel(
        title: '',
        iban: '',
        bankCode: '',
        bankName: '',
        bankLogoPath: 'assets/banks/default.png',
      ),
    );

    if (savedIban.iban.isNotEmpty) {
      setState(() {
        _savedIban = savedIban;
        _isLoading = false;
      });
      return;
    }

    // Simüle edilmiş yükleme süresi
    Future.delayed(const Duration(milliseconds: 500), () {
      String bankCode = iban.substring(4, 9);
      final bank = BankModel.banks.firstWhere(
        (b) => b.code == bankCode,
        orElse: () => BankModel.getDefaultBank(),
      );

      setState(() {
        _result = bank.name;
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IBAN Sorgula'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              maxLength: 26,
              decoration: InputDecoration(
                labelText: 'IBAN Giriniz',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.credit_card),
                hintText: 'TR...',
                counterText: '',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.text = '';
                    setState(() {
                      _result = null;
                      _savedIban = null;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _queryIban,
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
                  : const Text('Sorgula'),
            ),
            const SizedBox(height: 24),
            if (_savedIban != null)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kayıtlı IBAN Bilgileri',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              _savedIban!.bankLogoPath,
                              height: 40,
                              width: 40,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.account_balance,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _savedIban!.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  _savedIban!.bankName,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _savedIban!.iban,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_result != null && _savedIban == null)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sorgu Sonucu',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(_result!),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
