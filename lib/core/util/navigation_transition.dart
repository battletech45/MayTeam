import 'package:flutter/material.dart';

class SlidingPageTransition extends PageTransitionsBuilder {
  const SlidingPageTransition();
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final tween =
        Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
            .chain(CurveTween(curve: Curves.fastLinearToSlowEaseIn));
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}
