// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PilotFindingScreenModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PilotFindingScreenModel on PilotFindingScreenModelBase, Store {
  late final _$sourceLocationAtom = Atom(
      name: 'PilotFindingScreenModelBase.sourceLocation', context: context);

  @override
  LatLng get sourceLocation {
    _$sourceLocationAtom.reportRead();
    return super.sourceLocation;
  }

  bool _sourceLocationIsInitialized = false;

  @override
  set sourceLocation(LatLng value) {
    _$sourceLocationAtom.reportWrite(
        value, _sourceLocationIsInitialized ? super.sourceLocation : null, () {
      super.sourceLocation = value;
      _sourceLocationIsInitialized = true;
    });
  }

  late final _$destinationLocationAtom = Atom(
      name: 'PilotFindingScreenModelBase.destinationLocation',
      context: context);

  @override
  LatLng get destinationLocation {
    _$destinationLocationAtom.reportRead();
    return super.destinationLocation;
  }

  bool _destinationLocationIsInitialized = false;

  @override
  set destinationLocation(LatLng value) {
    _$destinationLocationAtom.reportWrite(value,
        _destinationLocationIsInitialized ? super.destinationLocation : null,
        () {
      super.destinationLocation = value;
      _destinationLocationIsInitialized = true;
    });
  }

  late final _$currentRideAtom =
      Atom(name: 'PilotFindingScreenModelBase.currentRide', context: context);

  @override
  RideBO get currentRide {
    _$currentRideAtom.reportRead();
    return super.currentRide;
  }

  bool _currentRideIsInitialized = false;

  @override
  set currentRide(RideBO value) {
    _$currentRideAtom.reportWrite(
        value, _currentRideIsInitialized ? super.currentRide : null, () {
      super.currentRide = value;
      _currentRideIsInitialized = true;
    });
  }

  late final _$rideIdAtom =
      Atom(name: 'PilotFindingScreenModelBase.rideId', context: context);

  @override
  String get rideId {
    _$rideIdAtom.reportRead();
    return super.rideId;
  }

  @override
  set rideId(String value) {
    _$rideIdAtom.reportWrite(value, super.rideId, () {
      super.rideId = value;
    });
  }

  late final _$polypointsAtom =
      Atom(name: 'PilotFindingScreenModelBase.polypoints', context: context);

  @override
  List<LatLng> get polypoints {
    _$polypointsAtom.reportRead();
    return super.polypoints;
  }

  @override
  set polypoints(List<LatLng> value) {
    _$polypointsAtom.reportWrite(value, super.polypoints, () {
      super.polypoints = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'PilotFindingScreenModelBase.isLoading', context: context);

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

  late final _$priceAtom =
      Atom(name: 'PilotFindingScreenModelBase.price', context: context);

  @override
  String get price {
    _$priceAtom.reportRead();
    return super.price;
  }

  @override
  set price(String value) {
    _$priceAtom.reportWrite(value, super.price, () {
      super.price = value;
    });
  }

  late final _$isFareLoadingAtom =
      Atom(name: 'PilotFindingScreenModelBase.isFareLoading', context: context);

  @override
  bool get isFareLoading {
    _$isFareLoadingAtom.reportRead();
    return super.isFareLoading;
  }

  @override
  set isFareLoading(bool value) {
    _$isFareLoadingAtom.reportWrite(value, super.isFareLoading, () {
      super.isFareLoading = value;
    });
  }

  late final _$pilotsAtom =
      Atom(name: 'PilotFindingScreenModelBase.pilots', context: context);

  @override
  ObservableList<PilotRequestBO> get pilots {
    _$pilotsAtom.reportRead();
    return super.pilots;
  }

  @override
  set pilots(ObservableList<PilotRequestBO> value) {
    _$pilotsAtom.reportWrite(value, super.pilots, () {
      super.pilots = value;
    });
  }

  late final _$PilotFindingScreenModelBaseActionController =
      ActionController(name: 'PilotFindingScreenModelBase', context: context);

  @override
  void setSourceLocation(LatLng location) {
    final _$actionInfo = _$PilotFindingScreenModelBaseActionController
        .startAction(name: 'PilotFindingScreenModelBase.setSourceLocation');
    try {
      return super.setSourceLocation(location);
    } finally {
      _$PilotFindingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDestinationLocation(LatLng location) {
    final _$actionInfo =
        _$PilotFindingScreenModelBaseActionController.startAction(
            name: 'PilotFindingScreenModelBase.setDestinationLocation');
    try {
      return super.setDestinationLocation(location);
    } finally {
      _$PilotFindingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentRide(RideBO ride) {
    final _$actionInfo = _$PilotFindingScreenModelBaseActionController
        .startAction(name: 'PilotFindingScreenModelBase.setCurrentRide');
    try {
      return super.setCurrentRide(ride);
    } finally {
      _$PilotFindingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRideId(String id) {
    final _$actionInfo = _$PilotFindingScreenModelBaseActionController
        .startAction(name: 'PilotFindingScreenModelBase.setRideId');
    try {
      return super.setRideId(id);
    } finally {
      _$PilotFindingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPolyPoints(List<LatLng> points) {
    final _$actionInfo = _$PilotFindingScreenModelBaseActionController
        .startAction(name: 'PilotFindingScreenModelBase.setPolyPoints');
    try {
      return super.setPolyPoints(points);
    } finally {
      _$PilotFindingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsLoading(bool value) {
    final _$actionInfo = _$PilotFindingScreenModelBaseActionController
        .startAction(name: 'PilotFindingScreenModelBase.setIsLoading');
    try {
      return super.setIsLoading(value);
    } finally {
      _$PilotFindingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPrice(String value) {
    final _$actionInfo = _$PilotFindingScreenModelBaseActionController
        .startAction(name: 'PilotFindingScreenModelBase.setPrice');
    try {
      return super.setPrice(value);
    } finally {
      _$PilotFindingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsFareLoading(bool value) {
    final _$actionInfo = _$PilotFindingScreenModelBaseActionController
        .startAction(name: 'PilotFindingScreenModelBase.setIsFareLoading');
    try {
      return super.setIsFareLoading(value);
    } finally {
      _$PilotFindingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPilots(List<PilotRequestBO> value) {
    final _$actionInfo = _$PilotFindingScreenModelBaseActionController
        .startAction(name: 'PilotFindingScreenModelBase.setPilots');
    try {
      return super.setPilots(value);
    } finally {
      _$PilotFindingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
sourceLocation: ${sourceLocation},
destinationLocation: ${destinationLocation},
currentRide: ${currentRide},
rideId: ${rideId},
polypoints: ${polypoints},
isLoading: ${isLoading},
price: ${price},
isFareLoading: ${isFareLoading},
pilots: ${pilots}
    ''';
  }
}
