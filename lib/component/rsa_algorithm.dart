import 'dart:developer';
import 'package:flutter/material.dart';

class RsaAlgorithm {
  final TextEditingController encryptedController = TextEditingController();
  final TextEditingController decryptedController = TextEditingController();

  final int p = 47;
  final int q = 71;
  late int n;
  late int phi;
  late int e;
  late int d;

  // Inisialisasi nilai-nilai RSA (n, phi, e, d)
  void initializeRSA() {
    n = p * q; // n = 3337
    phi = (p - 1) * (q - 1); // phi = 3220
    e = _findE(phi); // e = 79 (contoh)
    d = _findD(e, phi); // d = 1019 (contoh)
    log('ini intial RSA');
  }

  // Mencari nilai e yang relatif prima terhadap phi
  int _findE(int phi) {
    int e = 2;
    while (e < phi) {
      if (_gcd(e, phi) == 1) {
        break;
      }
      e++;
    }
    return e;
  }

  // Mencari nilai d menggunakan extended Euclidean algorithm
  int _findD(int e, int phi) {
    int d = 1;
    while ((e * d) % phi != 1) {
      d++;
    }
    return d;
  }

  // Menghitung GCD (Greatest Common Divisor)
  int _gcd(int a, int b) {
    return b == 0 ? a : _gcd(b, a % b);
  }

  // Metode enkripsi pesan
  String _encryptMessage(String message) {
    List<int> encryptedMessage = message.codeUnits.map((int char) {
      return _modExp(char, e, n);
    }).toList();

    return encryptedMessage.join(','); // return as comma-separated string
  }

  // Metode dekripsi pesan
  String _decryptMessage(String encryptedMessage) {
    List<int> encryptedValues = encryptedMessage.split(',').map((String value) {
      return int.parse(value);
    }).toList();

    List<int> decryptedMessage = encryptedValues.map((int encryptedChar) {
      return _modExp(encryptedChar, d, n);
    }).toList();

    return String.fromCharCodes(decryptedMessage);
  }

  // Modular exponentiation (base^exp % mod)
  int _modExp(int base, int exp, int mod) {
    int result = 1;
    while (exp > 0) {
      if (exp % 2 == 1) {
        result = (result * base) % mod;
      }
      base = (base * base) % mod;
      exp = exp ~/ 2;
    }
    return result;
  }

  // Fungsi untuk mengenkripsi pesan dari input
  onEncrypt(String message) {
    encryptedController.text = _encryptMessage(message);
    return encryptedController.text;
  }

  // Fungsi untuk mendekripsi pesan dari input encrypted message
  onDecrypt(String encryptedMessage) {
    decryptedController.text = _decryptMessage(encryptedMessage);
    return decryptedController.text;
  }
}
