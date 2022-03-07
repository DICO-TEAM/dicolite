import 'dart:async';

import 'package:biometric_storage/biometric_storage.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/dao_proposal_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dicolite/pages/me/manage_account/manage_account.dart';
import 'package:dicolite/utils/adapt.dart';
// import 'package:local_auth/auth_strings.dart';
// import 'package:local_auth/local_auth.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/store/assets/types/balancesInfo.dart';
import 'package:dicolite/utils/format.dart';

import 'package:dicolite/utils/loading.dart';
import 'package:dicolite/utils/local_storage.dart';
// import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:overlay_support/overlay_support.dart';

final _biometricPasswordKey = 'biometric_password_';

/// [Show error msg]
void showErrorMsg(String msg, {bool isLong = true}) {
  showSimpleNotification(
    Text(
      msg,
      style: TextStyle(color: Colors.white),
    ),
    leading: Icon(
      Icons.error,
      color: Colors.white,
    ),
    background: Colors.pink,
  );
}

/// [Show success msg]
void showSuccessMsg(String msg, {bool isLong = false}) {
  showSimpleNotification(
    Text(
      msg,
      style: TextStyle(color: Colors.white),
    ),
    leading: Icon(
      Icons.check,
      color: Colors.white,
    ),
    background: Colors.green,
  );
}

void showConfrim(BuildContext context, Widget title, Function okFn,
    {String? okText, Widget? ok}) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: title,
      actions: <Widget>[
        CupertinoButton(
          child: Text(
            S.of(context).cancel,
            style: TextStyle(color: Colors.grey),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoButton(
          child: ok != null
              ? ok
              : Text(okText ?? S.of(context).ok,
                  style: TextStyle(color: Colors.red)),
          onPressed: () {
            Navigator.pop(context);
            okFn();
          },
        ),
      ],
    ),
  );
}

/// [copy]
void copy(context, text) {
  Clipboard.setData(ClipboardData(text: text));
  showSuccessMsg(S.of(context).copyToClipboard);
}

/// [Show password dialog ]
Future<String?> showPasswordDialog(
    BuildContext context, String currentAccountPubKey,
    {bool isShowGoAuth = true}) async {
  final S dic = S.of(context);
  final Api? api = webApi;
  final TextEditingController _passCtrl = new TextEditingController();

  return await showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(dic.inputPasswordConfirm),
        content: Padding(
          padding: EdgeInsets.only(top: 16),
          child: Column(
            children: [
              CupertinoTextField(
                placeholder: dic.pass_old,
                controller: _passCtrl,
                // onChanged: (v) {
                //    Fmt.checkPassword(v!.trim())
                //       ;
                // },

                obscureText: true,
                clearButtonMode: OverlayVisibilityMode.editing,
              ),
              isShowGoAuth
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            child: Text(S.of(context).unlock_bio_enable,
                                style: TextStyle(fontSize: Adapt.px(26))),
                            onPressed: () => Navigator.of(context)
                                .pushNamed(ManageAccount.route)),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
        actions: <Widget>[
          CupertinoButton(
            child: Text(
              S.of(context).cancel,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              _passCtrl.clear();
            },
          ),
          CupertinoButton(
            child: Text(S.of(context).ok),
            onPressed: () async {
              Loading.showLoading(context);
              var res =
                  await api?.account?.checkAccountPassword(_passCtrl.text);
              Loading.hideLoading(context);
              if (res == null) {
                showErrorMsg(dic.pass_error);
              } else {
                Navigator.of(context).pop(_passCtrl.text);
              }
            },
          ),
        ],
      );
    },
  );
}

final String regexEmail =
    "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";

///[if not support fingerprint,then input password]
Future<String?> doAuth(
    BuildContext context, String currentAccountPubKey) async {
  String? password;
  bool supportBiometric = await checkBiometricAuth(context);
  bool isUseAuth = await LocalStorage.getUseBio(currentAccountPubKey);
  if (!isUseAuth) {
    password = await showPasswordDialog(context, currentAccountPubKey,
        isShowGoAuth: supportBiometric);
    return password;
  }
  password = await getPasswordWithBiometricAuth(context, currentAccountPubKey);
  if (password == null) {
    password = await showPasswordDialog(context, currentAccountPubKey);
  }

  return password;
}

Future<BiometricStorageFile> getBiometricPassStoreFile(
  BuildContext context,
  String pubKey,
) async {
  S dic = S.of(context);
  return BiometricStorage().getStorage(
    '$_biometricPasswordKey$pubKey',
    options: StorageFileInitOptions(authenticationValidityDurationSeconds: 30),
    promptInfo: PromptInfo(
      iosPromptInfo: IosPromptInfo(
        saveTitle: dic.unlock_bio,
        accessTitle: dic.unlock_bio,
      ),
      androidPromptInfo: AndroidPromptInfo(
        title: dic.unlock_bio,
        subtitle: '',
        description: '',
        negativeButton: dic.cancel,
      ),
    ),
  );
}

Future<String?> getPasswordWithBiometricAuth(
    BuildContext context, String pubKey) async {
  final supportBiometric = await checkBiometricAuth(context);
  bool isUseBioAuth = await LocalStorage.getUseBio(pubKey);
  if (supportBiometric) {
    final authStorage = await getBiometricPassStoreFile(context, pubKey);
    // we prompt biometric auth here if device supported
    // and user authorized to use biometric.
    if (isUseBioAuth) {
      try {
        final result = await authStorage.read();
        if (result != null) {
          return result;
        }
      } catch (err) {
        print(err);
      }
    }
  }
  return null;
}

/// Get transferable[num]
num getTransferable(AppStore store) {
  int decimals = store.settings!.networkState.tokenDecimals;
  String symbol = store.settings!.networkState.tokenSymbol;
  BalancesInfo balancesInfo = store.assets!.balances[symbol]!;
  String res = Fmt.token(balancesInfo.transferable, decimals);
  num transferable = num.parse(res.replaceAll(',', ''));
  return transferable;
}

String getTransferableToken(AppStore store) {
  int decimals = store.settings!.networkState.tokenDecimals;
  String symbol = store.settings!.networkState.tokenSymbol;
  BalancesInfo balancesInfo = store.assets!.balances[symbol]!;
  String res = Fmt.token(balancesInfo.transferable, decimals);
  return res;
}

///Compute aye rate
int computeAyeRate(DaoProposalModel data) {
  return int.parse((((data.ayesTotal * data.ico!.exchangeTokenTotalAmount) /
              (data.ico!.totalUnrealeaseAmount * data.ico!.totalIcoAmount)) *
          100)
      .toStringAsFixed(0));
}

///Compute nay rate
int computeNayRate(DaoProposalModel data) {
  return int.parse((((data.naysTotal * data.ico!.exchangeTokenTotalAmount) /
              (data.ico!.totalUnrealeaseAmount * data.ico!.totalIcoAmount)) *
          100)
      .toStringAsFixed(0));
}

debounce(Function func, Timer? _debounceTimer,
    {Duration delay = const Duration(seconds: 2)}) {
  _debounceTimer?.cancel();
  _debounceTimer = new Timer(delay, () {
    func.call();
  });
}

throttle(
  Future Function() func,
) {
  bool enable = true;
  Function target = () {
    if (enable == true) {
      enable = false;
      func().then((_) {
        enable = true;
      });
    }
  };
  return target;
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}

class FadeRouter<T> extends PageRouteBuilder<T> {
  final Widget child;
  final int durationMs;
  final Curve curve;
  FadeRouter(
      {required this.child,
      this.durationMs = 500,
      this.curve = Curves.fastOutSlowIn})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: Duration(milliseconds: durationMs),
          transitionsBuilder: (context, a1, a2, child) => FadeTransition(
            opacity: Tween(begin: 0.1, end: 1.0).animate(CurvedAnimation(
              parent: a1,
              curve: curve,
            )),
            child: child,
          ),
        );
}

Future<bool> checkBiometricAuth(BuildContext context) async {
  // final LocalAuthentication auth = LocalAuthentication();
  // List<BiometricType> availableBiometrics = [];
  final response = await BiometricStorage().canAuthenticate();
  bool supportBiometric = response == CanAuthenticateResponse.success;

  return supportBiometric;
}

Future<void> setBiometricAuth(
    BuildContext context, String pubKey, String? password) async {
  if (password == null) return;
  try {
    final authStorage = await getBiometricPassStoreFile(context, pubKey);
    await authStorage.write(password);

    await LocalStorage.setUseBio(true, pubKey);
  } catch (e) {
    print(e);
  }
}
