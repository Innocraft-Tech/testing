// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HomeScreenModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeScreenModel on _HomeScreenModelBase, Store {
  late final _$scourceLocationAtom =
      Atom(name: '_HomeScreenModelBase.scourceLocation', context: context);

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

  late final _$isSourceLocationSetAtom =
      Atom(name: '_HomeScreenModelBase.isSourceLocationSet', context: context);

  @override
  bool get isSourceLocationSet {
    _$isSourceLocationSetAtom.reportRead();
    return super.isSourceLocationSet;
  }

  @override
  set isSourceLocationSet(bool value) {
    _$isSourceLocationSetAtom.reportWrite(value, super.isSourceLocationSet, () {
      super.isSourceLocationSet = value;
    });
  }

  late final _$destinationLocationAtom =
      Atom(name: '_HomeScreenModelBase.destinationLocation', context: context);

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
      Atom(name: '_HomeScreenModelBase.polypoints', context: context);

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

  late final _$isLocationEnabledAtom =
      Atom(name: '_HomeScreenModelBase.isLocationEnabled', context: context);

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

  late final _$capitansAreLiveAtom =
      Atom(name: '_HomeScreenModelBase.capitansAreLive', context: context);

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
      Atom(name: '_HomeScreenModelBase.distance', context: context);

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
      Atom(name: '_HomeScreenModelBase.isLoading', context: context);

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

  late final _$isBottomIsLoadingAtom =
      Atom(name: '_HomeScreenModelBase.isBottomIsLoading', context: context);

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

  late final _$_HomeScreenModelBaseActionController =
      ActionController(name: '_HomeScreenModelBase', context: context);

  @override
  void setSourceLocation(LatLng location) {
    final _$actionInfo = _$_HomeScreenModelBaseActionController.startAction(
        name: '_HomeScreenModelBase.setSourceLocation');
    try {
      return super.setSourceLocation(location);
    } finally {
      _$_HomeScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsSourceLocationSet(bool value) {
    final _$actionInfo = _$_HomeScreenModelBaseActionController.startAction(
        name: '_HomeScreenModelBase.setIsSourceLocationSet');
    try {
      return super.setIsSourceLocationSet(value);
    } finally {
      _$_HomeScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDestinationLocation(LatLng location) {
    final _$actionInfo = _$_HomeScreenModelBaseActionController.startAction(
        name: '_HomeScreenModelBase.setDestinationLocation');
    try {
      return super.setDestinationLocation(location);
    } finally {
      _$_HomeScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPolyPoints(List<LatLng> points) {
    final _$actionInfo = _$_HomeScreenModelBaseActionController.startAction(
        name: '_HomeScreenModelBase.setPolyPoints');
    try {
      return super.setPolyPoints(points);
    } finally {
      _$_HomeScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLocationEnabled(bool value) {
    final _$actionInfo = _$_HomeScreenModelBaseActionController.startAction(
        name: '_HomeScreenModelBase.setLocationEnabled');
    try {
      return super.setLocationEnabled(value);
    } finally {
      _$_HomeScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addCapitanLocation(LatLng location) {
    final _$actionInfo = _$_HomeScreenModelBaseActionController.startAction(
        name: '_HomeScreenModelBase.addCapitanLocation');
    try {
      return super.addCapitanLocation(location);
    } finally {
      _$_HomeScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearCapitanLocations() {
    final _$actionInfo = _$_HomeScreenModelBaseActionController.startAction(
        name: '_HomeScreenModelBase.clearCapitanLocations');
    try {
      return super.clearCapitanLocations();
    } finally {
      _$_HomeScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDistance(double value) {
    final _$actionInfo = _$_HomeScreenModelBaseActionController.startAction(
        name: '_HomeScreenModelBase.setDistance');
    try {
      return super.setDistance(value);
    } finally {
      _$_HomeScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsLoading(bool value) {
    final _$actionInfo = _$_HomeScreenModelBaseActionController.startAction(
        name: '_HomeScreenModelBase.setIsLoading');
    try {
      return super.setIsLoading(value);
    } finally {
      _$_HomeScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsBottomLoading(bool value) {
    final _$actionInfo = _$_HomeScreenModelBaseActionController.startAction(
        name: '_HomeScreenModelBase.setIsBottomLoading');
    try {
      return super.setIsBottomLoading(value);
    } finally {
      _$_HomeScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
scourceLocation: ${scourceLocation},
isSourceLocationSet: ${isSourceLocationSet},
destinationLocation: ${destinationLocation},
polypoints: ${polypoints},
isLocationEnabled: ${isLocationEnabled},
capitansAreLive: ${capitansAreLive},
distance: ${distance},
isLoading: ${isLoading},
isBottomIsLoading: ${isBottomIsLoading}
    ''';
  }
}
