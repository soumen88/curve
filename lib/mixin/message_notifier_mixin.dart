import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// mixin to be user on a [ChangeNotifier] class
/// It provides two fields [error] and [info] and two methods [notifyError] and [notifyInfo]
/// Useful used in combination with [MessageListener] to display error or information messages to users
mixin MessageNotifierMixin on ChangeNotifier {
  String TAG = "MessageNotifierMixin";
  String? _error;
  String? get error => _error;
  bool isError = false;
  String? _info;
  String? get info => _info;

  void notifyError(String error) {
    _info = error;
    isError = true;
    notifyListeners();
  }

  void clearError() {
    isError = false;
    _info = null;
  }

  void notifyInfo(String info) {
    developer.log(TAG, name : "Info received $info");
    _info = info;
    isError = false;
    notifyListeners();
  }

  void clearInfo() {
    _info = null;
  }

}