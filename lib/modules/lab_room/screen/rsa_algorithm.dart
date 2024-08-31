import 'dart:io';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:lab_attendance_mobile_teacher/component/button/button.dart';
import 'package:lab_attendance_mobile_teacher/component/constant_divider.dart';
import 'package:lab_attendance_mobile_teacher/component/pallete.dart';
import 'package:lab_attendance_mobile_teacher/services/api/batch_api.dart';
import 'package:lab_attendance_mobile_teacher/services/response_data/response_data.dart';
import 'package:lab_attendance_mobile_teacher/services/upload_file/files.dart';
import 'package:lab_attendance_mobile_teacher/services/upload_file/upload_file.dart';
import 'package:lab_attendance_mobile_teacher/utils/view_utils.dart';
import 'dart:math';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http_parser/http_parser.dart';

class GenerateQrCodeWithRSA extends StatefulWidget {
  final TextEditingController inputController;
  Files? file;
  Function(Files?) onUpload;

  GenerateQrCodeWithRSA(
      {super.key,
      required this.inputController,
      this.file,
      required this.onUpload});

  @override
  _GenerateQrCodeWithRSAState createState() => _GenerateQrCodeWithRSAState();
}

class _GenerateQrCodeWithRSAState extends State<GenerateQrCodeWithRSA> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _encryptedController = TextEditingController();
  String _encryptedMessage = '';
  String _decryptedMessage = '';
  bool isCompleteGenerate = false;

  final int p = 47;
  final int q = 71;
  late int n;
  late int phi;
  late int e;
  late int d;

  final GlobalKey _globalKey = GlobalKey();
  String? _savedImagePath;
  Files? fileUpload;

  @override
  void initState() {
    super.initState();
    _initializeRSA();
    if (widget.file != null) {
      fileUpload = widget.file;
    }
  }

  // Inisialisasi nilai-nilai RSA (n, phi, e, d)
  void _initializeRSA() {
    n = p * q; // n = 3337
    phi = (p - 1) * (q - 1); // phi = 3220
    e = _findE(phi); // e = 79 (contoh)
    d = _findD(e, phi); // d = 1019 (contoh)
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
  void _onEncrypt() {
    String message = widget.inputController.text;
    // String message = _controller.text;
    setState(() {
      _encryptedMessage = _encryptMessage(message);
      _decryptedMessage = ''; // Clear previous decryption result
      widget.inputController.text = _encryptedMessage;
    });
  }

  // Fungsi untuk mendekripsi pesan dari input encrypted message
  void _onDecrypt() {
    String encryptedMessage = _encryptedController.text;
    setState(() {
      _decryptedMessage = _decryptMessage(encryptedMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_encryptedMessage.isNotEmpty)
          RepaintBoundary(
            key: _globalKey,
            child: QrImageView(
              data: _encryptedMessage,
              errorCorrectionLevel: 3,
              version: QrVersions.auto,
              embeddedImageStyle:
                  const QrEmbeddedImageStyle(size: Size(80, 80)),
              embeddedImage: const AssetImage('assets/images/pngs/logo.png'),
              size: 250,
              gapless: false,
              backgroundColor: Colors.white,
            ),
          ),
        // Image.file(File(_savedImagePath!)), // Menampilkan gambar yang disimpan
        divide16,
        if (widget.inputController.text.isNotEmpty &&
            isCompleteGenerate == false)
          Button(
            text: _encryptedMessage.isNotEmpty
                ? 'Simpan Qr COde'
                : 'Generate Qr Code',
            press: () {
              _encryptedMessage.isNotEmpty ? _captureQrCode() : _onEncrypt();
            },
            color: Colors.amber,
          ),

//Coding Decrypt
        // if (_encryptedMessage.isNotEmpty)
        //   Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         'Encrypted Message: $_encryptedMessage',
        //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //       ),
        //       SizedBox(height: 20),
        //     ],
        //   ),
        // TextField(
        //   controller: _encryptedController,
        //   decoration: InputDecoration(
        //     labelText: 'Enter encrypted message to decrypt',
        //   ),
        // ),
        // SizedBox(height: 20),
        // ElevatedButton(
        //   onPressed: _onDecrypt,
        //   child: Text('Decrypt'),
        //   style: ButtonStyle(
        //       backgroundColor: MaterialStatePropertyAll(Colors.amber)),
        // ),
        // SizedBox(height: 20),
        // if (_decryptedMessage.isNotEmpty)
        //   Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         'Decrypted Message: $_decryptedMessage',
        //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //       ),
        //     ],
        //   ),
      ],
    );
  }

// Simpan ke memori perangkat
  Future<void> _captureQrCode() async {
    try {
      // RenderRepaintBoundary yang diambil dari widget QrImageView
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      // Ambil gambar dalam format ui.Image
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      // Konversi menjadi byte data PNG
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        // Simpan gambar ke file di perangkat
        final directory = await getExternalStorageDirectory();
        // final directory = await getApplicationDocumentsDirectory();
        final imagePath = '${directory!.path}/qr_code_image.png';
        final File imgFile = File(imagePath);
        imgFile.writeAsBytesSync(pngBytes);

        setState(() {
          _savedImagePath = imagePath; // Simpan path gambar untuk ditampilkan
        });
        print('QR Code berhasil disimpan di: $imagePath');

        uploadToServer(imgFile);
      }
    } catch (e) {
      print('Error capturing QR code: $e');
    }
  }

  void uploadToServer(File? file) async {
    // setState(() {
    //   _isLoading = true;
    // });
    BatchApi api = BatchApi();
    Map<String, dynamic> body = {};

    body['file'] = await MultipartFile.fromFile(file!.path,
        contentType: MediaType('image', 'jpeg'));
    logPrint('body: $body');
    try {
      Response response = await api.postSaveFile(body: body);
      logPrint('response: ${response.toString()}');
      logPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        ResponseData responseData = ResponseData.fromJson(response.data);
        setState(() {
          fileUpload = UploadFile.fromJson(responseData.data).files;
          widget.onUpload(fileUpload);
          isCompleteGenerate = true;
        });
      }
    } catch (error) {
      logPrint(error.toString());
      showToastError(error.toString());
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }
}

// Penjelasan Coding RSA
// Berikut adalah penjelasan secara rinci dari setiap bagian kode yang telah dibuat. Kode ini merupakan implementasi enkripsi dan dekripsi dengan metode RSA (Rivest-Shamir-Adleman) menggunakan Flutter.

// 1. Imports
// dart
// Copy code
// import 'package:flutter/material.dart';
// import 'dart:math';
// package:flutter/material.dart: Digunakan untuk membuat antarmuka pengguna (UI) berbasis material design di Flutter.
// dart:math: Digunakan untuk mendapatkan berbagai fungsi matematika seperti bilangan acak, pemangkatan modular, dll.
// 2. Class RSADemo
// dart
// Copy code
// class RSADemo extends StatefulWidget {
//   @override
//   _RSADemoState createState() => _RSADemoState();
// }
// RSADemo: Class ini adalah widget yang bersifat stateful, yang berarti dapat berubah seiring dengan interaksi pengguna.
// _RSADemoState: Ini adalah class yang berisi logika utama aplikasi, seperti enkripsi, dekripsi, dan pengelolaan state.
// 3. State Variables
// dart
// Copy code
// final TextEditingController _controller = TextEditingController();
// final TextEditingController _encryptedController = TextEditingController();
// String _encryptedMessage = '';
// String _decryptedMessage = '';

// final int p = 47;
// final int q = 71;
// late int n;
// late int phi;
// late int e;
// late int d;
// _controller dan _encryptedController: Controller ini digunakan untuk mengambil input dari pengguna pada TextField.
// _encryptedMessage dan _decryptedMessage: Variabel yang menyimpan pesan terenkripsi dan terdekripsi.
// p dan q: Dua bilangan prima yang digunakan dalam algoritma RSA.
// n, phi, e, dan d: Parameter penting dalam RSA:
// n: Hasil perkalian dua bilangan prima p dan q.
// phi: Nilai yang dihitung dari (p-1) * (q-1) untuk digunakan dalam menentukan e dan d.
// e: Eksponen publik yang digunakan untuk enkripsi.
// d: Eksponen privat yang digunakan untuk dekripsi.
// 4. Inisialisasi RSA pada initState()
// dart
// Copy code
// @override
// void initState() {
//   super.initState();
//   _initializeRSA();
// }
// initState(): Fungsi yang dipanggil saat widget pertama kali diinisialisasi. Di sini, nilai-nilai RSA seperti n, phi, e, dan d diatur menggunakan _initializeRSA().
// 5. Inisialisasi Parameter RSA
// dart
// Copy code
// void _initializeRSA() {
//   n = p * q; // n = 3337
//   phi = (p - 1) * (q - 1); // phi = 3220
//   e = _findE(phi); // mencari e
//   d = _findD(e, phi); // mencari d
// }
// _initializeRSA(): Fungsi ini menginisialisasi nilai n, phi, e, dan d.
// n adalah hasil perkalian dari p dan q.
// phi adalah hasil dari (p - 1) * (q - 1) yang digunakan untuk menemukan e dan d.
// _findE() digunakan untuk menemukan e, dan _findD() untuk menemukan d.
// 6. Menentukan e dan d
// dart
// Copy code
// int _findE(int phi) {
//   int e = 2;
//   while (e < phi) {
//     if (_gcd(e, phi) == 1) {
//       break;
//     }
//     e++;
//   }
//   return e;
// }

// int _findD(int e, int phi) {
//   int d = 1;
//   while ((e * d) % phi != 1) {
//     d++;
//   }
//   return d;
// }
// _findE(): Fungsi ini mencari e (eksponen publik) yang relatif prima terhadap phi. e harus memenuhi syarat gcd(e, phi) == 1.
// _findD(): Fungsi ini mencari nilai d (eksponen privat) yang memenuhi (e * d) % phi == 1. Ini merupakan bagian dari kunci privat RSA.
// 7. Greatest Common Divisor (GCD)
// dart
// Copy code
// int _gcd(int a, int b) {
//   return b == 0 ? a : _gcd(b, a % b);
// }
// _gcd(): Menggunakan algoritma rekursif Euclidean untuk menghitung Greatest Common Divisor (GCD) dari dua angka. Ini digunakan dalam proses menemukan e.
// 8. Metode Enkripsi
// dart
// Copy code
// String _encryptMessage(String message) {
//   List<int> encryptedMessage = message.codeUnits.map((int char) {
//     return _modExp(char, e, n);
//   }).toList();

//   return encryptedMessage.join(','); // Hasil terenkripsi
// }
// _encryptMessage(): Mengubah pesan menjadi daftar bilangan ASCII, kemudian mengenkripsi setiap bilangan tersebut dengan modular exponentiation menggunakan kunci publik (e, n). Hasil enkripsi dikembalikan sebagai string dengan bilangan terenkripsi yang dipisahkan koma.
// 9. Modular Exponentiation
// dart
// Copy code
// int _modExp(int base, int exp, int mod) {
//   int result = 1;
//   while (exp > 0) {
//     if (exp % 2 == 1) {
//       result = (result * base) % mod;
//     }
//     base = (base * base) % mod;
//     exp = exp ~/ 2;
//   }
//   return result;
// }
// _modExp(): Fungsi ini digunakan untuk menghitung (base^exp) % mod secara efisien. Ini adalah bagian inti dari enkripsi dan dekripsi dalam RSA.
// 10. Metode Dekripsi
// dart
// Copy code
// String _decryptMessage(String encryptedMessage) {
//   List<int> encryptedValues = encryptedMessage.split(',').map((String value) {
//     return int.parse(value);
//   }).toList();

//   List<int> decryptedMessage = encryptedValues.map((int encryptedChar) {
//     return _modExp(encryptedChar, d, n);
//   }).toList();

//   return String.fromCharCodes(decryptedMessage);
// }
// _decryptMessage(): Mengambil pesan terenkripsi (yang berupa string dari angka terenkripsi) dan mengubahnya kembali menjadi karakter asli menggunakan kunci privat (d, n). Hasil dekripsi dikembalikan dalam bentuk string.
// 11. Fungsi onEncrypt() dan onDecrypt()
// dart
// Copy code
// void _onEncrypt() {
//   String message = _controller.text;
//   setState(() {
//     _encryptedMessage = _encryptMessage(message);
//     _decryptedMessage = ''; // Hapus hasil dekripsi sebelumnya
//   });
// }

// void _onDecrypt() {
//   String encryptedMessage = _encryptedController.text;
//   setState(() {
//     _decryptedMessage = _decryptMessage(encryptedMessage);
//   });
// }
// _onEncrypt(): Mengambil input dari pengguna, mengenkripsinya, lalu memperbarui state untuk menampilkan hasil enkripsi.
// _onDecrypt(): Mengambil pesan terenkripsi dari input, lalu mendekripsinya menggunakan kunci privat dan memperbarui state.
// 12. Membangun UI (User Interface)
// dart
// Copy code
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('RSA Encryption & Decryption Demo'),
//     ),
//     body: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           TextField(
//             controller: _controller,
//             decoration: InputDecoration(
//               labelText: 'Enter message to encrypt',
//             ),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _onEncrypt,
//             child: Text('Encrypt'),
//           ),
//           SizedBox(height: 20),
//           if (_encryptedMessage.isNotEmpty)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Encrypted Message: $_encryptedMessage',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 20),
//               ],
//             ),
//           TextField(
//             controller: _encryptedController,
//             decoration: InputDecoration(
//               labelText: 'Enter encrypted message to decrypt',
//             ),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _onDecrypt,
//             child: Text('Decrypt'),
//           ),
//           SizedBox(height: 20),
//           if (_decryptedMessage.isNotEmpty)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Decrypted Message: $_decryptedMessage',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     ),
//   );
// }
// UI terdiri dari dua input field dan dua tombol:
// TextField pertama: Untuk input pesan yang akan dienkripsi.
// Button Encrypt: Mengenkripsi pesan yang dimasukkan.
// TextField kedua: Untuk input pesan terenkripsi yang akan didekripsi.
// Button Decrypt: Mendekripsi pesan terenkripsi.
// Alur Kerja:
// Pengguna memasukkan teks di TextField pertama, kemudian menekan tombol Encrypt.
// Hasil enkripsi ditampilkan di bawah tombol.
// Pengguna dapat menyalin teks terenkripsi, memasukkannya ke TextField kedua, lalu menekan tombol Decrypt.
// Hasil dekripsi ditampilkan di bawah tombol Decrypt.
