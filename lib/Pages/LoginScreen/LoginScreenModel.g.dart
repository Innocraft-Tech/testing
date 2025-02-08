// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LoginScreenModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginScreenModel on LoginScreenModelBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'LoginScreenModelBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$mobileNumberAtom =
      Atom(name: 'LoginScreenModelBase.mobileNumber', context: context);

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

  late final _$LoginScreenModelBaseActionController =
      ActionController(name: 'LoginScreenModelBase', context: context);

  @override
  void setIsLoading(bool loading) {
    final _$actionInfo = _$LoginScreenModelBaseActionController.startAction(
        name: 'LoginScreenModelBase.setIsLoading');
    try {
      return super.setIsLoading(loading);
    } finally {
      _$LoginScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMobileNumber(String number) {
    final _$actionInfo = _$LoginScreenModelBaseActionController.startAction(
        name: 'LoginScreenModelBase.setMobileNumber');
    try {
      return super.setMobileNumber(number);
    } finally {
      _$LoginScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
mobileNumber: ${mobileNumber}
    ''';
  }
}
