class BankModel {
  final String code;
  final String name;
  final String logoPath;

  BankModel({
    required this.code,
    required this.name,
    required this.logoPath,
  });

  static final List<BankModel> banks = [
    BankModel(
      code: '00061',
      name: 'Ziraat Bankası',
      logoPath: 'assets/banks/ziraat.png',
    ),
    BankModel(
      code: '00046',
      name: 'İş Bankası',
      logoPath: 'assets/banks/isbank.png',
    ),
    BankModel(
      code: '00062',
      name: 'VakıfBank',
      logoPath: 'assets/banks/vakifbank.png',
    ),
    BankModel(
      code: '00067',
      name: 'Halkbank',
      logoPath: 'assets/banks/halkbank.png',
    ),
    BankModel(
      code: '00111',
      name: 'Yapı Kredi',
      logoPath: 'assets/banks/yapikredi.png',
    ),
    BankModel(
      code: '00134',
      name: 'Akbank',
      logoPath: 'assets/banks/akbank.png',
    ),
    BankModel(
      code: '00123',
      name: 'Garanti BBVA',
      logoPath: 'assets/banks/garanti.png',
    ),
    BankModel(
      code: '00132',
      name: 'Denizbank',
      logoPath: 'assets/banks/denizbank.png',
    ),
    BankModel(
      code: '00135',
      name: 'ING Bank',
      logoPath: 'assets/banks/ing.png',
    ),
    BankModel(
      code: '00137',
      name: 'HSBC',
      logoPath: 'assets/banks/hsbc.png',
    ),
  ];

  static BankModel getDefaultBank() {
    return BankModel(
      code: '',
      name: 'Banka bulunamadı',
      logoPath: 'assets/banks/default.png',
    );
  }
} 