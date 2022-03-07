import 'dart:async';

import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/utils/my_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dicolite/common/reg_input_formatter.dart';
import 'package:dicolite/store/app.dart';
import 'package:url_launcher/url_launcher.dart';

class UI {
  static void copyAndNotify(BuildContext context, String? text) {
    Clipboard.setData(ClipboardData(text: text ?? ''));

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        final S dic = S.of(context);
        return CupertinoAlertDialog(
          title: Container(),
          content: Text('${dic.copy} ${dic.success}'),
        );
      },
    );

    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  static Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      try {
        await launch(url);
      } catch (err) {
        print(err);
      }
    } else {
      print('Could not launch $url');
      showErrorMsg('Could not launch $url');
    }
  }


  static Future<void> alertWASM(BuildContext context, Function onCancel) async {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Container(),
          content: Text(S.of(context).backup_error),
          actions: <Widget>[
            CupertinoButton(
              child: Text(S.of(context).ok),
              onPressed: () {
                Navigator.of(context).pop();
                onCancel();
              },
            ),
          ],
        );
      },
    );
  }

  static bool checkBalanceAndAlert(
      BuildContext context, AppStore store, BigInt amountNeeded) {
    String symbol = store.settings!.networkState.tokenSymbol;
    if (store.assets!.balances[symbol]!.transferable! <= amountNeeded) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(S.of(context).amount_low),
            content: Container(),
            actions: <Widget>[
              CupertinoButton(
                child: Text(S.of(context).ok),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      return false;
    } else {
      return true;
    }
  }

  static TextInputFormatter decimalInputFormatter(int decimals) {
    if(decimals==0){
      return RegExInputFormatter.withRegex('^[0-9]{0,20}\$');
    }
    return RegExInputFormatter.withRegex(
        '^[0-9]{0,20}(\\.[0-9]{0,$decimals})?\$');
  }
}

// access the refreshIndicator globally

// council & motions page:
final GlobalKey<RefreshIndicatorState> globalCouncilRefreshKey =
    new GlobalKey<RefreshIndicatorState>();
final GlobalKey<RefreshIndicatorState> globalMotionsRefreshKey =
    new GlobalKey<RefreshIndicatorState>();
// democracy page:
final GlobalKey<RefreshIndicatorState> globalDemocracyRefreshKey =
    new GlobalKey<RefreshIndicatorState>();
// treasury proposals&tips page:
final GlobalKey<RefreshIndicatorState> globalProposalsRefreshKey =
    new GlobalKey<RefreshIndicatorState>();
final GlobalKey<RefreshIndicatorState> globalTipsRefreshKey =
    new GlobalKey<RefreshIndicatorState>();
// recovery settings page:
final GlobalKey<RefreshIndicatorState> globalRecoverySettingsRefreshKey =
    new GlobalKey<RefreshIndicatorState>();
// recovery state page:
final GlobalKey<RefreshIndicatorState> globalRecoveryStateRefreshKey =
    new GlobalKey<RefreshIndicatorState>();
// recovery vouch page:
final GlobalKey<RefreshIndicatorState> globalRecoveryProofRefreshKey =
    new GlobalKey<RefreshIndicatorState>();

// Proposal Detail page:
final GlobalKey<RefreshIndicatorState> globalProposalDetailRefreshKey =
    new GlobalKey<RefreshIndicatorState>();

//ico page:
final GlobalKey<RefreshIndicatorState> globalIcoRefreshKey =
    new GlobalKey<RefreshIndicatorState>();


//dao page:
final GlobalKey<RefreshIndicatorState> globalDaoRefreshKey =
    new GlobalKey<RefreshIndicatorState>();


//lbp page:
final GlobalKey<RefreshIndicatorState> globalLbpRefreshKey =
    new GlobalKey<RefreshIndicatorState>();



//kyc page:
final GlobalKey<RefreshIndicatorState> globalKycInfoRefreshKey =
    new GlobalKey<RefreshIndicatorState>();


//nft page:
final GlobalKey<RefreshIndicatorState> globalNftListRefreshKey =
    new GlobalKey<RefreshIndicatorState>();

//nft page:
final GlobalKey<RefreshIndicatorState> globalMyNFTRefreshKey =
    new GlobalKey<RefreshIndicatorState>();


//liquidity page:
final GlobalKey<RefreshIndicatorState> globalLiquidityRefreshKey =
    new GlobalKey<RefreshIndicatorState>();



//liquidity page:
final GlobalKey<RefreshIndicatorState> globalExchangeRefreshKey =
    new GlobalKey<RefreshIndicatorState>();



//liquidity page:
final GlobalKey<RefreshIndicatorState> globalLbpExchangeRefreshKey =
    new GlobalKey<RefreshIndicatorState>();



//farms page:
final GlobalKey<RefreshIndicatorState> globalFarmsRefreshKey =
    new GlobalKey<RefreshIndicatorState>();


//pools page:
final GlobalKey<RefreshIndicatorState> globalPoolsRefreshKey =
    new GlobalKey<RefreshIndicatorState>();

