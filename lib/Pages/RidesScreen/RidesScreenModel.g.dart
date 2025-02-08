// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RidesScreenModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RidesScreenModel on RidesScreenModelBase, Store {
  late final _$ridesAtom =
      Atom(name: 'RidesScreenModelBase.rides', context: context);

  @override
  List<RideBO> get rides {
    _$ridesAtom.reportRead();
    return super.rides;
  }

  @override
  set rides(List<RideBO> value) {
    _$ridesAtom.reportWrite(value, super.rides, () {
      super.rides = value;
    });
  }

  late final _$filteredRidesAtom =
      Atom(name: 'RidesScreenModelBase.filteredRides', context: context);

  @override
  List<RideBO> get filteredRides {
    _$filteredRidesAtom.reportRead();
    return super.filteredRides;
  }

  @override
  set filteredRides(List<RideBO> value) {
    _$filteredRidesAtom.reportWrite(value, super.filteredRides, () {
      super.filteredRides = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'RidesScreenModelBase.isLoading', context: context);

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

  late final _$dateAtom =
      Atom(name: 'RidesScreenModelBase.date', context: context);

  @override
  DateTime get date {
    _$dateAtom.reportRead();
    return super.date;
  }

  bool _dateIsInitialized = false;

  @override
  set date(DateTime value) {
    _$dateAtom.reportWrite(value, _dateIsInitialized ? super.date : null, () {
      super.date = value;
      _dateIsInitialized = true;
    });
  }

  late final _$completedRidesAtom =
      Atom(name: 'RidesScreenModelBase.completedRides', context: context);

  @override
  List<RideBO> get completedRides {
    _$completedRidesAtom.reportRead();
    return super.completedRides;
  }

  @override
  set completedRides(List<RideBO> value) {
    _$completedRidesAtom.reportWrite(value, super.completedRides, () {
      super.completedRides = value;
    });
  }

  late final _$scheduledRidesAtom =
      Atom(name: 'RidesScreenModelBase.scheduledRides', context: context);

  @override
  List<RideBO> get scheduledRides {
    _$scheduledRidesAtom.reportRead();
    return super.scheduledRides;
  }

  @override
  set scheduledRides(List<RideBO> value) {
    _$scheduledRidesAtom.reportWrite(value, super.scheduledRides, () {
      super.scheduledRides = value;
    });
  }

  late final _$canceledRidesAtom =
      Atom(name: 'RidesScreenModelBase.canceledRides', context: context);

  @override
  List<RideBO> get canceledRides {
    _$canceledRidesAtom.reportRead();
    return super.canceledRides;
  }

  @override
  set canceledRides(List<RideBO> value) {
    _$canceledRidesAtom.reportWrite(value, super.canceledRides, () {
      super.canceledRides = value;
    });
  }

  late final _$scourceLocationAtom =
      Atom(name: 'RidesScreenModelBase.scourceLocation', context: context);

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

  late final _$RidesScreenModelBaseActionController =
      ActionController(name: 'RidesScreenModelBase', context: context);

  @override
  void setRides(List<RideBO> rides) {
    final _$actionInfo = _$RidesScreenModelBaseActionController.startAction(
        name: 'RidesScreenModelBase.setRides');
    try {
      return super.setRides(rides);
    } finally {
      _$RidesScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFilteredRides(List<RideBO> rides) {
    final _$actionInfo = _$RidesScreenModelBaseActionController.startAction(
        name: 'RidesScreenModelBase.setFilteredRides');
    try {
      return super.setFilteredRides(rides);
    } finally {
      _$RidesScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsLoading(bool isLoading) {
    final _$actionInfo = _$RidesScreenModelBaseActionController.startAction(
        name: 'RidesScreenModelBase.setIsLoading');
    try {
      return super.setIsLoading(isLoading);
    } finally {
      _$RidesScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDate(DateTime date) {
    final _$actionInfo = _$RidesScreenModelBaseActionController.startAction(
        name: 'RidesScreenModelBase.setDate');
    try {
      return super.setDate(date);
    } finally {
      _$RidesScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCompletedRides(List<RideBO> completedRides) {
    final _$actionInfo = _$RidesScreenModelBaseActionController.startAction(
        name: 'RidesScreenModelBase.setCompletedRides');
    try {
      return super.setCompletedRides(completedRides);
    } finally {
      _$RidesScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setScheduledRides(List<RideBO> scheduledRides) {
    final _$actionInfo = _$RidesScreenModelBaseActionController.startAction(
        name: 'RidesScreenModelBase.setScheduledRides');
    try {
      return super.setScheduledRides(scheduledRides);
    } finally {
      _$RidesScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCanceledRides(List<RideBO> canceledRides) {
    final _$actionInfo = _$RidesScreenModelBaseActionController.startAction(
        name: 'RidesScreenModelBase.setCanceledRides');
    try {
      return super.setCanceledRides(canceledRides);
    } finally {
      _$RidesScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSourceLocation(LatLng location) {
    final _$actionInfo = _$RidesScreenModelBaseActionController.startAction(
        name: 'RidesScreenModelBase.setSourceLocation');
    try {
      return super.setSourceLocation(location);
    } finally {
      _$RidesScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
rides: ${rides},
filteredRides: ${filteredRides},
isLoading: ${isLoading},
date: ${date},
completedRides: ${completedRides},
scheduledRides: ${scheduledRides},
canceledRides: ${canceledRides},
scourceLocation: ${scourceLocation}
    ''';
  }
}
