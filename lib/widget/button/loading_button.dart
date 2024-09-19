import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/ui_const.dart';
import '../base/loading.dart';

class LoadingButton extends StatefulWidget {
  final Future<void> Function()? onTap;
  final Widget? child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  const LoadingButton({super.key, required this.onTap, this.child, this.backgroundColor, this.foregroundColor});

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: widget.onTap != null
          ? () async {
        if (!isLoading) {
          setState(() {
            isLoading = true;
          });
          await widget.onTap!();
          setState(() {
            isLoading = false;
          });
        }
      }
          : null,
      style: FilledButton.styleFrom(
        backgroundColor: widget.backgroundColor,
        foregroundColor: widget.foregroundColor,
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: UIConst.animationDuration,
          child: isLoading ? LoadingWidget(key: const ValueKey(true), size: 24.h) : widget.child,
        ),
      ),
    );
  }
}
