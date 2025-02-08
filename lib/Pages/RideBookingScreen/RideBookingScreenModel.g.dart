// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RideBookingScreenModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RideBookingScreenModel on _RideBookingScreenModelBase, Store {
  late final _$scourceLocationAtom = Atom(
      name: '_RideBookingScreenModelBase.scourceLocation', context: context);

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

  late final _$destinationLocationAtom = Atom(
      name: '_RideBookingScreenModelBase.destinationLocation',
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

  late final _$polypointsAtom =
      Atom(name: '_RideBookingScreenModelBase.polypoints', context: context);

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

  late final _$isLocationEnabledAtom = Atom(
      name: '_RideBookingScreenModelBase.isLocationEnabled', context: context);

  @override
  bool get isLocationEnabled {
    _$isLocationEnabledAtom.reportRead();
    return super.isLocationEnabled;
  }

  @override
  set isLocationEnabled(bool value) {
    _$isLocationEnabledAtom.reportWrite(value, super.isLocationEnabled, () {
      super.isLocationEnabled = value;
    });
  }

  late final _$capitansAreLiveAtom = Atom(
      name: '_RideBookingScreenModelBase.capitansAreLive', context: context);

  @override
  ObservableList<LatLng> get capitansAreLive {
    _$capitansAreLiveAtom.reportRead();
    return super.capitansAreLive;
  }

  @override
  set capitansAreLive(ObservableList<LatLng> value) {
    _$capitansAreLiveAtom.reportWrite(value, super.capitansAreLive, () {
      super.capitansAreLive = value;
    });
  }

  late final _$distanceAtom =
      Atom(name: '_RideBookingScreenModelBase.distance', context: context);

  @override
  double get distance {
    _$distanceAtom.reportRead();
    return super.distance;
  }

  @override
  set distance(double value) {
    _$distanceAtom.reportWrite(value, super.distance, () {
      super.distance = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_RideBookingScreenModelBase.isLoading', context: context);

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

  late final _$isBottomIsLoadingAtom = Atom(
      name: '_RideBookingScreenModelBase.isBottomIsLoading', context: context);

  @override
  bool get isBottomIsLoading {
    _$isBottomIsLoadingAtom.reportRead();
    return super.isBottomIsLoading;
  }

  @override
  set isBottomIsLoading(bool value) {
    _$isBottomIsLoadingAtom.reportWrite(value, super.isBottomIsLoading, () {
      super.isBottomIsLoading = value;
    });
  }

  late final _$vehicleListAtom =
      Atom(name: '_RideBookingScreenModelBase.vehicleList', context: context);

  @override
  List<VechileBO> get vehicleList {
    _$vehicleListAtom.reportRead();
    return super.vehicleList;
  }

  @override
  set vehicleList(List<VechileBO> value) {
    _$vehicleListAtom.reportWrite(value, super.vehicleList, () {
      super.vehicleList = value;
    });
  }

  late final _$selectedVehicleIndexAtom = Atom(
      name: '_RideBookingScreenModelBase.selectedVehicleIndex',
      context: context);

  @override
  int get selectedVehicleIndex {
    _$selectedVehicleIndexAtom.reportRead();
    return super.selectedVehicleIndex;
  }

  @override
  set selectedVehicleIndex(int value) {
    _$selectedVehicleIndexAtom.reportWrite(value, super.selectedVehicleIndex,
        () {
      super.selectedVehicleIndex = value;
    });
  }

  late final _$isOwnFareAtom =
      Atom(name: '_RideBookingScreenModelBase.isOwnFare', context: context);

  @override
  bool get isOwnFare {
    _$isOwnFareAtom.reportRead();
    return super.isOwnFare;
  }

  @override
  set isOwnFare(bool value) {
    _$isOwnFareAtom.reportWrite(value, super.isOwnFare, () {
      super.isOwnFare = value;
    });
  }

  late final _$rideIdAtom =
      Atom(name: '_RideBookingScreenModelBase.rideId', context: context);

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

  late final _$fromLocationAtom =
      Atom(name: '_RideBookingScreenModelBase.fromLocation', context: context);

  @override
  String get fromLocation {
    _$fromLocationAtom.reportRead();
    return super.fromLocation;
  }

  @override
  set fromLocation(String value) {
    _$fromLocationAtom.reportWrite(value, super.fromLocation, () {
      super.fromLocation = value;
    });
  }

  late final _$toLocationAtom =
      Atom(name: '_RideBookingScreenModelBase.toLocation', context: context);

  @override
  String get toLocation {
    _$toLocationAtom.reportRead();
    return super.toLocation;
  }

  @override
  set toLocation(String value) {
    _$toLocationAtom.reportWrite(value, super.toLocation, () {
      super.toLocation = value;
    });
  }

  late final _$currentRideAtom =
      Atom(name: '_RideBookingScreenModelBase.currentRide', context: context);

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

  late final _$_RideBookingScreenModelBaseActionController =
      ActionController(name: '_RideBookingScreenModelBase', context: context);

  @override
  void setSourceLocation(LatLng location) {
    final _$actionInfo = _$_RideBookingScreenModelBaseActionController
        .startAction(name: '_RideBookingScreenModelBase.setSourceLocation');
    try {
      return super.setSourceLocation(location);
    } finally {
      _$_RideBookingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDestinationLocation(LatLng location) {
    final _$actionInfo =
        _$_RideBookingScreenModelBaseActionController.startAction(
            name: '_RideBookingScreenModelBase.setDestinationLocation');
    try {
      return super.setDestinationLocation(location);
    } finally {
      _$_RideBookingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPolyPoints(List<LatLng> points) {
    final _$actionInfo = _$_RideBookingScreenModelBaseActionController
        .startAction(name: '_RideBookingScreenModelBase.setPolyPoints');
    try {
      return super.setPolyPoints(points);
    } finally {
      _$_RideBookingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLocationEnabled(bool value) {
    final _$actionInfo = _$_RideBookingScreenModelBaseActionController
        .startAction(name: '_RideBookingScreenModelBase.setLocationEnabled');
    try {
      return super.setLocationEnabled(value);
    } finally {
      _$_RideBookingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addCapitanLocation(LatLng location) {
    final _$actionInfo = _$_RideBookingScreenModelBaseActionController
        .startAction(name: '_RideBookingScreenModelBase.addCapitanLocation');
    try {
      return super.addCapitanLocation(location);
    } finally {
      _$_RideBookingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearCapitanLocations() {
    final _$actionInfo = _$_RideBookingScreenModelBaseActionController
        .startAction(name: '_RideBookingScreenModelBase.clearCapitanLocations');
    try {
      return super.clearCapitanLocations();
    } finally {
      _$_RideBookingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDistance(double value) {
    final _$actionInfo = _$_RideBookingScreenModelBaseActionController
        .startAction(name: '_RideBookingScreenModelBase.setDistance');
    try {
      return super.setDistance(value);
    } finally {
      _$_RideBookingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsLoading(bool value) {
    final _$actionInfo = _$_RideBookingScreenModelBaseActionController
        .startAction(name: '_RideBookingScreenModelBase.setIsLoading');
    try {
      return super.setIsLoading(value);
    } finally {
      _$_RideBookingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsBottomLoading(bool value) {
    final _$actionInfo = _$_RideBookingScreenModelBaseActionController
        .startAction(name: '_RideBookingScreenModelBase.setIsBottomLoading');
    try {
      return super.setIsBottomLoading(value);
    } finally {
      _$_RideBookingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setVehicleList(List<VechileBO> value) {
    final _$actionInfo = _$_RideBookingScreenModelBaseActionController
        .startAction(name: '_RideBookingScreenModelBase.setVehicleList');
    try {
      return super.setVehicleList(value);
    } finally {
      _$_RideBookingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedVehicleIndex(int value) {
    final _$actionInfo =
        _$_RideBookingScreenModelBaseActionController.startAction(
            name: '_RideBookingScreenModelBase.setSelectedVehicleIndex');
    try {
      return super.setSelectedVehicleIndex(value);
    } finally {
      _$_RideBookingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsOwnFare(bool value) {
    final _$actionInfo = _$_RideBookingScreenModelBaseActionController
        .startAction(name: '_RideBookingScreenModelBase.setIsOwnFare');
    try {
      return super.setIsOwnFare(value);
    } finally {
      _$_RideBookingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRideId(String value) {
    final _$actionInfo = _$_RideBookingScreenModelBaseActionController
        .startAction(name: '_RideBookingScreenModelBase.setRideId');
    try {
      return super.setRideId(value);
    } finally {
      _$_RideBookingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFromLocation(String value) {
    final _$actionInfo = _$_RideBookingScreenModelBaseActionController
        .startAction(name: '_RideBookingScreenModelBase.setFromLocation');
    try {
      return super.setFromLocation(value);
    } finally {
      _$_RideBookingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setToLocation(String value) {
    final _$actionInfo = _$_RideBookingScreenModelBaseActionController
        .startAction(name: '_RideBookingScreenModelBase.setToLocation');
    try {
      return super.setToLocation(value);
    } finally {
      _$_RideBookingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentRide(RideBO value) {
    final _$actionInfo = _$_RideBookingScreenModelBaseActionController
        .startAction(name: '_RideBookingScreenModelBase.setCurrentRide');
    try {
      return super.setCurrentRide(value);
    } finally {
      _$_RideBookingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
scourceLocation: ${scourceLocation},
destinationLocation: ${destinationLocation},
polypoints: ${polypoints},
isLocationEnabled: ${isLocationEnabled},
capitansAreLive: ${capitansAreLive},
distance: ${distance},
isLoading: ${isLoading},
isBottomIsLoading: ${isBottomIsLoading},
vehicleList: ${vehicleList},
selectedVehicleIndex: ${selectedVehicleIndex},
isOwnFare: ${isOwnFare},
rideId: ${rideId},
fromLocation: ${fromLocation},
toLocation: ${toLocation},
currentRide: ${currentRide}
    ''';
  }
}
