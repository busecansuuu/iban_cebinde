import 'package:flutter/material.dart';
import 'package:iban_cepte/bank_model.dart';

class QueryIbanPage extends StatefulWidget {
  const QueryIbanPage({super.key});

  @override
  State<QueryIbanPage> createState() => _QueryIbanPageState();
}

class _QueryIbanPageState extends State<QueryIbanPage> {
  final _controller = TextEditingController();
  String? _bankName;
  String? _bankLogoPath;
  bool _isLoading = false;
  String? _error;

  void _queryIban() {
    final iban = _controller.text.trim().toUpperCase();

    setState(() {
      _isLoading = true;
      _bankName = null;
      _bankLogoPath = null;
      _error = null;
    });

    if (iban.length != 26) {
      setState(() {
        _error = 'IBAN 26 karakter olmalıdır';
        _isLoading = false;
      });
      return;
    }

    if (!iban.startsWith('TR')) {
      setState(() {
        _error = 'IBAN TR ile başlamalıdır';
        _isLoading = false;
      });
      return;
    }

    final bankCode = iban.substring(4, 9);

    final bank = BankModel.banks.firstWhere(
      (b) => b.code == bankCode,
      orElse: () => BankModel.getDefaultBank(),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _bankName = bank.name;
        _bankLogoPath = bank.logoPath;
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
                    _controller.clear();
                    setState(() {
                      _bankName = null;
                      _bankLogoPath = null;
                      _error = null;
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
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            if (_bankName != null && _bankLogoPath != null)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          _bankLogoPath!,
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
                        child: Text(
                          _bankName!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
