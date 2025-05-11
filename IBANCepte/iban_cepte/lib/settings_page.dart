import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final VoidCallback onThemeChanged;
  final bool isDarkMode;

  const SettingsPage({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Karanlık Mod'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (_) => onThemeChanged(),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Uygulama Hakkında'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'IBAN Cepte',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(
                  Icons.account_balance_wallet,
                  size: 48,
                ),
                children: [
                  const Text(
                    'IBAN\'larınızı güvenle saklayın ve kolayca yönetin.',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
} 