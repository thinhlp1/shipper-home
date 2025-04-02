import 'package:base/api/Client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class GlobalStore with ChangeNotifier {
  // ignore: unused_field
  final Client _client;
  GlobalStore(this._client);

  int _tabIndex = 0;
  String _searchText = '';
  bool _shouldFetchCustomer = false;
  String _markNotCustomer = '';

  int get tabIndex => _tabIndex;
  String get searchText => _searchText;
  bool get shouldFetchCustomer => _shouldFetchCustomer;
  String get markNotCustomer => _markNotCustomer;

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

  void switchToCustomerTabAndSearch(String searchText) {
    _tabIndex = 0;
    _searchText = searchText;
    notifyListeners();
  }

  void clearSearchText() {
    _searchText = '';
    notifyListeners();
  }

  void setShouldFetchCustomer(bool status) {
    _shouldFetchCustomer = status;
    notifyListeners();
  }

  void setMarkNotCustomer(String phone) {
    _markNotCustomer = phone;
    notifyListeners();
  }
}
