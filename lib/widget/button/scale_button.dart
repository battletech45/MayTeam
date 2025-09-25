import 'package:mayteam/core/constant/ui_const.dart';
import 'package:flutter/material.dart';

import '../../core/util/math.dart';

class ScaleButton extends StatefulWidget {
  const ScaleButton({
    super.key,
    this.child,
    this.decoration,
    this.onTap,
    this.padding,
    this.waitAnimation = true,
    this.bordered = true,
  });

  const ScaleButton.onlyScale({
    super.key,
    this.child,
    this.decoration = const BoxDecoration(),
    this.onTap,
    this.padding = EdgeInsets.zero,
    this.waitAnimation = true,
    this.bordered = true,
  });

  const ScaleButton.noDecoration({
    super.key,
    this.child,
    this.decoration = const BoxDecoration(),
    this.onTap,
    this.padding,
    this.waitAnimation = true,
    this.bordered = true,
  });

  final Widget? child;
  final BoxDecoration? decoration;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final bool waitAnimation;
  final bool bordered;

  @override
  State<ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<ScaleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 1, end: 0.3).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: () {
            _controller.reverse();
          },
          onTap: widget.waitAnimation
              ? () async {
                  await _controller.forward();
                  if (widget.onTap != null) {
                    widget.onTap!();
                  }
                  _controller.reverse();
                }
              : widget.onTap,
          child: Transform.scale(
            scale: AppMath.generalNormalizeValue(
                value: _animation.value,
                minValue: 0.3,
                maxValue: 1,
                minNormalizedValue: 0.95,
                maxNormalizedValue: 1),
            child: AnimatedContainer(
              duration: UIConst.animationDuration,
              decoration: widget.decoration ??
                  (widget.bordered
                      ? UIConst.borderedBoxDecoration
                      : UIConst.boxDecoration),
              padding: widget.padding ?? UIConst.pageFullPadding(context),
              child: Opacity(
                opacity: _animation.value,
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }
}
