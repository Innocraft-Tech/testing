// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserAccountScreenModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserAccountScreenModel on UserAccountScreenModelBase, Store {
  late final _$userAtom =
      Atom(name: 'UserAccountScreenModelBase.user', context: context);

  @override
  UserBO get user {
    _$userAtom.reportRead();
    return super.user;
  }

  bool _userIsInitialized = false;

  @override
  set user(UserBO value) {
    _$userAtom.reportWrite(value, _userIsInitialized ? super.user : null, () {
      super.user = value;
      _userIsInitialized = true;
    });
  }

  late final _$scourceLocationAtom = Atom(
      name: 'UserAccountScreenModelBase.scourceLocation', context: context);

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
      Atom(name: 'UserAccountScreenModelBase.isLoading', context: context);

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

  late final _$UserAccountScreenModelBaseActionController =
      ActionController(name: 'UserAccountScreenModelBase', context: context);

  @override
  void setUser(UserBO user) {
    final _$actionInfo = _$UserAccountScreenModelBaseActionController
        .startAction(name: 'UserAccountScreenModelBase.setUser');
    try {
      return super.setUser(user);
    } finally {
      _$UserAccountScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSourceLocation(LatLng location) {
    final _$actionInfo = _$UserAccountScreenModelBaseActionController
        .startAction(name: 'UserAccountScreenModelBase.setSourceLocation');
    try {
      return super.setSourceLocation(location);
    } finally {
      _$UserAccountScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool loading) {
    final _$actionInfo = _$UserAccountScreenModelBaseActionController
        .startAction(name: 'UserAccountScreenModelBase.setLoading');
    try {
      return super.setLoading(loading);
    } finally {
      _$UserAccountScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user},
scourceLocation: ${scourceLocation},
isLoading: ${isLoading}
    ''';
  }
}
