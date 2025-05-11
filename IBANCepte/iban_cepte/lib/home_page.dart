import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'iban_database.dart';
import 'iban_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<IbanModel> ibanList = [];
  Set<int> selectedIbans = {};

  @override
  void initState() {
    super.initState();
    _loadIbans();
  }

  Future<void> _loadIbans() async {
    await IbanDatabase.loadIbans();
    setState(() {
      ibanList = IbanDatabase.ibans;
    });
  }

  Future<void> _deleteIban(int index) async {
    await IbanDatabase.removeIban(index);
    setState(() {
      ibanList = IbanDatabase.ibans;
      selectedIbans.remove(index);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('IBAN silindi')),
      );
    }
  }

  void _copyIban(String iban) {
    Clipboard.setData(ClipboardData(text: iban)).then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('IBAN kopyalandı')),
        );
      }
    });
  }

  void _shareIban(IbanModel iban) {
    final shareText = 'IBAN: ${iban.iban}\nBanka: ${iban.bankName}\nBaşlık: ${iban.title}';
    Share.share(shareText);
  }

  void _toggleIbanSelection(int index) {
    setState(() {
      if (selectedIbans.contains(index)) {
        selectedIbans.remove(index);
      } else {
        selectedIbans.add(index);
      }
      print('Seçili IBAN\'lar: $selectedIbans'); // Debug için
    });
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('IBAN Sil'),
        content: const Text('Bu IBAN\'ı silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              IbanDatabase.removeIban(index);
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  void _shareMultipleIbans() {
    if (selectedIbans.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen paylaşmak için IBAN seçin')),
      );
      return;
    }
    
    final selectedIbanList = selectedIbans.map((index) => ibanList[index]).toList();
    final shareText = selectedIbanList.map((iban) => 
      'IBAN: ${iban.iban}\nBanka: ${iban.bankName}\nBaşlık: ${iban.title}\n\n'
    ).join('---\n');
    
    print('Paylaşılacak metin: $shareText'); // Debug için
    Share.share(shareText);
    setState(() {
      selectedIbans.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IBAN Cepte'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          if (selectedIbans.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _shareMultipleIbans,
              tooltip: 'Seçili IBAN\'ları Paylaş',
            ),
        ],
      ),
      body: ibanList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz IBAN eklenmemiş',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Yeni IBAN eklemek için + butonuna basın',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: ibanList.length,
              itemBuilder: (context, index) {
                final iban = ibanList[index];
                final isSelected = selectedIbans.contains(index);
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isSelected
                        ? BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          )
                        : BorderSide.none,
                  ),
                  child: InkWell(
                    onLongPress: () => _toggleIbanSelection(index),
                    onTap: isSelected
                        ? () => _toggleIbanSelection(index)
                        : null,
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) => _shareIban(iban),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            icon: Icons.share,
                            label: 'Paylaş',
                          ),
                          SlidableAction(
                            onPressed: (_) => _deleteIban(index),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Sil',
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (isSelected)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    iban.bankLogoPath,
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
                                        iban.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        iban.bankName,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: () => _copyIban(iban.iban),
                                  tooltip: 'Kopyala',
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              iban.iban,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/edit',
                                      arguments: iban,
                                    ).then((_) => _loadIbans());
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _showDeleteDialog(context, index),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add').then((_) => _loadIbans());
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Sorgula',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              // Ana sayfa zaten açık
              break;
            case 1:
              Navigator.pushNamed(context, '/query');
              break;
            case 2:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }
}
