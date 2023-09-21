import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color? color;
  final double? width;
  final double? height;
  final String label;
  final TextStyle? labelStyle;
  final VoidCallback onTap;
  final bool isDisable;
  final double? borderWidth;
  final double? borderRadius;
  final Color? borderColor;

  const CustomButton({
    Key? key,
    this.color,
    this.height,
    required this.label,
    this.labelStyle,
    required this.onTap,
    required this.isDisable,
    this.borderWidth,
    this.borderColor,
    this.width,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisable ? () {} : onTap,
      child: Opacity(
        opacity: isDisable ? 0.5 : 1,
        child: Container(
          width: width ?? 60,
          height: height ?? 40,
          decoration: BoxDecoration(
            color: color ?? Colors.white,
            border: Border.all(
                color: borderColor ?? Colors.transparent,
                width: borderWidth ?? 0),
            borderRadius: BorderRadius.circular(borderRadius ?? 15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: labelStyle ??
                    TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
