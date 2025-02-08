import 'package:flutter/material.dart';
import 'package:zappy/Pages/LocationSearchScreen/DependentViews/LocationResult.dart';

class SearchResultsList extends StatelessWidget {
  const SearchResultsList({super.key});

  @override
  Widget build(BuildContext context) {
    final locations = [
      {
        'name': 'Vellore New Bus Station',
        'address': 'Thottapalayam, Vellore, Tamil Nadu',
      },
      {
        'name': 'VIT University',
        'address': 'Katpadi, Vellore, Tamil Nadu',
      },
      {
        'name': 'Katpadi Railway Station',
        'address': 'Katpadi, Vellore, Tamil Nadu',
      },
      {
        'name': 'CMC Hospital',
        'address': 'Thottapalayam, Vellore, Tamil Nadu',
      },
    ];

    return ListView.builder(
      itemCount: locations.length,
      itemBuilder: (context, index) {
        return LocationResultItem(
          name: locations[index]['name']!,
          address: locations[index]['address']!,
          onTap: () {
            // Handle location selection
          },
        );
      },
    );
  }
}
