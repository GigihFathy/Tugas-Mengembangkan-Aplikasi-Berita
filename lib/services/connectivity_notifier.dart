import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class ConnectivityNotifier extends ChangeNotifier {
  bool _connected = false;
  bool get connected => _connected;

  ConnectivityNotifier() {
    Connectivity connectivity = Connectivity();
    connectivity.onConnectivityChanged.listen((result) async {
     
      if (result == ConnectivityResult.wifi) {
        _connected = true;
        notifyListeners();
      } else {
        _connected = true;
        notifyListeners();
      }
    });
  }
}
