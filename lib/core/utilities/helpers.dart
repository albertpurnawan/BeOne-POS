import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

abstract class Helpers {
  static void showSnackbar(BuildContext context,
          {required Widget content, SnackBarAction? action}) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: content, action: action));

  static String parseMoney(num nominal) {
    return NumberFormat("#,##0.##").format(nominal);
  }

  static String cleanDecimal(num val, int digits) {
    var stringVal = val.toStringAsFixed(digits);
    int i = stringVal.length;
    while (stringVal[i - 1] == "0") {
      i--;
    }
    if (stringVal[i - 1] == ".") i--;
    return stringVal.substring(0, i);
  }

  static String revertMoneyToString(double value) {
    int intValue = value.toInt();
    String stringValue = intValue.toString();
    return stringValue;
  }

  static Future<T?> showDialog<T>(BuildContext context,
      {EdgeInsetsGeometry? padding, required Widget child}) async {
    if (kIsWeb) {
      return await showGeneralDialog<T>(
          barrierDismissible: true,
          barrierLabel: DateTime.now().millisecondsSinceEpoch.toString(),
          context: context,
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            return Transform.scale(
              scale:
                  Tween<double>(begin: 1.05, end: 1).animate(animation).value,
              child: Opacity(opacity: animation.value, child: child),
            );
          },
          pageBuilder: (context, __, _) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  padding: padding,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.75,
                      maxWidth: 450),
                  child: Material(
                    color: Colors.transparent,
                    child: child,
                  ),
                ),
              ),
            );
          });
    }

    return await showModalBottomSheet<T>(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          const radius = Radius.circular(5);

          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: radius, topRight: radius)),
                padding: padding ?? const EdgeInsets.all(20),
                child: child),
          );
        });
  }

  static double revertMoneyToDecimalFormat(String value) {
    final moneyReversion = RegExp(r"\.00|\,");

    try {
      return double.parse(value.replaceAll(moneyReversion, ""));
    } catch (e) {
      return 0;
    }
  }

  static double revertMoneyToDecimalFormatDouble(String value) {
    final moneyReversion = RegExp(r"\,");

    try {
      return double.parse(value.replaceAll(moneyReversion, ""));
    } catch (e) {
      return 0;
    }
  }

  static Future<T?> navigate<T>(BuildContext context, Widget child) {
    final screen = GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child:
          Material(child: Scaffold(body: child, backgroundColor: Colors.white)),
    );

    if (kIsWeb) {
      return showDialog<T>(context, child: child);
    }

    return Navigator.of(context)
        .push<T>(CupertinoPageRoute(builder: (context) => screen));
  }

  static void setStatusbarIconBrightness(Brightness brightness) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarIconBrightness: brightness));
  }

  static Future<BuildContext> showLoadingAnimationDialog(
      BuildContext context) async {
    BuildContext? dialogContext;
    final completer = Completer();

    showGeneralDialog(
        context: context,
        transitionBuilder: (context, animation, _, child) {
          animation =
              CurvedAnimation(parent: animation, curve: Curves.easeInOut);
          final scaleAnimation =
              Tween<double>(begin: 1.05, end: 1).animate(animation);

          return Transform.scale(
              scale: scaleAnimation.value,
              child: Opacity(opacity: animation.value, child: child));
        },
        pageBuilder: (context, _, __) {
          dialogContext ??= context;
          completer.complete();

          return Center(
            child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: const CircularProgressIndicator()),
          );
        });
    await completer.future;

    return dialogContext!;
  }

  static String generateRandomNum({int length = 5}) {
    return List.generate(length, (index) => Random().nextInt(9)).join("");
  }

  static String dateToString(DateTime date) => date.toString().split(" ").first;

  static String getBaseTypeName(int baseType) {
    switch (baseType) {
      case 11:
        return "Sales Quotation";
      case 12:
        return "Sales Order";
      case 13:
        return "Delivery Order";
      case 14:
        return "AR Invoice";
      case 15:
        return "Incoming Payment";
      case 16:
        return "Returns";
      case 17:
        return "Purchase Request";
      case 18:
        return "Purchase Order";
      case 19:
        return "Goods Receipt Purchase Order";
      case 20:
        return "AP Invoice";
      case 21:
        return "Outgoing Payment";
      case 22:
        return "Goods Return";
      case 23:
        return "Inventory Transfer";
      case 24:
        return "Goods Issue";
      case 25:
        return "Goods Receipt";
      default:
        return "Unknown";
    }
  }

  static String localDateStringToUtcString(String dtString) {
    final dt = DateTime.parse(dtString);
    debugPrint(dtString);
    return dt.toUtc().toString();
  }

  static String formatDate(DateTime dTime) {
    final DateFormat formatter = DateFormat('EEEE, dd MMM yyyy HH:mm:ss');
    return formatter.format(dTime).toString();
  }

  static String dateddMMMyyyyHHmmss(DateTime dTime) {
    final DateFormat formatter = DateFormat('dd MMM yyyy HH:mm:ss');
    return formatter.format(dTime).toString();
  }

  static String dateEEddMMMyyy(DateTime dTime) {
    final DateFormat formatter = DateFormat('EEEE, dd MMM yyyy');
    return formatter.format(dTime).toString();
  }

  static String dateHHmmss(DateTime dTime) {
    final DateFormat formatter = DateFormat('HH:mm:ss');
    return formatter.format(dTime).toString();
  }

  static String formatDateNoSeconds(DateTime dTime) {
    final DateFormat formatter = DateFormat('EEEE, dd MMM yyyy HH:mm');
    return formatter.format(dTime).toString();
  }

  static String getTimezone(DateTime dTime) {
    final timezoneOffset = dTime.timeZoneOffset;

    if (timezoneOffset != Duration.zero) {
      final sign = timezoneOffset.inHours >= 0 ? '+' : '-';
      final absHours = timezoneOffset.inHours.abs();
      final timezoneString = 'GMT$sign$absHours';

      return timezoneString;
    } else {
      const timezoneString = 'GMT+0';
      return timezoneString;
    }
  }

  static SplitListResult<Type> splitList<Type>(
      List<Type> list, bool Function(Type) matchFunction) {
    final List<Type> falseResult = [];
    final List<Type> trueResult = [];

    for (final e in list) {
      if (matchFunction(e)) {
        trueResult.add(e);
      } else {
        falseResult.add(e);
      }
    }

    return SplitListResult<Type>(falseResult, trueResult);
  }
  // static String checkDate(DateTime date) {
  //   final day = "day${date.weekday}";
  //   print("$day");
  //   return day;
  // }

  static alignRightByAddingSpace(String string, int n) {
    if (string.length > n) {
      return string;
    } else {
      final String spaces =
          List.generate(n - string.length, (index) => " ").join("");
      return spaces + string;
    }
  }

  static clipStringAndAddEllipsis(String string, int n) {
    if (string.length < n) {
      return string;
    } else {
      return "${string.substring(0, n)}...";
    }
  }
}

class SplitListResult<T> {
  final List<T> falseResult;
  final List<T> trueResult;

  SplitListResult(this.falseResult, this.trueResult);
}
