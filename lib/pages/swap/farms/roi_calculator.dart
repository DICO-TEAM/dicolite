import 'package:decimal/decimal.dart';
import 'package:dicolite/config/config.dart';
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/farm_pool_extend_model.dart';
import 'package:dicolite/model/farm_pool_model.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/utils/UI.dart';
import 'package:dicolite/utils/adapt.dart';
import 'package:dicolite/utils/format.dart';
import 'package:dicolite/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

List<_Time> _timeList = [
  _Time("1D", 1),
  _Time("7D", 7),
  _Time("30D", 30),
  _Time("1Y", 365),
  _Time("5Y", 365 * 5),
];

class ROICalculator extends StatefulWidget {
  const ROICalculator(this.store, {this.farm, this.pool, Key? key})
      : super(key: key);
  final FarmPoolModel? farm;
  final FarmPoolExtendModel? pool;
  final AppStore store;
  @override
  _ROICalculatorState createState() => _ROICalculatorState();
}

class _ROICalculatorState extends State<ROICalculator> {
  TextEditingController _inputCtrl = TextEditingController(text: "10000");

  String outputShow = '';
  _Time _selectedTime = _timeList[3];
  String _rate = '';
  String _inputTokenAmount = '0';

  _computeProfit() {
    if (widget.farm != null) {
      _computeFarmProfit();
    } else if (widget.pool != null) {
      _computePoolProfit();
    }
  }

  _computeFarmProfit() {
    String input = _inputCtrl.text.trim();
    if (widget.farm == null) return;

    if (input.isEmpty) {
      setState(() {
        outputShow = '';
        _rate = '';
        _inputTokenAmount = '0';
      });
    } else {
      Decimal inputUsd = Decimal.parse(input);
      int blockDuration = widget.store.settings?.blockDuration ?? 0;
      String roiOneDay = widget.farm!.roiOneDay(
        widget.store.dico!.totalFarmRewardCurrentBlock,
        widget.store.dico!.totalFarmAllocPoint,
        widget.store.dico!.liquidityList ?? [],
        blockDuration,
      );

      if (roiOneDay == "~") {
        Navigator.of(context).pop();
        return;
      }

      Decimal rate =
          Decimal.parse(roiOneDay) * Decimal.fromInt(_selectedTime.days);
      Decimal? farmPoolUsd = widget.farm!.computefarmPoolAmountUsd(
        widget.store.dico!.liquidityList ?? [],
      );
      Decimal? inputTokenVal;
      if (farmPoolUsd != null && farmPoolUsd != Decimal.zero) {
        if (widget.farm!.isLP &&
            widget.farm!.liquidity!.totalIssuance != BigInt.zero) {
          Decimal ratio = Fmt.bigIntToDecimal(
                  widget.farm!.liquidity!.totalIssuance,
                  widget.farm!.poolDeciaml) /
              farmPoolUsd;
          inputTokenVal = ratio * inputUsd;
        } else if (!widget.farm!.isLP) {
          Decimal ratio = Fmt.bigIntToDecimal(
                  widget.farm!.totalAmount, widget.farm!.poolDeciaml) /
              farmPoolUsd;
          inputTokenVal = ratio * inputUsd;
        }
      }

      Decimal outVal = inputUsd * rate;
      if (inputTokenVal == null) {
        setState(() {
          outputShow =
              Fmt.doubleFormat(double.parse(Fmt.decimalFixed(outVal, 0))) +
                  " USD";
          _rate = Fmt.decimalFixed(rate * Decimal.fromInt(100), 1) + "%";
          _inputTokenAmount = '~';
        });

        return;
      }

      setState(() {
        outputShow =
            Fmt.doubleFormat(double.parse(Fmt.decimalFixed(outVal, 0))) +
                " USD";
        _rate = Fmt.decimalFixed(rate * Decimal.fromInt(100), 1) + "%";
        _inputTokenAmount = Fmt.decimalFixed(inputTokenVal!, 3);
      });
    }
  }

  _computePoolProfit() {
    String input = _inputCtrl.text.trim();
    if (widget.pool == null) return;
    if (input.isEmpty) {
      setState(() {
        outputShow = '';
        _rate = '';
        _inputTokenAmount = '0';
      });
    } else {
      Decimal inputUsd = Decimal.parse(input);
      int blockDuration = widget.store.settings?.blockDuration ?? 0;
      String roiOneDay = widget.pool!.roiOneDay(
        widget.store.dico!.liquidityList ?? [],
        blockDuration,
      );

      if (roiOneDay == "~") {
        Navigator.of(context).pop();
        return;
      }

      Decimal rate =
          Decimal.parse(roiOneDay) * Decimal.fromInt(_selectedTime.days);
      Decimal? farmPoolUsd = widget.pool!.computefarmPoolExtendAmountUsd(
        widget.store.dico!.liquidityList ?? [],
      );
      Decimal? inputTokenVal;
      if (farmPoolUsd != null && farmPoolUsd != Decimal.zero) {
        if (widget.pool!.isLP &&
            widget.pool!.stakeLiquidity!.totalIssuance != BigInt.zero) {
          Decimal ratio = Fmt.bigIntToDecimal(
                  widget.pool!.stakeLiquidity!.totalIssuance,
                  widget.pool!.stakeDecimals) /
              farmPoolUsd;
          inputTokenVal = ratio * inputUsd;
        } else if (!widget.pool!.isLP) {
          Decimal ratio = Fmt.bigIntToDecimal(
                  widget.pool!.totalStakeAmount, widget.pool!.stakeDecimals) /
              farmPoolUsd;
          inputTokenVal = ratio * inputUsd;
        }
      }

      Decimal outVal = inputUsd * rate;
      if (inputTokenVal == null) {
        setState(() {
          outputShow =
              Fmt.doubleFormat(double.parse(Fmt.decimalFixed(outVal, 0))) +
                  " USD";
          _rate = Fmt.decimalFixed(rate * Decimal.fromInt(100), 1) + "%";
          _inputTokenAmount = '~';
        });

        return;
      }

      setState(() {
        outputShow =
            Fmt.doubleFormat(double.parse(Fmt.decimalFixed(outVal, 0))) +
                " USD";
        _rate = Fmt.decimalFixed(rate * Decimal.fromInt(100), 1) + "%";
        _inputTokenAmount = Fmt.decimalFixed(inputTokenVal!, 3);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _computeProfit();
  }

  @override
  Widget build(BuildContext context) {
    S dic = S.of(context);
    return Scaffold(
      appBar: myAppBar(context, dic.ROICalculator),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            SizedBox(
              height: 15,
            ),
            Text(dic.staked),
            Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _inputCtrl,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.transparent,
                            filled: true,
                            hintText: "0",
                            isDense: true,
                          ),
                          inputFormatters: [
                            UI.decimalInputFormatter(Config.kUSDDecimals)
                          ],
                          onChanged: (v) {
                            _computeProfit();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text("USD"),
                      )
                    ],
                  ),
                  Text(
                    "≈ $_inputTokenAmount ${widget.farm?.symbol ?? widget.pool?.stakeSymbol}",
                    style: TextStyle(fontSize: Adapt.px(26)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(dic.stakedFor),
            Container(
              margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  color: Config.bgColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _timeList
                      .map(
                        (e) => ChoiceChip(
                          backgroundColor: Config.bgColor,
                          label: Container(
                              width: Adapt.px(70),
                              child: Center(child: Text(e.label))),
                          selected: _selectedTime.days == e.days,
                          onSelected: (bool v) {
                            if (!v) return;
                            setState(() {
                              _selectedTime = e;
                            });
                            _computeProfit();
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Center(
                  child: Icon(
                Icons.arrow_downward,
                color: Colors.grey.shade400,
              )),
            ),
            Text(dic.profit),
            Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      outputShow,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: Adapt.px(35),
                          ),
                    ),
                  ),
                  Text(
                    _rate,
                    style: TextStyle(fontSize: Adapt.px(26)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Time {
  String label;
  int days;
  _Time(this.label, this.days);
}
