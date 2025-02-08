// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocationPickerScreenModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LocationPickerScreenModel on LocationPickerScreenModelBase, Store {
  late final _$currentLocationAtom = Atom(
      name: 'LocationPickerScreenModelBase.currentLocation', context: context);

  @override
  LatLng get currentLocation {
    _$currentLocationAtom.reportRead();
    return super.currentLocation;
  }

  @override
  set currentLocation(LatLng value) {
    _$currentLocationAtom.reportWrite(value, super.currentLocation, () {
      super.currentLocation = value;
    });
  }

  late final _$addressNameAtom =
      Atom(name: 'LocationPickerScreenModelBase.addressName', context: context);

  @override
  String get addressName {
    _$addressNameAtom.reportRead();
    return super.addressName;
  }

  @override
  set addressName(String value) {
    _$addressNameAtom.reportWrite(value, super.addressName, () {
      super.addressName = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'LocationPickerScreenModelBase.isLoading', context: context);

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

  late final _$addressAtom =
      Atom(name: 'LocationPickerScreenModelBase.address', context: context);

  @override
  String get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(String value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  late final _$addressTypeAtom =
      Atom(name: 'LocationPickerScreenModelBase.addressType', context: context);

  @override
  String get addressType {
    _$addressTypeAtom.reportRead();
    return super.addressType;
  }

  @override
  set addressType(String value) {
    _$addressTypeAtom.reportWrite(value, super.addressType, () {
      super.addressType = value;
    });
  }

  late final _$LocationPickerScreenModelBaseActionController =
      ActionController(name: 'LocationPickerScreenModelBase', context: context);

  @override
  void setCurrentLocation(LatLng location) {
    final _$actionInfo = _$LocationPickerScreenModelBaseActionController
        .startAction(name: 'LocationPickerScreenModelBase.setCurrentLocation');
    try {
      return super.setCurrentLocation(location);
    } finally {
      _$LocationPickerScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAddressName(String address) {
    final _$actionInfo = _$LocationPickerScreenModelBaseActionController
        .startAction(name: 'LocationPickerScreenModelBase.setAddressName');
    try {
      return super.setAddressName(address);
    } finally {
      _$LocationPickerScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool loading) {
    final _$actionInfo = _$LocationPickerScreenModelBaseActionController
        .startAction(name: 'LocationPickerScreenModelBase.setLoading');
    try {
      return super.setLoading(loading);
    } finally {
      _$LocationPickerScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAddress(String address) {
    final _$actionInfo = _$LocationPickerScreenModelBaseActionController
        .startAction(name: 'LocationPickerScreenModelBase.setAddress');
    try {
      return super.setAddress(address);
    } finally {
      _$LocationPickerScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAddressType(String addressType) {
    final _$actionInfo = _$LocationPickerScreenModelBaseActionController
        .startAction(name: 'LocationPickerScreenModelBase.setAddressType');
    try {
      return super.setAddressType(addressType);
    } finally {
      _$LocationPickerScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentLocation: ${currentLocation},
addressName: ${addressName},
isLoading: ${isLoading},
address: ${address},
addressType: ${addressType}
    ''';
  }
}
