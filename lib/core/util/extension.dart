import 'package:mayteam/core/constant/ui_const.dart';
import 'package:flutter/material.dart';
import '../constant/router_config.dart';

extension BlankSpace on num {
  /// [vb] verilen yükseklikte bir SizedBox(height: vb) döndürür
  SizedBox get vb => SizedBox(height: (this).toDouble());

  /// [hb] verilen genişlikte bir SizedBox(width: hb) döndürür
  SizedBox get hb => SizedBox(width: (this).toDouble());
}

extension StringMultipler on String {
  /// [multipler] değeri kadar uc uca ekler
  String multiple([int multipler = 1, int space = 1]) {
    String spaceStr = '';
    for (var i = 0; i < space; i++) {
      spaceStr = '$spaceStr ';
    }
    String str = this;
    for (var i = 0; i < multipler - 1; i++) {
      str = '$str$spaceStr$this';
    }
    return str;
  }
}

extension DateTimeUtils on DateTime {
  /// Verilen aralıktaki günleri [List<DateTime>] formatında döndürür
  List<DateTime> betweenDays(DateTime other) {
    DateTime date1 = this;
    if ((this).isSameDay(other)) {
      return <DateTime>[DateTime(date1.year, date1.month, date1.day)];
    } else {
      date1 = DateTime(date1.year, date1.month, date1.day);
      other = DateTime(other.year, other.month, other.day);

      List<DateTime> days = [];

      if (date1.isAfter(other)) {
        DateTime temp = date1;
        date1 = other;
        other = temp;
      }

      while (!date1.isAfter(other)) {
        days.add(date1);
        date1 = date1.add(const Duration(days: 1));
      }

      return days;
    }
  }

  bool isSameDay(DateTime other) {
    return (this).year == other.year && (this).month == other.month && (this).day == other.day;
  }
}

extension DurationExtension on int {
  Duration get day => Duration(days: this);
  Duration get hour => Duration(hours: this);
  Duration get minute => Duration(minutes: this);
  Duration get second => Duration(seconds: this);
  Duration get millisecond => Duration(milliseconds: this);
}

extension ThemeExt on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  bool get isTablet => MediaQuery.of(this).size.shortestSide >= 600;
}

extension JsonExt on Map<String, dynamic> {
  String get fieldString {
    String str = '';
    for (var ent in entries) {
      if (ent.key == entries.first.key) {
        str = '$str\x1B[32m${ent.key}\x1B[37m: \x1B[36m${ent.value}\x1B[37m';
      } else {
        str = '$str, \x1B[32m${ent.key}\x1B[37m: \x1B[36m${ent.value}\x1B[37m';
      }
    }
    return str;
  }
}

extension DurationTextExt on Duration {
  String timeString() {
    String str = '';
    if (inDays > 0) {
      str += '$inDays Gün ';
    }
    if (inHours > 0) {
      str += '${inHours % 24} Saat ';
    }
    if (inMinutes > 0) {
      str += '${inMinutes % 60} Dakika ';
    }
    if (inSeconds > 0) {
      str += '${inSeconds % 60} Saniye';
    }
    return str;
  }
}

extension ListExt on List {
  List<T> reduceListLenght<T>(int toReduce) {
    if (length > toReduce) {
      return sublist(0, toReduce) as List<T>;
    } else {
      return this as List<T>;
    }
  }
}

/// BİR GRİD DÜZENİNİ INDEXİNE GÖRE ÇARPRAZ RENKLENDİRME KODU<br>
/// [gridCount] crossAxis değeri<br>
/// [index] grid child index değeri
bool paintGrid(int gridCount, int index) {
  int refresh = gridCount * 2;
  final paint = paintedGridCell(gridCount);
  var a = index % refresh;
  bool b = paint.contains(a);
  return b;
}

List<int> paintedGridCell(int gridCount) {
  List<int> painted = [];
  int max = gridCount * 2;

  for (var i = 0; i < max; i = i + 2) {
    if (i < gridCount) {
      painted.add(i);
    } else {
      painted.add(i + 1);
    }
  }
  return painted;
}

List<T> reduceListLenght<T>({required List<T> list, required int toReduce}) {
  if (list.length > toReduce) {
    return list.sublist(0, toReduce);
  } else {
    return list;
  }
}

extension TagExt on List<String>? {
  String? toTagString() {
    if (this != null) {
      String str = '';
      for (var s in this!) {
        if (s == this!.last) {
          str = str + s;
        } else {
          str = '$str$s,';
        }
      }
      return str;
    } else {
      return null;
    }
  }
}

extension DialogExtension on BuildContext {
  ///Bu fonksiyon [AppDialogRoute] kullanarak yeni bir [DialogRoute] oluşturur.
  ///```dart
  ///context.showAppDialog(
  ///   const Dialog(),
  ///   settings: const RouteSettings(
  ///     name: 'home',
  ///     arguments: {'param1': 1, 'param2': 'check'},
  ///   ),
  ///);
  ///```
  ///Şeklinde kullanılabilir
  Future<T?> showAppDialog<T extends Object?>(
      Widget child, {
        RouteSettings? settings,
      }) {
    return rootKey.currentState!.push<T>(
      AppDialogRoute<T>(
        builder: (_) => child,
        settings: settings,
      ),
    );
  }
}

class AppDialogRoute<T> extends PopupRoute<T> {
  AppDialogRoute({
    required this.builder,
    this.dismissible = true,
    super.settings,
  });

  final WidgetBuilder builder;
  final bool dismissible;

  @override
  Color? get barrierColor => Colors.black45;

  @override
  bool get barrierDismissible => dismissible;

  @override
  String? get barrierLabel => "label";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    Animation<double> anim2 = CurvedAnimation(parent: animation, curve: Curves.bounceOut, reverseCurve: Curves.linear);
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.6, end: 1).animate(anim2),
        child: child,
      ),
    );
  }

  @override
  Duration get transitionDuration => UIConst.animationDuration;
}
