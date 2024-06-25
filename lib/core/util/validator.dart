import 'package:email_validator/email_validator.dart';

class AppValidator {
  AppValidator._();

  RegExp numericPattern = RegExp(r'^[0-9+-]+$');

  static String? emptyValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      return null;
    } else {
      return "Bu alan boş bırakılamaz";
    }
  }

  static String? emailValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      if (EmailValidator.validate(value)) {
        return null;
      } else {
        return "Lütfen geçerli bir e-mail adresi giriniz";
      }
    } else {
      return "Bu alan boş bırakılamaz";
    }
  }

  static String? passwordValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 5) {
        return null;
      } else {
        return "Şifre en az 6 karakter olmalı";
      }
    } else {
      return "Bu alan boş bırakılamaz";
    }
  }

  static String? phoneValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length > 6) {
        return null;
      } else {
        return "Lütfen geçerli bir telefon numarası giriniz";
      }
    } else {
      return "Bu alan boş bırakılamaz";
    }
  }

  static String? creditCardNumberValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      var trimmed = value.replaceAll(' ', '');
      if (trimmed.length == 16) {
        return null;
      } else {
        return "Lütfen geçerli bir kart numarası giriniz";
      }
    } else {
      return "Bu alan boş bırakılamaz";
    }
  }

  static String? exprityValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length == 5) {
        if (value.contains('/')) {
          final now = DateTime.now();
          final List<String> date = value.split(RegExp(r'/'));
          final int month = int.parse(date.first);
          final int year = int.parse('20${date.last}');
          final int lastDayOfMonth = month < 12 ? DateTime(year, month + 1, 0).day : DateTime(year + 1, 1, 0).day;
          final DateTime cardDate = DateTime(year, month, lastDayOfMonth, 23, 59, 59, 999);
          if (cardDate.isBefore(now) || month > 12 || month == 0) {
            return 'Geçmiş tarih girilemez';
          }
          return null;
        } else {
          return 'Geçerli bir tarih giriniz';
        }
      } else {
        return "Geçerli bir tarih giriniz";
      }
    } else {
      return "Bu alan boş bırakılamaz";
    }
  }

  static String? cvvValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length == 4 || value.length == 3) {
        return null;
      } else {
        return "Geçerli bir CVV/CVC giriniz";
      }
    } else {
      return "Bu alan boş bırakılamaz";
    }
  }
}
