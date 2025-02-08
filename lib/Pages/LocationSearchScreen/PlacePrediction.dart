import 'package:flutter/foundation.dart';

@immutable
class PlacePrediction {
  final String placeId;
  final String mainText;
  final String secondaryText;

  const PlacePrediction({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    final structuredFormatting =
        json['structured_formatting'] as Map<String, dynamic>;

    return PlacePrediction(
      placeId: json['place_id'] as String,
      mainText: structuredFormatting['main_text'] as String,
      secondaryText: structuredFormatting['secondary_text'] as String? ?? '',
    );
  }
}
