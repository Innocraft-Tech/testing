import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSvg extends StatelessWidget {
  final String name;
  final double width;
  final double height;
  final Alignment? alignment;
  final BoxFit? fit;

  const CustomSvg({
    Key? key,
    required this.height,
    required this.name,
    required this.width,
    this.alignment,
    this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      name,
      width: width,
      height: height,
      alignment: alignment ?? Alignment.center,
      fit: fit ?? BoxFit.contain,
    );
  }
}
