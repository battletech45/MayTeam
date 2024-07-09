import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/constant/color.dart';
import '../../core/constant/text_style.dart';
import '../../core/constant/ui_const.dart';

enum AlertType { warn, info, approved, denied, joining }

/// Basit Alert Dialog
///
/// Sağ button reddetmedir ve her zaman `false`, sol button ise onaylamadır ve her zaman `true` döndürür.
/// Eğer [isSingleButton] true ise tek olan buton `true` döndürür
class AppAlertDialog extends StatelessWidget {
  final String? text;
  final String? title;
  final String? leftButtonText;
  final String? rightButtonText;
  final Color? leftTextColor;
  final Color? rightTextColor;
  final bool? repeat;
  final bool isSingleButton;
  final double? height;
  final AlertType? type;
  final Widget? customIcon;
  final void Function()? leftFunction;
  final void Function()? rightFunction;
  const AppAlertDialog({
    super.key,
    this.text,
    this.title,
    this.leftButtonText,
    this.rightButtonText,
    this.leftTextColor,
    this.rightTextColor = AppColor.red,
    this.isSingleButton = false,
    this.type,
    this.customIcon,
    this.leftFunction,
    this.rightFunction, this.repeat, this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.primaryBackgroundColor,
      surfaceTintColor: AppColor.primaryBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(UIConst.paddingValue),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title ?? "Uyarı!",
                  style: AppTextStyle.bigButtonText,
                ),
                type != null ? UIConst.verticalGap() : UIConst.zeroGap,
                SizedBox(height: height != null ? height : (customIcon != null || type != null) ? 200 : 0, child: buildImage(type, customIcon, repeat)),
                UIConst.verticalGap(),
                text == null
                    ? UIConst.zeroGap
                    : ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: SingleChildScrollView(
                          child: Text(
                            text!,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.subtitleTextButton,
                          ),
                        ),
                      ),
                text == null ? UIConst.zeroGap : UIConst.verticalGap(),
              ],
            ),
          ),
          const Divider(height: 0),
          SizedBox(
            height: 48,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    highlightColor: leftTextColor?.withOpacity(0.1),
                    splashColor: leftTextColor?.withOpacity(0.3),
                    onTap: () {
                      if(leftFunction != null) {
                        leftFunction!();
                        Navigator.of(context).pop(true);
                      }
                      else {
                        Navigator.of(context).pop(true);
                      }
                    },
                    borderRadius: BorderRadius.only(bottomLeft: UIConst.radius, bottomRight: isSingleButton ? UIConst.radius : Radius.zero),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: UIConst.radius, bottomRight: isSingleButton ? UIConst.radius : Radius.zero),
                      ),
                      child: Center(
                        child: Text(
                          leftButtonText ?? "Onayla",
                          style: AppTextStyle.smallButtonText,
                        ),
                      ),
                    ),
                  ),
                ),
                isSingleButton ? UIConst.zeroGap : const VerticalDivider(width: 0),
                isSingleButton
                    ? UIConst.zeroGap
                    : Expanded(
                        child: InkWell(
                          splashColor: rightTextColor?.withOpacity(0.3),
                          highlightColor: rightTextColor?.withOpacity(0.1),
                          onTap: () {
                            if(rightFunction != null) {
                              rightFunction!();
                              Navigator.of(context).pop(false);
                            }
                            else {
                              Navigator.of(context).pop(false);
                            }
                          },
                          borderRadius: BorderRadius.only(bottomRight: UIConst.radius),
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomRight: UIConst.radius),
                            ),
                            child: Center(
                              child: Text(
                                rightButtonText ?? "İptal",
                                style: AppTextStyle.smallButtonText.copyWith(color: rightTextColor),
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildImage(AlertType? type, Widget? widget, bool? repeat) {
    if (widget != null) {
      return widget;
    } else {
      if (type == AlertType.approved) {
        return Lottie.asset('assets/lottie/check.json', repeat: repeat ?? false);
      } else if (type == AlertType.info) {
        return Lottie.asset('assets/lottie/info.json', repeat: repeat ?? false);
      } else if (type == AlertType.denied) {
        return Lottie.asset('assets/lottie/cancel.json', repeat: repeat ?? false);
      } else if (type == AlertType.joining){
        return Lottie.asset('assets/lottie/join.json', repeat: repeat ?? false);
      } else if (type == AlertType.warn) {
        return Lottie.asset('assets/lottie/warning.json', repeat: repeat ?? false);
      } else {
        return UIConst.zeroGap;
      }
    }
  }
}
