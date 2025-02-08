class PilotRequestBO {
  String pilotName;
  String pilotImageUrl;
  String pilotMobileNumber;
  String pilotRatings;
  String vehicle;
  String fare;
  int timer;
  PilotRequestBO(
      {required this.pilotName,
      required this.pilotImageUrl,
      required this.pilotMobileNumber,
      required this.pilotRatings,
      required this.vehicle,
      required this.fare,
      this.timer = 30});
}
