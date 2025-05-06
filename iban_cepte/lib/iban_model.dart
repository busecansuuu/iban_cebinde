class IbanModel {
  final String title;
  final String iban;
  final String bankCode;
  final String bankName;
  final String bankLogoPath;

  IbanModel({
    required this.title,
    required this.iban,
    required this.bankCode,
    required this.bankName,
    required this.bankLogoPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'iban': iban,
      'bankCode': bankCode,
      'bankName': bankName,
      'bankLogoPath': bankLogoPath,
    };
  }

  factory IbanModel.fromJson(Map<String, dynamic> json) {
    return IbanModel(
      title: json['title'] ?? '',
      iban: json['iban'] ?? '',
      bankCode: json['bankCode'] ?? '',
      bankName: json['bankName'] ?? '',
      bankLogoPath: json['bankLogoPath'] ?? 'assets/banks/default.png',
    );
  }
}
