import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'iban_model.dart';

class IbanDatabase {
  static const String _ibanKey = 'saved_ibans';
  static List<IbanModel> ibans = [];

  static Future<void> loadIbans() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? ibansJson = prefs.getString(_ibanKey);
      if (ibansJson != null) {
        final List<dynamic> decoded = json.decode(ibansJson);
        ibans = decoded.map((item) => IbanModel.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('IBAN yükleme hatası: $e');
      ibans = [];
    }
  }

  static Future<void> saveIbans() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = json.encode(ibans.map((iban) => iban.toJson()).toList());
      await prefs.setString(_ibanKey, encoded);
    } catch (e) {
      debugPrint('IBAN kaydetme hatası: $e');
    }
  }

  static Future<void> addIban(IbanModel iban) async {
    ibans.add(iban);
    await saveIbans();
  }

  static Future<void> removeIban(int index) async {
    if (index >= 0 && index < ibans.length) {
      ibans.removeAt(index);
      await saveIbans();
    }
  }
}
