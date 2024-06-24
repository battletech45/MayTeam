import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../core/constant/color.dart';

class PageError extends StatelessWidget {
  final String? text;
  final bool isCode;
  const PageError({
    super.key,
    this.text,
    this.isCode = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: 0.5.sw,
            child: Lottie.asset('assets/lottie/404.json'),
          ),
          3.h.verticalSpace,
          Text(
            text ?? 'Sayfa Bulunamadı',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300),
          ),
          10.h.verticalSpace,
          FilledButton(
            onPressed: () => context.go('/'),
            child: const Text('Ana Sayfa'),
          )
        ],
      ),
    );
  }
}