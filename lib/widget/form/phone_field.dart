import 'package:MayTeam/core/constant/text_style.dart';
import 'package:MayTeam/core/constant/ui_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../core/constant/color.dart';
import '../../core/util/validator.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({super.key, required this.onChanged, this.initialCountryCode = 'TR', this.initialValue});
  final void Function(PhoneNumber value) onChanged;
  final String initialCountryCode;
  final String? initialValue;
  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      onChanged: onChanged,
      initialValue: initialValue,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(color: AppColor.borderColor, width: 1)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(color: AppColor.primaryTextColor, width: 1)
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0).r,
        hintStyle: AppTextStyle.smallButtonText.copyWith(color: AppColor.iconColor),
      ),
      invalidNumberMessage: 'Geçersiz telefon numarası',
      initialCountryCode: initialCountryCode,
      keyboardType: TextInputType.phone,
      showDropdownIcon: false,
      flagsButtonMargin: UIConst.horizontal,
      languageCode: 'tr',
      style: AppTextStyle.contactCardTitle.copyWith(color: AppColor.primaryTextColor),
      validator: AppValidator.phoneNumberValidator,
      pickerDialogStyle: PickerDialogStyle(
        searchFieldInputDecoration: const InputDecoration(hintText: 'Ara..', contentPadding: EdgeInsets.symmetric(horizontal: UIConst.paddingValue)),
        backgroundColor: AppColor.primaryBackgroundColor,
        countryCodeStyle: Theme.of(context).textTheme.bodyMedium,
        countryNameStyle: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
