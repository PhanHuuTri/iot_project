import 'package:flutter/cupertino.dart';

import '../../main.dart';

class ValidatorText {
  static String empty({required String fieldName}) {
    return fieldName +
        ' ' +
        ScreenUtil.t(I18nKey.mustNotBeEmpty)!.toLowerCase();
  }

  static String invalidFormat({required String fieldName}) {
    var invalidFormat = ScreenUtil.t(I18nKey.invalidFormat)!;
    var invalid = ScreenUtil.t(I18nKey.invalid)!;
    if (invalidFormat.startsWith(ScreenUtil.t(I18nKey.invalid)!)) {
      return invalidFormat.replaceRange(invalidFormat.indexOf(' '),
              invalidFormat.indexOf(' '), ' ' + fieldName.toLowerCase()) +
          ' ';
    } else {
      return invalidFormat.substring(0, invalidFormat.length - invalid.length) +
          fieldName.toLowerCase() +
          ' ' +
          invalid.toLowerCase();
    }
  }

  static String atLeast({required String fieldName, required double atLeast}) {
    return fieldName +
        ' ' +
        ScreenUtil.t(I18nKey.mustBeAtLeast)!.toLowerCase() +
        ' $atLeast ' +
        ScreenUtil.t(I18nKey.characters)!.toLowerCase();
  }

  static String moreThan(
      {required String fieldName, required double moreThan}) {
    return fieldName +
        ' ' +
        ScreenUtil.t(I18nKey.mustNotBeMoreThan)!.toLowerCase() +
        ' $moreThan ' +
        ScreenUtil.t(I18nKey.characters)!.toLowerCase();
  }

  static String mustBeAfter({
    required String end,
    required String start,
  }) {
    return end +
        ' ' +
        ScreenUtil.t(I18nKey.mustBeAfter)!.toLowerCase() +
        ' ' +
        start;
  }
}

String showError(String errorCode, BuildContext context) {
  ScreenUtil.init(context);
  String message = '';
  switch (errorCode) {
    case '100':
      message = ScreenUtil.t(I18nKey.notHavePermissionToControlDoor)!;
      break;
    case '900':
      message = ScreenUtil.t(I18nKey.unauthorized)!;
      break;
    case '901':
      message = ScreenUtil.t(I18nKey.tokenExpired)!;
      break;
    case '902':
      message = ScreenUtil.t(I18nKey.invalidToken)!;
      break;
    case '1000':
      message = ScreenUtil.t(I18nKey.invalidEmailOrPassword)!;
      break;
    case '1001':
      message = ScreenUtil.t(I18nKey.userNotFound)!;
      break;
    case '1002':
      message = ScreenUtil.t(I18nKey.notificationNotFound)!;
      break;
    case '1003':
      message = ScreenUtil.t(I18nKey.emailAlreadyExists)!;
      break;
    case '1004':
      message = ScreenUtil.t(I18nKey.phoneNumberAlreadyExists)!;
      break;
    case '1005':
      message = ScreenUtil.t(I18nKey.invalidPassword)!;
      break;
    case '1006':
      message = ScreenUtil.t(I18nKey.roleNotFound)!;
      break;
    case '1007':
      message = ScreenUtil.t(I18nKey.roleNameAlreadyExists)!;
      break;
    case '1008':
      message = ScreenUtil.t(I18nKey.moduleNotFound)!;
      break;
    case '1009':
      message = ScreenUtil.t(I18nKey.moduleAlreadyExists)!;
      break;
    case '1010':
      message = ScreenUtil.t(I18nKey.permissionAlreadyExists)!;
      break;
    case '1011':
      message = ScreenUtil.t(I18nKey.invalidResetId)!;
      break;
    case '1100':
      message = ScreenUtil.t(I18nKey.pageAndLimitShouldBeNumberic)!;
      break;
    case '1101':
      message = ScreenUtil.t(I18nKey.mustBeAnEmail)!;
      break;
    case '1102':
      message = ScreenUtil.t(I18nKey.shouldNotBeEmpty)!;
      break;
    case '1103':
      message = ScreenUtil.t(I18nKey.mustBeString)!;
      break;
    case '1104':
      message = ScreenUtil.t(I18nKey.mustBeNumber)!;
      break;
    case '1105':
      message = ScreenUtil.t(I18nKey.mustBeBetween)!;
      break;
    case '1106':
      message = ScreenUtil.t(I18nKey.mustBeArray)!;
      break;
    case '1107':
      message = ScreenUtil.t(I18nKey.eachValueMustBeString)!;
      break;
    case '1200':
      message = ScreenUtil.t(I18nKey.doorNotFound)!;
      break;
    case '1201':
      message = ScreenUtil.t(I18nKey.unlockDoorFail)!;
      break;
    case '1202':
      message = ScreenUtil.t(I18nKey.openDoorFail)!;
      break;
    case '1203':
      message = ScreenUtil.t(I18nKey.lockDoorFail)!;
      break;
    default:
      message = '';
      break;
  }
  return message;
}
