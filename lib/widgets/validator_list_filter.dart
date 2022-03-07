import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dicolite/config/config.dart';


enum ValidatorSortOptions { staked, points, commission, judgements }

class ValidatorListFilter extends StatefulWidget {
  ValidatorListFilter(
      {required this.onFilterChange,required this.onSortChange, this.needSort = true});
  final Function(String) onFilterChange;
  final Function(int) onSortChange;
  final bool needSort;
  @override
  _ValidatorListFilterState createState() => _ValidatorListFilterState();
}

class _ValidatorListFilterState extends State<ValidatorListFilter> {
  ValidatorSortOptions _sort = ValidatorSortOptions.staked;

 String _getName(ValidatorSortOptions? val){
    if(val ==null)return "";
    switch (val) {
      case ValidatorSortOptions.staked:
      return S.of(context).staked;
      case ValidatorSortOptions.commission:
      return S.of(context).commission;
      case ValidatorSortOptions.judgements:
      return S.of(context).judgements;
      case ValidatorSortOptions.points:
      return S.of(context).points;
        
      default:
      return S.of(context).points;
    }
  }

  void _showActions() {
   
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: ValidatorSortOptions.values
            .map((i) => CupertinoActionSheetAction(
                  child: Text(_getName(i)),
                  onPressed: () {
                    setState(() {
                      _sort = i;
                    });
                    Navigator.of(context).pop();
                    widget.onSortChange(i.index);
                  },
                ))
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          child: Text(S.of(context).cancel),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var dic = S.of(context);
    var theme = Theme.of(context);
    return Container(
      color: theme.cardColor,
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: CupertinoTextField(
                clearButtonMode: OverlayVisibilityMode.editing,
                padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                placeholder: dic.filter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  border: Border.all(width: 0.5, color: theme.dividerColor),
                ),
                onChanged: (value) => widget.onFilterChange(value.trim()),
              ),
            ),
          ),
          widget.needSort
              ? Row(
                  children: <Widget>[
                    Text(dic.sort, style: TextStyle(fontSize: Adapt.px(30), color: Config.color999)),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(left: 8),
                        padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          border:
                              Border.all(width: 0.5, color: theme.dividerColor),
                        ),
                        child: Text(_getName(_sort), style: TextStyle(
                        fontSize: Adapt.px(30),
                        color: Config.color333
                      )),
                      ),
                      onTap: _showActions,
                    )
                  ],
                )
              : Container(height: 8)
        ],
      ),
    );
  }
}
