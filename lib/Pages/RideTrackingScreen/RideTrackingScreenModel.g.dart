// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RideTrackingScreenModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RideTrackingScreenModel on RideTrackingScreenModelBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'RideTrackingScreenModelBase.isLoading', context: context);

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
      name: 'RideTrackingScreenModelBase.currentLocation', context: context);

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
      name: 'RideTrackingScreenModelBase.currentRideRequest', context: context);

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

  late final _$polypointsAtom =
      Atom(name: 'RideTrackingScreenModelBase.polypoints', context: context);

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

  late final _$isArrivedToPickupLocationAtom = Atom(
      name: 'RideTrackingScreenModelBase.isArrivedToPickupLocation',
      context: context);

  @override
  bool get isArrivedToPickupLocation {
    _$isArrivedToPickupLocationAtom.reportRead();
    return super.isArrivedToPickupLocation;
  }

  @override
  set isArrivedToPickupLocation(bool value) {
    _$isArrivedToPickupLocationAtom
        .reportWrite(value, super.isArrivedToPickupLocation, () {
      super.isArrivedToPickupLocation = value;
    });
  }

  late final _$isArrivedToDropLocationAtom = Atom(
      name: 'RideTrackingScreenModelBase.isArrivedToDropLocation',
      context: context);

  @override
  bool get isArrivedToDropLocation {
    _$isArrivedToDropLocationAtom.reportRead();
    return super.isArrivedToDropLocation;
  }

  @override
  set isArrivedToDropLocation(bool value) {
    _$isArrivedToDropLocationAtom
        .reportWrite(value, super.isArrivedToDropLocation, () {
      super.isArrivedToDropLocation = value;
    });
  }

  late final _$currentDirectionAtom = Atom(
      name: 'RideTrackingScreenModelBase.currentDirection', context: context);

  @override
  double get currentDirection {
    _$currentDirectionAtom.reportRead();
    return super.currentDirection;
  }

  @override
  set currentDirection(double value) {
    _$currentDirectionAtom.reportWrite(value, super.currentDirection, () {
      super.currentDirection = value;
    });
  }

  late final _$rideStatusAtom =
      Atom(name: 'RideTrackingScreenModelBase.rideStatus', context: context);

  @override
  String get rideStatus {
    _$rideStatusAtom.reportRead();
    return super.rideStatus;
  }

  @override
  set rideStatus(String value) {
    _$rideStatusAtom.reportWrite(value, super.rideStatus, () {
      super.rideStatus = value;
    });
  }

  late final _$durationAtom =
      Atom(name: 'RideTrackingScreenModelBase.duration', context: context);

  @override
  double get duration {
    _$durationAtom.reportRead();
    return super.duration;
  }

  @override
  set duration(double value) {
    _$durationAtom.reportWrite(value, super.duration, () {
      super.duration = value;
    });
  }

  late final _$vehicleDetailsAtom = Atom(
      name: 'RideTrackingScreenModelBase.vehicleDetails', context: context);

  @override
  VehicleDetailsBO get vehicleDetails {
    _$vehicleDetailsAtom.reportRead();
    return super.vehicleDetails;
  }

  bool _vehicleDetailsIsInitialized = false;

  @override
  set vehicleDetails(VehicleDetailsBO value) {
    _$vehicleDetailsAtom.reportWrite(
        value, _vehicleDetailsIsInitialized ? super.vehicleDetails : null, () {
      super.vehicleDetails = value;
      _vehicleDetailsIsInitialized = true;
    });
  }

  late final _$vehicleInfoAtom =
      Atom(name: 'RideTrackingScreenModelBase.vehicleInfo', context: context);

  @override
  VehicleInfoBO get vehicleInfo {
    _$vehicleInfoAtom.reportRead();
    return super.vehicleInfo;
  }

  bool _vehicleInfoIsInitialized = false;

  @override
  set vehicleInfo(VehicleInfoBO value) {
    _$vehicleInfoAtom.reportWrite(
        value, _vehicleInfoIsInitialized ? super.vehicleInfo : null, () {
      super.vehicleInfo = value;
      _vehicleInfoIsInitialized = true;
    });
  }

  late final _$pilotLocationAtom =
      Atom(name: 'RideTrackingScreenModelBase.pilotLocation', context: context);

  @override
  LatLng get pilotLocation {
    _$pilotLocationAtom.reportRead();
    return super.pilotLocation;
  }

  @override
  set pilotLocation(LatLng value) {
    _$pilotLocationAtom.reportWrite(value, super.pilotLocation, () {
      super.pilotLocation = value;
    });
  }

  late final _$RideTrackingScreenModelBaseActionController =
      ActionController(name: 'RideTrackingScreenModelBase', context: context);

  @override
  void setIsLoading(bool isLoading) {
    final _$actionInfo = _$RideTrackingScreenModelBaseActionController
        .startAction(name: 'RideTrackingScreenModelBase.setIsLoading');
    try {
      return super.setIsLoading(isLoading);
    } finally {
      _$RideTrackingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentLocation(LatLng location) {
    final _$actionInfo = _$RideTrackingScreenModelBaseActionController
        .startAction(name: 'RideTrackingScreenModelBase.setCurrentLocation');
    try {
      return super.setCurrentLocation(location);
    } finally {
      _$RideTrackingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentRideRequest(RideBO rideBO) {
    final _$actionInfo = _$RideTrackingScreenModelBaseActionController
        .startAction(name: 'RideTrackingScreenModelBase.setCurrentRideRequest');
    try {
      return super.setCurrentRideRequest(rideBO);
    } finally {
      _$RideTrackingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPolyPoints(List<LatLng> points) {
    final _$actionInfo = _$RideTrackingScreenModelBaseActionController
        .startAction(name: 'RideTrackingScreenModelBase.setPolyPoints');
    try {
      return super.setPolyPoints(points);
    } finally {
      _$RideTrackingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsArrivedToPickupLocation(bool isArrivedToPickupLocation) {
    final _$actionInfo =
        _$RideTrackingScreenModelBaseActionController.startAction(
            name: 'RideTrackingScreenModelBase.setIsArrivedToPickupLocation');
    try {
      return super.setIsArrivedToPickupLocation(isArrivedToPickupLocation);
    } finally {
      _$RideTrackingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsArrivedToDropLocation(bool isArrivedToDropLocation) {
    final _$actionInfo =
        _$RideTrackingScreenModelBaseActionController.startAction(
            name: 'RideTrackingScreenModelBase.setIsArrivedToDropLocation');
    try {
      return super.setIsArrivedToDropLocation(isArrivedToDropLocation);
    } finally {
      _$RideTrackingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentDirection(double value) {
    final _$actionInfo = _$RideTrackingScreenModelBaseActionController
        .startAction(name: 'RideTrackingScreenModelBase.setCurrentDirection');
    try {
      return super.setCurrentDirection(value);
    } finally {
      _$RideTrackingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRideStatus(String status) {
    final _$actionInfo = _$RideTrackingScreenModelBaseActionController
        .startAction(name: 'RideTrackingScreenModelBase.setRideStatus');
    try {
      return super.setRideStatus(status);
    } finally {
      _$RideTrackingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDuration(double value) {
    final _$actionInfo = _$RideTrackingScreenModelBaseActionController
        .startAction(name: 'RideTrackingScreenModelBase.setDuration');
    try {
      return super.setDuration(value);
    } finally {
      _$RideTrackingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setVehicleDetails(VehicleDetailsBO vehicleDetails) {
    final _$actionInfo = _$RideTrackingScreenModelBaseActionController
        .startAction(name: 'RideTrackingScreenModelBase.setVehicleDetails');
    try {
      return super.setVehicleDetails(vehicleDetails);
    } finally {
      _$RideTrackingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setVehicleInfo(VehicleInfoBO vehicleInfo) {
    final _$actionInfo = _$RideTrackingScreenModelBaseActionController
        .startAction(name: 'RideTrackingScreenModelBase.setVehicleInfo');
    try {
      return super.setVehicleInfo(vehicleInfo);
    } finally {
      _$RideTrackingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPilotLocation(LatLng location) {
    final _$actionInfo = _$RideTrackingScreenModelBaseActionController
        .startAction(name: 'RideTrackingScreenModelBase.setPilotLocation');
    try {
      return super.setPilotLocation(location);
    } finally {
      _$RideTrackingScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
currentLocation: ${currentLocation},
currentRideRequest: ${currentRideRequest},
polypoints: ${polypoints},
isArrivedToPickupLocation: ${isArrivedToPickupLocation},
isArrivedToDropLocation: ${isArrivedToDropLocation},
currentDirection: ${currentDirection},
rideStatus: ${rideStatus},
duration: ${duration},
vehicleDetails: ${vehicleDetails},
vehicleInfo: ${vehicleInfo},
pilotLocation: ${pilotLocation}
    ''';
  }
}
