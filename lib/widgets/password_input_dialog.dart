import 'package:dicolite/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:flutter/material.dart';


class PasswordInputDialog extends StatefulWidget {
  PasswordInputDialog({required this.title,required this.onOk});

  final Widget title;
  final Function(String) onOk;

  @override
  _PasswordInputDialog createState() =>
      _PasswordInputDialog(title: title, onOk: onOk);
}

class _PasswordInputDialog extends State<PasswordInputDialog> {
  _PasswordInputDialog({required this.title,required this.onOk});

  final Widget title;
  final Function(String) onOk;

  final TextEditingController _passCtrl = new TextEditingController();

  Future<void> _onOk(String password) async {
    var res = await webApi!.account?.checkAccountPassword(password);
    if (res == null) {
      final S dic = S.of(context);
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(dic.pass_error),
            content: Text(dic.pass_error_txt),
            actions: <Widget>[
              CupertinoButton(
                child: Text(S.of(context).ok),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    } else {
      onOk(password);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final S dic = S.of(context);

    return CupertinoAlertDialog(
      title: title ,
      content: Padding(
        padding: EdgeInsets.only(top: 16),
        child: CupertinoTextField(
          placeholder: S.of(context).pass_old,
          controller: _passCtrl,
          // onChanged: (v) {
          //    Fmt.checkPassword(v!.trim())
          //       ? null
          //       : S.of(context).create_password_error;
          // },
          obscureText: true,
          clearButtonMode: OverlayVisibilityMode.editing,
        ),
      ),
      actions: <Widget>[
        CupertinoButton(
          child: Text(dic.cancel,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        CupertinoButton(
          child: Text(dic.ok),
          onPressed: () => _onOk(_passCtrl.text.trim()),
        ),
      ],
    );
  }
}
