import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/my_utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';

import 'package:dicolite/utils/loading.dart';
import 'package:dicolite/widgets/account_advance_option.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:dicolite/widgets/rounded_button.dart';

import '../../../home.dart';

class BackupAccountPage extends StatefulWidget {
  const BackupAccountPage(this.store);

  static final String route = '/me/createAccount/backup';
  final AppStore store;

  @override
  _BackupAccountPageState createState() => _BackupAccountPageState(store);
}

class _BackupAccountPageState extends State<BackupAccountPage> {
  _BackupAccountPageState(this.store);

  final AppStore store;

  AccountAdvanceOptionParams _advanceOptions = AccountAdvanceOptionParams();
  int _step = 0;

  List<String> _wordsSelected = [];
  List<String> _wordsLeft = [];

  Future<void> _importAccount(
      bool useBiometricAuthorizen, String password) async {
    Loading.showLoading(context);
    var acc = await webApi!.account!.importAccount(
      cryptoType:
          _advanceOptions.type ?? AccountAdvanceOptionParams.encryptTypeSR,
      derivePath: _advanceOptions.path ?? '',
    );

    if (acc == null || acc['error'] != null) {
      UI.alertWASM(context, () {
        setState(() {
          _step = 0;
        });
      });
      return;
    }
    await webApi!.account!.saveAccount(acc);
    Loading.hideLoading(context);
    if (useBiometricAuthorizen) {
      await setBiometricAuth(context, acc["pubKey"], password);
    }
    if (store.account?.accountList.length != null &&
        store.account!.accountList.length > 1) {
      Navigator.popUntil(context, ModalRoute.withName(Home.route));
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Home.route, (route) => false);
    }
  }

  @override
  void initState() {
    webApi!.account!.generateAccount();
    super.initState();
  }

  Widget _buildStep0(BuildContext context) {
    final S dic = S.of(context);

    return Observer(
      builder: (_) => Scaffold(
        appBar: myAppBar(context, S.of(context).create),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(top: 16),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        dic.create_warn3,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        dic.create_warn4,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black12,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Text(
                        store.account!.newAccount.key,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    AccountAdvanceOption(
                      seed: store.account!.newAccount.key,
                      onChange: (data) {
                        setState(() {
                          _advanceOptions = data;
                        });
                      },
                    ),
                  ],
                ),
              ),
              store.account!.newAccount.key.isNotEmpty
                  ? Container(
                      padding: EdgeInsets.all(16),
                      child: RoundedButton(
                        backgroundColor: Config.secondColor,
                        text: S.of(context).copy,
                        onPressed: () =>
                            copy(context, store.account!.newAccount.key),
                      ),
                    )
                  : Container(),
              Container(
                padding: EdgeInsets.all(16),
                child: RoundedButton(
                  text: S.of(context).next,
                  onPressed: () {
                    if (_advanceOptions.error ?? false) return;
                    setState(() {
                      _step = 1;
                      _wordsSelected = <String>[];
                      _wordsLeft = store.account!.newAccount.key.split(' ');
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep1(BuildContext context) {
    final S dic = S.of(context);

    List list = ModalRoute.of(context)!.settings.arguments as List;
    bool useBiometricAuthorizen = list[0];
    String password = list[1];

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).create),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Image.asset(
            'assets/images/dico/back.png',
            width: 11,
          ),
          onPressed: () {
            setState(() {
              _step = 0;
            });
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  Text(
                    dic.backup,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      dic.backup_confirm,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            dic.backup_reset,
                            style: TextStyle(
                                fontSize: Adapt.px(30), color: Colors.pink),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _wordsLeft =
                                store.account!.newAccount.key.split(' ');
                            _wordsSelected = [];
                          });
                        },
                      )
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black12,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      _wordsSelected.join(' '),
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  _buildWordsButtons(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: RoundedButton(
                text: S.of(context).next,
                onPressed:
                    _wordsSelected.join(' ') == store.account!.newAccount.key
                        ? () => _importAccount(useBiometricAuthorizen, password)
                        : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordsButtons() {
    if (_wordsLeft.length > 0) {
      _wordsLeft.sort();
    }

    List<Widget> rows = <Widget>[];
    for (var r = 0; r * 3 < _wordsLeft.length; r++) {
      if (_wordsLeft.length > r * 3) {
        rows.add(Row(
          children: _wordsLeft
              .getRange(
                  r * 3,
                  _wordsLeft.length > (r + 1) * 3
                      ? (r + 1) * 3
                      : _wordsLeft.length)
              .map(
                (i) => Container(
                  margin: EdgeInsets.all(8),
                  child: ElevatedButton(
                    child: Text(
                      i,
                    ),
                    onPressed: () {
                      setState(() {
                        _wordsLeft.remove(i);
                        _wordsSelected.add(i);
                      });
                    },
                  ),
                ),
              )
              .toList(),
        ));
      }
    }
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        children: rows,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_step) {
      case 0:
        return _buildStep0(context);
      case 1:
        return _buildStep1(context);
      default:
        return Container();
    }
  }
}
