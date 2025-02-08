// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PilotRatingsScreenModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PilotRatingsScreenModel on PilotRatingsScreenModelBase, Store {
  late final _$currentRideRequestAtom = Atom(
      name: 'PilotRatingsScreenModelBase.currentRideRequest', context: context);

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

  late final _$isLoadingAtom =
      Atom(name: 'PilotRatingsScreenModelBase.isLoading', context: context);

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

  late final _$PilotRatingsScreenModelBaseActionController =
      ActionController(name: 'PilotRatingsScreenModelBase', context: context);

  @override
  void setCurrentRideRequest(RideBO ride) {
    final _$actionInfo = _$PilotRatingsScreenModelBaseActionController
        .startAction(name: 'PilotRatingsScreenModelBase.setCurrentRideRequest');
    try {
      return super.setCurrentRideRequest(ride);
    } finally {
      _$PilotRatingsScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsLoading(bool value) {
    final _$actionInfo = _$PilotRatingsScreenModelBaseActionController
        .startAction(name: 'PilotRatingsScreenModelBase.setIsLoading');
    try {
      return super.setIsLoading(value);
    } finally {
      _$PilotRatingsScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentRideRequest: ${currentRideRequest},
isLoading: ${isLoading}
    ''';
  }
}
