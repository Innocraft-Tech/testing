// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocationSearchScreenModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LocationSearchScreenModel on LocationSearchScreenModelBase, Store {
  late final _$scourceLocationAtom = Atom(
      name: 'LocationSearchScreenModelBase.scourceLocation', context: context);

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
      name: 'LocationSearchScreenModelBase.destinationLocation',
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
      Atom(name: 'LocationSearchScreenModelBase.polypoints', context: context);

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

  late final _$selectedDateAtom = Atom(
      name: 'LocationSearchScreenModelBase.selectedDate', context: context);

  @override
  DateTime get selectedDate {
    _$selectedDateAtom.reportRead();
    return super.selectedDate;
  }

  @override
  set selectedDate(DateTime value) {
    _$selectedDateAtom.reportWrite(value, super.selectedDate, () {
      super.selectedDate = value;
    });
  }

  late final _$selectedTimeAtom = Atom(
      name: 'LocationSearchScreenModelBase.selectedTime', context: context);

  @override
  String get selectedTime {
    _$selectedTimeAtom.reportRead();
    return super.selectedTime;
  }

  @override
  set selectedTime(String value) {
    _$selectedTimeAtom.reportWrite(value, super.selectedTime, () {
      super.selectedTime = value;
    });
  }

  late final _$selectedDateTextAtom = Atom(
      name: 'LocationSearchScreenModelBase.selectedDateText', context: context);

  @override
  String get selectedDateText {
    _$selectedDateTextAtom.reportRead();
    return super.selectedDateText;
  }

  @override
  set selectedDateText(String value) {
    _$selectedDateTextAtom.reportWrite(value, super.selectedDateText, () {
      super.selectedDateText = value;
    });
  }

  late final _$numberOfPassangersAtom = Atom(
      name: 'LocationSearchScreenModelBase.numberOfPassangers',
      context: context);

  @override
  int get numberOfPassangers {
    _$numberOfPassangersAtom.reportRead();
    return super.numberOfPassangers;
  }

  @override
  set numberOfPassangers(int value) {
    _$numberOfPassangersAtom.reportWrite(value, super.numberOfPassangers, () {
      super.numberOfPassangers = value;
    });
  }

  late final _$commentsAtom =
      Atom(name: 'LocationSearchScreenModelBase.comments', context: context);

  @override
  String get comments {
    _$commentsAtom.reportRead();
    return super.comments;
  }

  @override
  set comments(String value) {
    _$commentsAtom.reportWrite(value, super.comments, () {
      super.comments = value;
    });
  }

  late final _$isOutStationAtom = Atom(
      name: 'LocationSearchScreenModelBase.isOutStation', context: context);

  @override
  bool get isOutStation {
    _$isOutStationAtom.reportRead();
    return super.isOutStation;
  }

  @override
  set isOutStation(bool value) {
    _$isOutStationAtom.reportWrite(value, super.isOutStation, () {
      super.isOutStation = value;
    });
  }

  late final _$isTripDateSelectedAtom = Atom(
      name: 'LocationSearchScreenModelBase.isTripDateSelected',
      context: context);

  @override
  bool get isTripDateSelected {
    _$isTripDateSelectedAtom.reportRead();
    return super.isTripDateSelected;
  }

  @override
  set isTripDateSelected(bool value) {
    _$isTripDateSelectedAtom.reportWrite(value, super.isTripDateSelected, () {
      super.isTripDateSelected = value;
    });
  }

  late final _$LocationSearchScreenModelBaseActionController =
      ActionController(name: 'LocationSearchScreenModelBase', context: context);

  @override
  void setSourceLocation(LatLng location) {
    final _$actionInfo = _$LocationSearchScreenModelBaseActionController
        .startAction(name: 'LocationSearchScreenModelBase.setSourceLocation');
    try {
      return super.setSourceLocation(location);
    } finally {
      _$LocationSearchScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDestinationLocation(LatLng location) {
    final _$actionInfo =
        _$LocationSearchScreenModelBaseActionController.startAction(
            name: 'LocationSearchScreenModelBase.setDestinationLocation');
    try {
      return super.setDestinationLocation(location);
    } finally {
      _$LocationSearchScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPolyPoints(List<LatLng> points) {
    final _$actionInfo = _$LocationSearchScreenModelBaseActionController
        .startAction(name: 'LocationSearchScreenModelBase.setPolyPoints');
    try {
      return super.setPolyPoints(points);
    } finally {
      _$LocationSearchScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedDate(DateTime date) {
    final _$actionInfo = _$LocationSearchScreenModelBaseActionController
        .startAction(name: 'LocationSearchScreenModelBase.setSelectedDate');
    try {
      return super.setSelectedDate(date);
    } finally {
      _$LocationSearchScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedTime(String time) {
    final _$actionInfo = _$LocationSearchScreenModelBaseActionController
        .startAction(name: 'LocationSearchScreenModelBase.setSelectedTime');
    try {
      return super.setSelectedTime(time);
    } finally {
      _$LocationSearchScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedDateText(String date) {
    final _$actionInfo = _$LocationSearchScreenModelBaseActionController
        .startAction(name: 'LocationSearchScreenModelBase.setSelectedDateText');
    try {
      return super.setSelectedDateText(date);
    } finally {
      _$LocationSearchScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNumbserOfPassangers(int pasangers) {
    final _$actionInfo =
        _$LocationSearchScreenModelBaseActionController.startAction(
            name: 'LocationSearchScreenModelBase.setNumbserOfPassangers');
    try {
      return super.setNumbserOfPassangers(pasangers);
    } finally {
      _$LocationSearchScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setComments(String comment) {
    final _$actionInfo = _$LocationSearchScreenModelBaseActionController
        .startAction(name: 'LocationSearchScreenModelBase.setComments');
    try {
      return super.setComments(comment);
    } finally {
      _$LocationSearchScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsOutStation(bool isOutStation) {
    final _$actionInfo = _$LocationSearchScreenModelBaseActionController
        .startAction(name: 'LocationSearchScreenModelBase.setIsOutStation');
    try {
      return super.setIsOutStation(isOutStation);
    } finally {
      _$LocationSearchScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsTripDateSelected(bool dripDate) {
    final _$actionInfo =
        _$LocationSearchScreenModelBaseActionController.startAction(
            name: 'LocationSearchScreenModelBase.setIsTripDateSelected');
    try {
      return super.setIsTripDateSelected(dripDate);
    } finally {
      _$LocationSearchScreenModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
scourceLocation: ${scourceLocation},
destinationLocation: ${destinationLocation},
polypoints: ${polypoints},
selectedDate: ${selectedDate},
selectedTime: ${selectedTime},
selectedDateText: ${selectedDateText},
numberOfPassangers: ${numberOfPassangers},
comments: ${comments},
isOutStation: ${isOutStation},
isTripDateSelected: ${isTripDateSelected}
    ''';
  }
}
