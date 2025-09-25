import 'package:mayteam/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedLogo extends StatefulWidget {
  @override
  _AnimatedChatLogoState createState() => _AnimatedChatLogoState();
}

class _AnimatedChatLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
            begin: AppColor.primaryBackgroundColor,
            end: AppColor.secondaryBackgroundColor)
        .animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value * 2.0 * 3.14159,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _colorAnimation.value!,
                  BlendMode.modulate,
                ),
                child: child,
              ),
            ),
          );
        },
        child:
            Image.asset('assets/images/logo.png', width: 300.w, height: 300.h),
      ),
    );
  }
}
