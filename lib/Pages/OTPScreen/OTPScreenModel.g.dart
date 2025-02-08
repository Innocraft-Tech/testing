// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OTPScreenModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OTPScreenModel on OTPScreenModelBase, Store {
  late final _$verificationIDAtom =
      Atom(name: 'OTPScreenModelBase.verificationID', context: context);

  @override
  String get verificationID {
    _$verificationIDAtom.reportRead();
    return super.verificationID;
  }

  @override
  set verificationID(String value) {
    _$verificationIDAtom.reportWrite(value, super.verificationID, () {
      super.verificationID = value;
    });
  }

  late final _$otpAtom = Atom(name: 'OTPScreenModelBase.otp', context: context);

  @override
  String get otp {
    _$otpAtom.reportRead();
    return super.otp;
  }

  @override
  set otp(String value) {
    _$otpAtom.reportWrite(value, super.otp, () {
      super.otp = value;
    });
  }

  late final _$mobileNumberAtom =
      Atom(name: 'OTPScreenModelBase.mobileNumber', context: context);

  @override
  String get mobileNumber {
    _$mobileNumberAtom.reportRead();
    return super.mobileNumber;
  }

  @override
  set mobileNumber(String value) {
    _$mobileNumberAtom.reportWrite(value, super.mobileNumber, () {
      super.mobileNumber = value;
    });
  }

  late final _$OTPScreenModelBaseActionController =
      ActionController(name: 'OTPScreenModelBase', context: context);

  @override
  void setVerificationID(String id) {
    final _$actionInfo = _$OTPScreenModelBaseActionController.startAction(
        name: 'OTPScreenModelBase.setVerificationID');
    try {
      return super.setVerificationID(id);
    } finally {
      _$OTPScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setOtp(String id) {
    final _$actionInfo = _$OTPScreenModelBaseActionController.startAction(
        name: 'OTPScreenModelBase.setOtp');
    try {
      return super.setOtp(id);
    } finally {
      _$OTPScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMobileNumber(String number) {
    final _$actionInfo = _$OTPScreenModelBaseActionController.startAction(
        name: 'OTPScreenModelBase.setMobileNumber');
    try {
      return super.setMobileNumber(number);
    } finally {
      _$OTPScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
verificationID: ${verificationID},
otp: ${otp},
mobileNumber: ${mobileNumber}
    ''';
  }
}
