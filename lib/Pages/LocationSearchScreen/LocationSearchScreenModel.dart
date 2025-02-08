import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/Mixins/PopUpMixin.dart';
part 'LocationSearchScreenModel.g.dart';

class LocationSearchScreenModel = LocationSearchScreenModelBase
    with NavigationMixin, PopUpMixin;

abstract class LocationSearchScreenModelBase with Store {
  @observable
  late LatLng scourceLocation = LatLng(0, 0);

  @action
  void setSourceLocation(LatLng location) {
    scourceLocation = location;
  }

  @observable
  late LatLng destinationLocation = LatLng(0, 0);

  @action
  void setDestinationLocation(LatLng location) {
    destinationLocation = location;
  }

  @observable
  List<LatLng> polypoints = [];

  @action
  void setPolyPoints(List<LatLng> points) {
    polypoints = points;
  }

  @observable
  DateTime selectedDate = DateTime.now();

  @action
  void setSelectedDate(DateTime date) {
    selectedDate = date;
  }

  @observable
  String selectedTime = "00:00";

  @action
  void setSelectedTime(String time) {
    selectedTime = time;
  }

  @observable
  String selectedDateText = "Now";

  @action
  void setSelectedDateText(String date) {
    selectedDateText = date;
  }

  @observable
  int numberOfPassangers = 1;
  @action
  void setNumbserOfPassangers(int pasangers) {
    numberOfPassangers = pasangers;
  }

  @observable
  String comments = "";
  @action
  void setComments(String comment) {
    comments = comment;
  }

  @observable
  bool isOutStation = false;
  @action
  void setIsOutStation(bool isOutStation) {
    this.isOutStation = isOutStation;
  }

  @observable
  bool isTripDateSelected = false;
  @action
  void setIsTripDateSelected(bool dripDate) {
    isTripDateSelected = dripDate;
  }
}
