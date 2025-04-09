import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class CheckConnectionInternet {
  static final CheckConnectionInternet _instance =
      CheckConnectionInternet._internal();
  final InternetConnection internetChecker = InternetConnection();
  bool _hasConnection = true;

  factory CheckConnectionInternet() {
    return _instance;
  }

  CheckConnectionInternet._internal() {
    // Inisialisasi singleton dan mulai memantau koneksi
    startMonitoring();
  }

  // Start monitoring the connection in the background
  void startMonitoring() {
    internetChecker.onStatusChange.listen((status) {
      _hasConnection = status == InternetStatus.connected;
    });
  }

  // Cek koneksi dari cache
  bool get hasConnection => _hasConnection;
}

// import 'dart:async';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// class CheckConnectionInternet {
//   final InternetConnection internetChecker = InternetConnection();
//   bool _hasConnection = true;
//   StreamSubscription? _subscription;

//   // Start monitoring the connection
//   void startMonitoring() {
//     _subscription = internetChecker.onStatusChange.listen((status) {
//       _hasConnection = status == InternetStatus.connected;
//     });
//   }

//   // Stop monitoring when it's no longer needed
//   void stopMonitoring() {
//     _subscription?.cancel();
//   }

//   // Check if there's internet connection (cached result)
//   bool get hasConnection => _hasConnection;
// }
