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
      code: '00010',
      name: 'Ziraat Bankası',
      logoPath: 'assets/banks/ziraat.png',
    ),
    BankModel(
      code: '00015',
      name: 'VakıfBank',
      logoPath: 'assets/banks/vakifbank.png',
    ),
    BankModel(
      code: '00012',
      name: 'Halkbank',
      logoPath: 'assets/banks/halkbank.png',
    ),
    BankModel(
      code: '00064',
      name: 'Türkiye İş Bankası',
      logoPath: 'assets/banks/isbank.png',
    ),
    BankModel(
      code: '00046',
      name: 'Akbank',
      logoPath: 'assets/banks/akbank.png',
    ),
    BankModel(
      code: '00062',
      name: 'Garanti BBVA',
      logoPath: 'assets/banks/garanti.png',
    ),
    BankModel(
      code: '00671',
      name: 'Yapı Kredi',
      logoPath: 'assets/banks/yapikredi.png',
    ),
    BankModel(
      code: '00134',
      name: 'DenizBank',
      logoPath: 'assets/banks/denizbank.png',
    ),
    BankModel(
      code: '00099',
      name: 'ING Bank',
      logoPath: 'assets/banks/ing.png',
    ),
    BankModel(
      code: '00123',
      name: 'HSBC',
      logoPath: 'assets/banks/hsbc.png',
    ),
    BankModel(
      code: '00111',
      name: 'QNB Finansbank',
      logoPath: 'assets/banks/finansbank.png',
    ),
    BankModel(
      code: '00100',
      name: 'TEB',
      logoPath: 'assets/banks/teb.png',
    ),
    BankModel(
      code: '00146',
      name: 'Şekerbank',
      logoPath: 'assets/banks/sekerbank.png',
    ),
    BankModel(
      code: '00138',
      name: 'Alternatifbank',
      logoPath: 'assets/banks/abank.png',
    ),
    BankModel(
      code: '00105',
      name: 'Anadolubank',
      logoPath: 'assets/banks/anadolubank.png',
    ),
    BankModel(
      code: '00109',
      name: 'ICBC Turkey Bank',
      logoPath: 'assets/banks/icbc.png',
    ),
    BankModel(
      code: '00124',
      name: 'Burgan Bank',
      logoPath: 'assets/banks/burgan.png',
    ),
    BankModel(
      code: '00108',
      name: 'Türkiye Kalkınma ve Yatırım Bankası',
      logoPath: 'assets/banks/tkyb.png',
    ),
    BankModel(
      code: '00140',
      name: 'Turkish Bank',
      logoPath: 'assets/banks/turkishbank.png',
    ),
    BankModel(
      code: '00127',
      name: 'Odea Bank',
      logoPath: 'assets/banks/odeabank.png',
    ),
    BankModel(
      code: '00104',
      name: 'Aktif Bank',
      logoPath: 'assets/banks/aktifbank.png',
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
