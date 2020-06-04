import 'package:flutter/material.dart';

import '../event/error_event.dart';
import '../style/string_set.dart';

class DaoResult {
  static dynamic context;

  dynamic data;
  bool isSuccess;
  int count;

  DaoResult(
      this.data,
      this.isSuccess,
      );

  static DaoResult filterHead(dynamic object) {
    dynamic head = object.head;
    if (head == null || !head.hasIfSt()) {
      return DaoResult(
          ErrorEvent.errorMessageToast(
              StringSet.NETWORK_SERVER_EXCEPTION + StringSet.PERIOD),
          false);
    }
    switch (head.ifSt) {
      case 0:
        return DaoResult(
            ErrorEvent.errorMessageToast(head.ifMsg + StringSet.PERIOD), false);
      case 1:
        return DaoResult(object, true);
      case 10:
//        Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
//        return DaoResult(
//            ErrorEvent.errorMessageToast(
//                StringSet.LOGIN_EXCEPTION + StringSet.PERIOD),
//            false);
      case 11:
        return DaoResult(
            ErrorEvent.errorMessageToast(
                StringSet.PERMISSION_DENIED + StringSet.PERIOD),
            false);
      case 12:
        return DaoResult(
            ErrorEvent.errorMessageToast(
                StringSet.IP_EXCEPTION + StringSet.PERIOD),
            false);
      case 41:
        return DaoResult(
            ErrorEvent.errorMessageToast(
                StringSet.DATABASE_CONNECTION_FAILED + StringSet.PERIOD),
            false);
      case 42:
        return DaoResult(
            ErrorEvent.errorMessageToast(
                StringSet.INSTRUCTION_SUBMISSION_FAILED + StringSet.PERIOD),
            false);
      case 43:
        return DaoResult(
            ErrorEvent.errorMessageToast(
                StringSet.THIRD_PARTY_INTERFACE_FAILED + StringSet.PERIOD),
            false);
      case 45:
        return DaoResult(
            ErrorEvent.errorMessageToast(
                StringSet.DATABASE_SUBMISSION_FAILED + StringSet.PERIOD),
            false);
      case 46:
        return DaoResult(
            ErrorEvent.errorMessageToast(
                StringSet.WRONG_PARAMETER + StringSet.PERIOD),
            false);
      case 47:
        return DaoResult(
            ErrorEvent.errorMessageToast(
                StringSet.WRONG_USER_NAME_OR_PASSWORD + StringSet.PERIOD),
            false);
      case 48:
        return DaoResult(
            ErrorEvent.errorMessageToast(
                StringSet.WRONG_SECURITY_CODE + StringSet.PERIOD),
            false);
      default:
        return DaoResult(
            ErrorEvent.errorMessageToast(
                StringSet.UNKNOWN_ERROR + StringSet.PERIOD),
            false);
    }
  }
}
