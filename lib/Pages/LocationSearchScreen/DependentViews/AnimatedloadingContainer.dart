import 'package:flutter/material.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';

class AnimatedPriceProgress extends StatefulWidget {
  const AnimatedPriceProgress({super.key});

  @override
  State<AnimatedPriceProgress> createState() => _AnimatedPriceProgressState();
}

class _AnimatedPriceProgressState extends State<AnimatedPriceProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _widthAnimation = Tween<double>(
      begin: 0.3, // Start at 30% width
      end: 1.0, // End at 100% width
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: ResponsiveUI.h(3, context),
          width: MediaQuery.of(context).size.width * _widthAnimation.value,
          decoration: BoxDecoration(
            color: Styles.primaryColor,
            borderRadius: BorderRadius.circular(ResponsiveUI.r(3, context)),
          ),
        );
      },
    );
  }
}
