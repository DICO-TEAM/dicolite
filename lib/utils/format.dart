import 'dart:convert';
import 'dart:math';

import 'package:convert/convert.dart';
import 'package:decimal/decimal.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/store/assets/types/balancesInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:dicolite/store/account/types/accountData.dart';
import 'package:dicolite/store/app.dart';

class Fmt {
  static String passwordToEncryptKey(String password) {
    String passHex = hex.encode(utf8.encode(password));
    if (passHex.length > 32) {
      return passHex.substring(0, 32);
    }
    return passHex.padRight(32, '0');
  }

  static String address(String? addr, {int pad = 6}) {
    try {
      if (addr == null || addr.length == 0) {
        return "~";
      }
      return addr.substring(0, pad) + '...' + addr.substring(addr.length - pad);
    } catch (e) {
      print(e.toString());
      return '~';
    }
  }

  static String dateTime(DateTime? time) {
    if (time == null) {
      return 'date-time';
    }
    return DateFormat('yyyy-MM-dd HH:mm').format(time);
  }

  static BigInt balanceTotal(BalancesInfo? balance) {
    return balanceInt((balance?.freeBalance ?? 0).toString()) +
        balanceInt((balance?.reserved ?? 0).toString());
  }

  /// number transform
  /// from raw <String> of Api data to <BigInt>
  static BigInt balanceInt(String? raw) {
    if (raw == null || raw.length == 0) {
      return BigInt.zero;
    }
    if (raw.contains(',') || raw.contains('.')) {
      return BigInt.from(NumberFormat(",##0.000").parse(raw));
    } else {
      return BigInt.parse(raw);
    }
  }

  /// number transform
  /// from <BigInt> to <double>
  static double bigIntToDouble(BigInt? value, int decimals) {
    if (value == null) {
      return 0;
    }
    return value / BigInt.from(pow(10, decimals));
  }

  /// number transform
  /// from <BigInt> to <double>
  static Decimal bigIntToDecimal(BigInt? value, int decimals) {
    if (value == null) {
      return Decimal.zero;
    }
    return Decimal.fromBigInt(value) /
        Decimal.fromBigInt(BigInt.from(10).pow(decimals));
  }

  /// number transform
  /// from <BigInt> to <double>
  static String bigIntToDecimalString(BigInt? value, int decimals) {
    if (value == null) {
      return '0';
    }
    return (Decimal.fromBigInt(value) /
            Decimal.fromBigInt(BigInt.from(10).pow(decimals)))
        .toString();
  }

  /// number transform
  /// from <double> to <String> in token format of ",##0.000"
  static String doubleFormat(
    double? value, {
    int length = 3,
    int round = 0,
  }) {
    if (value == null) {
      return '~';
    }
    value.toStringAsFixed(3);
    NumberFormat f =
        NumberFormat(",##0${length > 0 ? '.' : ''}${'#' * length}", "en_US");
    String val = f.format(value);
    if (val == "-0") {
      val = "0";
    }
    return val;
  }

  /// combined number transform
  /// from raw <String> to <String> in token format of ",##0.000"
  static String balance(
    String? raw,
    int decimals, {
    int length = 3,
  }) {
    if (raw == null || raw.length == 0) {
      return '~';
    }
    return doubleFormat(bigIntToDouble(balanceInt(raw), decimals),
        length: length);
  }

  /// combined number transform
  /// from raw <String> to <double>
  static double balanceDouble(String raw, int decimals) {
    return bigIntToDouble(balanceInt(raw), decimals);
  }

  /// combined number transform
  /// from <BigInt> to <String> in token format of ",##0.000"
  static String token(
    BigInt? value,
    int decimals, {
    int length = 3,
  }) {
    if (value == null) {
      return '~';
    }
    return doubleFormat(bigIntToDouble(value, decimals), length: length);
  }

  /// number transform
  /// from <String of double> to <BigInt>
  static BigInt tokenInt(String? value, int decimals) {
    if (value == null) {
      return BigInt.zero;
    }
    num v = 0;
    try {
      if (value.contains(',') || value.contains('.')) {
        // v = NumberFormat(",##0.${"0" * decimals}").parse(value);
        return BigInt.parse((Decimal.parse(value.replaceAll(',', '')) *
                Decimal.fromInt(10).pow(decimals))
            .toStringAsFixed(0));
      } else {
        v = double.parse(value);
      }
    } catch (err) {
      print('Fmt.tokenInt() error: ${err.toString()}');
    }
    return BigInt.parse(
        (Decimal.parse(v.toString()) * Decimal.fromInt(10).pow(decimals))
            .toStringAsFixed(0));
  }

  /// number transform
  /// from <BigInt> to <String> in price format of ",##0.00"
  /// ceil number of last decimal
  static String priceCeil(
    double? value, {
    int lengthFixed = 2,
    int? lengthMax,
  }) {
    if (value == null) {
      return '~';
    }
    final num x = pow(10, lengthMax ?? lengthFixed);
    final double price = (value * x).ceilToDouble() / x;
    final String tailDecimals =
        lengthMax == null ? '' : "#" * (lengthMax - lengthFixed);
    return NumberFormat(
            ",##0${lengthFixed > 0 ? '.' : ''}${"0" * lengthFixed}$tailDecimals",
            "en_US")
        .format(price);
  }

  /// number transform
  /// from <BigInt> to <String> in price format of ",##0.00"
  /// floor number of last decimal
  static String priceFloor(
    double? value, {
    int lengthFixed = 2,
    int? lengthMax,
  }) {
    if (value == null) {
      return '~';
    }
    final num x = pow(10, lengthMax ?? lengthFixed);
    final double price = (value * x).floorToDouble() / x;
    final String tailDecimals =
        lengthMax == null ? '' : "#" * (lengthMax - lengthFixed);
    return NumberFormat(
            ",##0${lengthFixed > 0 ? '.' : ''}${"0" * lengthFixed}$tailDecimals",
            "en_US")
        .format(price);
  }

  /// number transform
  /// from number to <String> in price format of ",##0.###%"
  static String ratio(dynamic number, {bool needSymbol = true}) {
    NumberFormat f = NumberFormat(",##0.###${needSymbol ? '%' : ''}");
    return f.format(number ?? 0);
  }

  static String priceCeilBigInt(
    BigInt? value,
    int decimals, {
    int lengthFixed = 2,
    int? lengthMax,
  }) {
    if (value == null) {
      return '~';
    }
    return priceCeil(Fmt.bigIntToDouble(value, decimals),
        lengthFixed: lengthFixed, lengthMax: lengthMax);
  }

  static String priceFloorBigInt(
    BigInt? value,
    int decimals, {
    int lengthFixed = 2,
    int? lengthMax,
  }) {
    if (value == null) {
      return '~';
    }
    return priceFloor(Fmt.bigIntToDouble(value, decimals),
        lengthFixed: lengthFixed, lengthMax: lengthMax);
  }

  static bool isAddress(String txt) {
    var reg = RegExp(r'^[A-z\d]{47,48}$');
    return reg.hasMatch(txt);
  }

  static bool isHexString(String hex) {
    var reg = RegExp(r'^[a-f0-9]+$');
    return reg.hasMatch(hex);
  }

  static bool checkPassword(String pass) {
    var reg = RegExp(r'^(?![0-9]+$)(?![a-zA-Z]+$)[\S]{6,20}$');
    return reg.hasMatch(pass);
  }

  static bool isEnglish(String str) {
    var reg = RegExp(
        "^[A-Za-z0-9-\,\.\"\'\;\:\(\)\\[\\]\/\{\}\%\!\?\\\\>\<=\~\@\*\&\^\#_+\$\\s]+\$");
    return reg.hasMatch(str);
  }

  static List<List> filterCandidateList(
      List<List> ls, String filter, Map accIndexMap) {
    ls.retainWhere((i) {
      String value = filter.trim().toLowerCase();
      String accName = '';
      Map? accInfo = accIndexMap[i[0]];
      if (accInfo != null) {
        accName = accInfo['identity']['display'] ?? '';
      }
      return i[0].toLowerCase().contains(value) ||
          accName.toLowerCase().contains(value);
    });
    return ls;
  }

  static Map formatRewardsChartData(Map chartData) {
    List<List> formatChart(List chartValues) {
      List<List> values = [];

      chartValues.asMap().forEach((index, ls) {
        if (ls[0].toString().contains('0x')) {
          ls = List.of(ls).map((e) => int.parse(e.toString())).toList();
        }
        if (index == chartValues.length - 1) {
          List average = [];
          List.of(ls).asMap().forEach((i, v) {
            final avg = v - values[values.length - 1][i];
            average.add(avg);
          });
          values.add(average);
        } else {
          values.add(ls);
        }
      });

      return values;
    }

    final List<String> labels = [];
    List<String>.from(chartData['rewards']['labels']).asMap().forEach((k, v) {
      if ((k - 2) % 10 == 0) {
        labels.add(v);
      } else {
        labels.add('');
      }
    });

    List rewards = formatChart(List.of(chartData['rewards']['chart']));
    List points = formatChart(List.of(chartData['points']['chart']));
    List stakes = formatChart(List.of(chartData['stakes']['chart']));
    return {
      'rewards': [rewards, labels],
      'stakes': [stakes, labels],
      'points': [points, labels],
    };
  }

  static int daysToblock(double? days, int? blockDuration) {
    if (days == null) return 0;
    if (blockDuration == null) blockDuration = 12000; // 12s

    return (days * 24 * 60 * 60000) ~/ blockDuration;
  }

  static int blockToMin(int? blocks, int? blockDuration) {
    if (blocks == null || blocks == 0 || blockDuration == 0 || blocks < 0)
      return 0;
    if (blockDuration == null) blockDuration = 12000; // 12s
    int blocksOfMin = 60000 ~/ blockDuration;

    return (blocks / blocksOfMin).floor();
  }

  static String blockToTime(int? blocks, int blockDuration) {
    if (blocks == null) return '~';
    if (blocks < 0) return '0 mins';

    int blocksOfMin = 60000 ~/ blockDuration;
    int blocksOfHour = 60 * blocksOfMin;
    int blocksOfDay = 24 * blocksOfHour;

    int day = (blocks / blocksOfDay).floor();
    int hour = (blocks % blocksOfDay / blocksOfHour).floor();
    int min = (blocks % blocksOfHour / blocksOfMin).floor();
    String minDouble = (blocks % blocksOfHour / blocksOfMin).toStringAsFixed(1);

    String res = '$minDouble mins';

    if (day > 0) {
      res = '$day days $hour hrs';
    } else if (hour > 0) {
      res = '$hour hrs $res';
    } else if (min > 0) {
      res = '$min mins';
    }
    return res;
  }

  static String accountName(BuildContext context, AccountData acc) {
    return '${acc.name ?? ''}${(acc.observation) ? ' (${S.of(context).observe})' : ''}';
  }

  static String blockToWithTime(int blocks, int blockDuration) {
    int blocksOfMin = 60000 ~/ blockDuration;
    int blocksOfHour = 60 * blocksOfMin;
    int blocksOfDay = 24 * blocksOfHour;

    int day = (blocks / blocksOfDay).floor();
    int hour = (blocks % blocksOfDay / blocksOfHour).floor();
    int min = (blocks % blocksOfHour / blocksOfMin).floor();

    String res = '$min mins';
    if (hour > 0) {
      res = '$hour hrs';
    }
    if (day > 0) {
      res = '$day days';
    }
    return res;
  }

  static String accountDisplayNameString(String address, Map? accInfo) {
    String display = Fmt.address(address, pad: 6);
    if (accInfo != null) {
      if (accInfo['identity']['display'] != null) {
        display = accInfo['identity']['display'];
        if (accInfo['identity']['displayParent'] != null) {
          display = '${accInfo['identity']['displayParent']}/$display';
        }
      } else if (accInfo['accountIndex'] != null) {
        display = accInfo['accountIndex'];
      }
      display = display.toUpperCase();
    }
    return display;
  }

  static String tokenView(String? token) {
    String tokenView = token ?? '';
    
    return tokenView;
  }

  static Widget accountDisplayName(String address, Map? accInfo) {
    return Row(
      children: <Widget>[
        accInfo != null && accInfo['identity']['judgements'].length > 0
            ? Container(
                width: 14,
                margin: EdgeInsets.only(right: 4),
                child: Image.asset('assets/images/main/receive-success.png'),
              )
            : Container(height: 16),
        Expanded(
          child: Text(accountDisplayNameString(address, accInfo)),
        )
      ],
    );
  }

  static String addressOfAccount(AccountData acc, AppStore store) {
    if (store.settings?.endpoint.ss58 == null) return acc.address;
    return store.account
            ?.pubKeyAddressMap[store.settings?.endpoint.ss58]![acc.pubKey] ??
        acc.address;
  }

  static String numFixed(num number, int decimals) {
    String val = number.toStringAsFixed(decimals);
    if (val.contains(".")) {
      return val.replaceAll(RegExp(r"(\.0+$)|0+$"), "");
    }

    /// It is int
    return val;
  }

  static String decimalFixed(Decimal number, int decimals) {
    String val = number.toStringAsFixed(decimals);

    if (val.contains(".")) {
      return val.replaceAll(RegExp(r"(\.0+$)|0+$"), "");
    }

    /// It is int
    return val;
  }
}
