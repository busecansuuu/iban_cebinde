import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iban_cepte/home_page.dart';
import 'package:iban_cepte/add_iban_page.dart';
import 'package:iban_cepte/query_iban_page.dart';
import 'package:iban_cepte/edit_iban_page.dart';
import 'package:iban_cepte/settings_page.dart';
import 'package:iban_cepte/iban_model.dart';
import 'package:iban_cepte/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  runApp(IbanApp(isDarkMode: isDarkMode));
}

class IbanApp extends StatefulWidget {
  final bool isDarkMode;

  const IbanApp({super.key, required this.isDarkMode});

  @override
  State<IbanApp> createState() => _IbanAppState();
}

class _IbanAppState extends State<IbanApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      SharedPreferences.getInstance().then((prefs) {
        prefs.setBool('isDarkMode', _isDarkMode);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IBAN Cepte',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const HomePage(),
        '/add': (context) => const AddIbanPage(),
        '/query': (context) => const QueryIbanPage(),
        '/edit': (context) {
          final iban = ModalRoute.of(context)!.settings.arguments as IbanModel;
          return EditIbanPage(iban: iban);
        },
        '/settings': (context) => SettingsPage(
              onThemeChanged: _toggleTheme,
              isDarkMode: _isDarkMode,
            ),
      },
    );
  }
}
