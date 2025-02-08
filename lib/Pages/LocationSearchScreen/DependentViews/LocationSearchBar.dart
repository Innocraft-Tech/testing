import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class LocationSearchBar extends StatelessWidget {
  final String hint;
  final Widget prefixIcon;
  final Function(String) onLocationSelected;

  const LocationSearchBar({
    super.key,
    required this.hint,
    required this.prefixIcon,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: TextEditingController(),
        googleAPIKey: "YOUR_GOOGLE_API_KEY", // Replace with your API key
        inputDecoration: InputDecoration(
          hintText: hint,
          prefixIcon: prefixIcon,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        debounceTime: 800,
        countries: const ["in"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          onLocationSelected(prediction.description ?? '');
        },
        itemClick: (Prediction prediction) {
          onLocationSelected(prediction.description ?? '');
        },
        seperatedBuilder: const Divider(),
        containerHorizontalPadding: 10,
      ),
    );
  }
}
