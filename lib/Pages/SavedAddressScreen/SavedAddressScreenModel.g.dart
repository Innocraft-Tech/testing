// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SavedAddressScreenModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SavedAddressScreenModel on SavedAddressScreenModelBase, Store {
  late final _$scourceLocationAtom = Atom(
      name: 'SavedAddressScreenModelBase.scourceLocation', context: context);

  @override
  LatLng get scourceLocation {
    _$scourceLocationAtom.reportRead();
    return super.scourceLocation;
  }

  bool _scourceLocationIsInitialized = false;

  @override
  set scourceLocation(LatLng value) {
    _$scourceLocationAtom.reportWrite(
        value, _scourceLocationIsInitialized ? super.scourceLocation : null,
        () {
      super.scourceLocation = value;
      _scourceLocationIsInitialized = true;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'SavedAddressScreenModelBase.isLoading', context: context);

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
      Atom(name: 'SavedAddressScreenModelBase.address', context: context);

  @override
  List<AddressBO> get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(List<AddressBO> value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  late final _$SavedAddressScreenModelBaseActionController =
      ActionController(name: 'SavedAddressScreenModelBase', context: context);

  @override
  void setSourceLocation(LatLng location) {
    final _$actionInfo = _$SavedAddressScreenModelBaseActionController
        .startAction(name: 'SavedAddressScreenModelBase.setSourceLocation');
    try {
      return super.setSourceLocation(location);
    } finally {
      _$SavedAddressScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool loading) {
    final _$actionInfo = _$SavedAddressScreenModelBaseActionController
        .startAction(name: 'SavedAddressScreenModelBase.setLoading');
    try {
      return super.setLoading(loading);
    } finally {
      _$SavedAddressScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAddress(List<AddressBO> address) {
    final _$actionInfo = _$SavedAddressScreenModelBaseActionController
        .startAction(name: 'SavedAddressScreenModelBase.setAddress');
    try {
      return super.setAddress(address);
    } finally {
      _$SavedAddressScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
scourceLocation: ${scourceLocation},
isLoading: ${isLoading},
address: ${address}
    ''';
  }
}
