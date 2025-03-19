import 'package:base/api/Client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class GlobalStore with ChangeNotifier {
  // ignore: unused_field
  final Client _client;
  GlobalStore(this._client);

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;
  void handleChangeViews(int i) {
    _tabIndex = i;
    notifyListeners();
  }

  bool _showFloatingButton = false;
  bool get showFloatingButton => _showFloatingButton;
  void changeStatusFloatingButton(bool status) {
    _showFloatingButton = status;
    notifyListeners();
  }

  final int _shoppingCart = 100;
  int get shoppingCart => _shoppingCart;
}
