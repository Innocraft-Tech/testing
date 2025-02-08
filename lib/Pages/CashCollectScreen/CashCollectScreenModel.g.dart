// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CashCollectScreenModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CashCollectScreenModel on CashCollectScreenModelBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'CashCollectScreenModelBase.isLoading', context: context);

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

  late final _$currentLocationAtom = Atom(
      name: 'CashCollectScreenModelBase.currentLocation', context: context);

  @override
  LatLng get currentLocation {
    _$currentLocationAtom.reportRead();
    return super.currentLocation;
  }

  bool _currentLocationIsInitialized = false;

  @override
  set currentLocation(LatLng value) {
    _$currentLocationAtom.reportWrite(
        value, _currentLocationIsInitialized ? super.currentLocation : null,
        () {
      super.currentLocation = value;
      _currentLocationIsInitialized = true;
    });
  }

  late final _$currentRideRequestAtom = Atom(
      name: 'CashCollectScreenModelBase.currentRideRequest', context: context);

  @override
  RideBO get currentRideRequest {
    _$currentRideRequestAtom.reportRead();
    return super.currentRideRequest;
  }

  bool _currentRideRequestIsInitialized = false;

  @override
  set currentRideRequest(RideBO value) {
    _$currentRideRequestAtom.reportWrite(value,
        _currentRideRequestIsInitialized ? super.currentRideRequest : null, () {
      super.currentRideRequest = value;
      _currentRideRequestIsInitialized = true;
    });
  }

  late final _$CashCollectScreenModelBaseActionController =
      ActionController(name: 'CashCollectScreenModelBase', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$CashCollectScreenModelBaseActionController
        .startAction(name: 'CashCollectScreenModelBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$CashCollectScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentLocation(LatLng location) {
    final _$actionInfo = _$CashCollectScreenModelBaseActionController
        .startAction(name: 'CashCollectScreenModelBase.setCurrentLocation');
    try {
      return super.setCurrentLocation(location);
    } finally {
      _$CashCollectScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentRideRequest(RideBO rideBO) {
    final _$actionInfo = _$CashCollectScreenModelBaseActionController
        .startAction(name: 'CashCollectScreenModelBase.setCurrentRideRequest');
    try {
      return super.setCurrentRideRequest(rideBO);
    } finally {
      _$CashCollectScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
currentLocation: ${currentLocation},
currentRideRequest: ${currentRideRequest}
    ''';
  }
}
