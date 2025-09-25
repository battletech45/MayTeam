import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

import '../../core/constant/color.dart';
import '../../core/constant/text_style.dart';

class LoadingWidget extends StatelessWidget {
  final double? size;
  final Color? color;
  final String? text;
  const LoadingWidget({super.key, this.size, this.color, this.text});

  @override
  Widget build(BuildContext context) {
    if (text != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LoadingAnimationWidget.discreteCircle(
              color: color ?? Colors.white, size: size ?? 48.w),
          6.h.verticalSpace,
          Text(
            text!,
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      return LoadingAnimationWidget.discreteCircle(
          color: color ?? Colors.white, size: size ?? 48.w);
    }
  }
}

class AppErrorWidget extends StatelessWidget {
  final String? text;
  final int? errorCode;
  final bool isCode;
  const AppErrorWidget({
    super.key,
    this.text,
    this.errorCode = 700,
    this.isCode = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: 48.w,
          child: Lottie.asset('assets/lottie/cancel.json', repeat: false),
        ),
        3.h.verticalSpace,
        Text(
          text ?? 'Sunucuya Bağlanırken Hata',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300),
        ),
        isCode == false
            ? 0.h.verticalSpace
            : Text(
                'Hata Kodu: ${errorCode ?? 700}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColor.iconColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w300),
              )
      ],
    );
  }
}

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
            style: FilledButton.styleFrom(
                backgroundColor: AppColor.primaryBackgroundColor),
            child: const Text('Ana Sayfa'),
          )
        ],
      ),
    );
  }
}

class UnknownErrorWidget extends StatelessWidget {
  final double? size;
  const UnknownErrorWidget({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}

class NotFoundWidget extends StatelessWidget {
  const NotFoundWidget({super.key, this.text});
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset('assets/lottie/not-found.json', repeat: false),
        10.h.verticalSpace,
        Text(
          text ?? 'Aradığınız kriterlere göre içerik bulunamadı',
          style: AppTextStyle.fieldText,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}

class ImageError extends StatelessWidget {
  final dynamic error;
  const ImageError({
    super.key,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    String str = '';
    if (error is HttpException) {
      str = (error as HttpException).message;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.hide_image_outlined,
            size: 36.sp, color: AppColor.primaryBackgroundColor),
        Text('Görsel bulunamadı', style: AppTextStyle.imageError),
        Text(str, style: AppTextStyle.imageErrorCode),
      ],
    );
  }
}
