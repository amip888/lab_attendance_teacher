// import 'package:flutter/material.dart';
// // import 'package:big_int/big_int.dart';

// class RSAAlgorithm extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('RSA Encryption'),
//       ),
//       body: Center(
//         child: RSAExample(),
//       ),
//     );
//   }
// }

// class RSAExample extends StatefulWidget {
//   @override
//   _RSAExampleState createState() => _RSAExampleState();
// }

// class _RSAExampleState extends State<RSAExample> {
//   late BigInt p, q, n, phi, e, d;

//   @override
//   void initState() {
//     super.initState();
//     initializeRSA();
//   }

//   void initializeRSA() {
//     p = BigInt.from(47);
//     q = BigInt.from(71);
//     n = p * q;
//     phi = (p - BigInt.one) * (q - BigInt.one);
//     e = BigInt.from(79); // Choose e such that 1 < e < phi and gcd(e, phi) = 1
//     d = e.modInverse(phi); // Compute d such that d * e ≡ 1 (mod phi)

//     print('Public Key: (e: $e, n: $n)');
//     print('Private Key: (d: $d, n: $n)');
//   }

//   BigInt encrypt(BigInt message) {
//     return message.modPow(e, n);
//   }

//   BigInt decrypt(BigInt ciphertext) {
//     return ciphertext.modPow(d, n);
//   }

//   @override
//   Widget build(BuildContext context) {
//     int a = 1000;
//     BigInt message = BigInt.from(a); // Example message
//     BigInt encryptedMessage = encrypt(message);
//     BigInt decryptedMessage = decrypt(encryptedMessage);

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text('Original Message: $message'),
//           Text('Encrypted Message: $encryptedMessage'),
//           Text('Decrypted Message: $decryptedMessage'),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:math';

class RSADemo extends StatefulWidget {
  @override
  _RSADemoState createState() => _RSADemoState();
}

class _RSADemoState extends State<RSADemo> {
  final TextEditingController _controller = TextEditingController();
  String _encryptedMessage = '';
  String _decryptedMessage = '';

  final int p = 47;
  final int q = 71;
  late int n;
  late int phi;
  late int e;
  late int d;

  @override
  void initState() {
    super.initState();
    _initializeRSA();
  }

  void _initializeRSA() {
    n = p * q; // n = 3337
    phi = (p - 1) * (q - 1); // phi = 3220
    e = _findE(phi); // e = 79 (contoh)
    d = _findD(e, phi); // d = 1019 (contoh)
  }

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

  int _findD(int e, int phi) {
    int d = 1;
    while ((e * d) % phi != 1) {
      d++;
    }
    return d;
  }

  int _gcd(int a, int b) {
    return b == 0 ? a : _gcd(b, a % b);
  }

  String _encryptMessage(String message) {
    List<int> encryptedMessage = message.codeUnits.map((int char) {
      return _modExp(char, e, n);
    }).toList();

    return encryptedMessage.join(','); // return as comma-separated string
  }

  String _decryptMessage(String encryptedMessage) {
    List<int> encryptedValues = encryptedMessage.split(',').map((String value) {
      return int.parse(value);
    }).toList();

    List<int> decryptedMessage = encryptedValues.map((int encryptedChar) {
      return _modExp(encryptedChar, d, n);
    }).toList();

    return String.fromCharCodes(decryptedMessage);
  }

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

  void _onEncrypt() {
    String message = _controller.text;
    setState(() {
      _encryptedMessage = _encryptMessage(message);
      _decryptedMessage = _decryptMessage(_encryptedMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RSA Encryption & Decryption Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter message to encrypt',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onEncrypt,
              child: Text('Encrypt & Decrypt'),
            ),
            SizedBox(height: 20),
            if (_encryptedMessage.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Encrypted Message: $_encryptedMessage',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Decrypted Message: $_decryptedMessage',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
