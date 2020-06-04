import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import '../common/event/error_event.dart';

class ErrorHandle extends StatefulWidget {
  final Widget child;

  ErrorHandle({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  _ErrorHandleState createState() => _ErrorHandleState();
}

class _ErrorHandleState extends State<ErrorHandle> {
  StreamSubscription _stream;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    _stream = ErrorEvent.eventBus.on<ErrorEvent>().listen((event) {
      Fluttertoast.showToast(msg: event.message);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stream?.cancel();
  }
}