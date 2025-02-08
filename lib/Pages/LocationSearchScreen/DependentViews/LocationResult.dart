import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';

class LocationResultItem extends StatelessWidget {
  final String name;
  final String address;
  final VoidCallback onTap;

  const LocationResultItem({
    super.key,
    required this.name,
    required this.address,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.location_on, color: Colors.white),
      title: Text(
        name,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        address,
        style: TextStyle(color: Colors.grey[400]),
      ),
      trailing: SvgPicture.asset(
        AppConstants.locationIndicator,
        width: ResponsiveUI.w(24, context),
        height: ResponsiveUI.h(24, context),
      ),
      onTap: onTap,
    );
  }
}
