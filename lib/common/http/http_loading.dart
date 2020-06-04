import 'package:flutter/material.dart';

Set<Uri> _set = Set();
bool _loadingStatus = false;

class HttpLoading {
  static dynamic context;

  static void before({Uri uri}) {
    _set.add(uri);
    if (_loadingStatus == true || _set.length >= 2) {
      return;
    }
    _showLoadingDialog();
  }

  static void complete({Uri uri}) {
    _set.remove(uri);
    if (_set.length == 0 && _loadingStatus == true) {
      _dismissLoadingDialog();
    }
  }

  static void _showLoadingDialog() {
    _loadingStatus = true;
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  static void _dismissLoadingDialog() {
    _loadingStatus = false;
    Navigator.of(context, rootNavigator: true).pop();
  }
}
