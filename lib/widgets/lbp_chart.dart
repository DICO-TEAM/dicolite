import 'package:charts_flutter/flutter.dart' as charts;
import 'package:dicolite/generated/l10n.dart';
import 'package:dicolite/model/lbp_model.dart';
import 'package:dicolite/model/lbp_price_history_model.dart';
import 'package:dicolite/service/substrate_api/api.dart';
import 'package:dicolite/store/app.dart';
import 'package:dicolite/widgets/loading_widget.dart';
import 'package:dicolite/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LbpChart extends StatefulWidget {
  LbpChart(this.lbp, this.store);
  final LbpModel lbp;
  final AppStore store;

  @override
  _LbpChartState createState() => _LbpChartState(this.store);
}

class _LbpChartState extends State<LbpChart> {
  _LbpChartState(this.store);
  List<LbpPriceHistoryModel>? priceList;
  List<charts.Series<dynamic, DateTime>>? seriesList;

  AppStore store;
  DateTime? _timeSelect;
  double? _dataSelect;
  List<num> viewport = [];

  // Listens to the underlying selection changes, and updates the information
  // relevant to building the primitive legend like information under the
  // chart.
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    setState(() {
      _dataSelect = null;
      if (selectedDatum.isNotEmpty) {
        _timeSelect = selectedDatum.first.datum.time;
        _dataSelect = selectedDatum.first.datum.price;
      }
    });
  }

  Future _getData() async {
    List? res = await webApi?.dico?.fetchLbpPriceHistory(widget.lbp.lbpId);
    if (res != null && mounted) {
      int blockTime = widget.store.settings?.blockDuration ?? 0;
      int nowBlock = store.dico?.newHeads?.number ?? 0;

      DateTime nowTime = DateTime.now();

      priceList = res
          .map((e) => LbpPriceHistoryModel.fromList(
              e as List, widget.lbp, blockTime, nowBlock, nowTime))
          .toList();
      if (priceList != null && priceList!.isNotEmpty) {
        List<double> prices = priceList!.map((e) => e.price).toList();

        prices.sort();
        double val=(prices.last-prices.first)/6;
        setState(() {
          viewport = [prices.first-val, prices.last];
        });
      }

      setState(() {
        seriesList = _createData(priceList!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  /// Create data.
  List<charts.Series<TimeSeriesPrice, DateTime>> _createData(
      List<LbpPriceHistoryModel> list) {
    final data = list.map((e) => new TimeSeriesPrice(e.time, e.price)).toList();
    Color primaryColor = Theme.of(context).primaryColor;
    return [
      new charts.Series<TimeSeriesPrice, DateTime>(
        id: 'Price',
        colorFn: (_, __) => charts.Color(
          r: primaryColor.red,
          b: primaryColor.blue,
          g: primaryColor.green,
          a: primaryColor.alpha,
        ),
        domainFn: (TimeSeriesPrice sales, _) => sales.time,
        measureFn: (TimeSeriesPrice sales, _) => sales.price,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (priceList == null) {
      return LoadingWidget();
    }
    return Container(
      padding: EdgeInsets.all(8),
      color: Color(0xFFF5F5F5),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Text(widget.lbp.afsToken.symbol+" "+S.of(context).priceChanges),
            Expanded(
              child: priceList!.isEmpty
                  ? NoData()
                  : Stack(
                      children: [
                        new charts.TimeSeriesChart(
                          seriesList!,
                          animate: true,
                          // Configures an axis spec that is configured to render one tick at each
                          // end of the axis range, anchored "inside" the axis. The start tick label
                          // will be left-aligned with its tick mark, and the end tick label will be
                          // right-aligned with its tick mark.

                          selectionModels: [
                            new charts.SelectionModelConfig(
                              type: charts.SelectionModelType.info,
                              changedListener: _onSelectionChanged,
                            )
                          ],
                          primaryMeasureAxis: new charts.NumericAxisSpec(
                            viewport: viewport.isNotEmpty
                                ? charts.NumericExtents(
                                    viewport[0], viewport[1])
                                : null,
                            showAxisLine: false,
                            renderSpec: new charts.GridlineRendererSpec(
                             
                              tickLengthPx: 0, 
                            
                              labelStyle: charts.TextStyleSpec(
                               
                                color: charts.Color.fromHex(code: '#999999'),
                              ),
                              axisLineStyle: charts.LineStyleSpec(
                               
                                color: charts.Color.fromHex(code: '#EEEEEE'),
                              ),
                              lineStyle: charts.LineStyleSpec(
                               
                                color: charts.Color.fromHex(code: '#EEEEEE'),
                              ),
                            ),
                          ),
                          domainAxis: new charts.EndPointsTimeAxisSpec(
                            // renderSpec:,
                            
                            renderSpec: charts.SmallTickRendererSpec(
                             
                              tickLengthPx: 0,
                             
                              labelStyle: charts.TextStyleSpec(
                              
                                color: charts.Color.fromHex(code: '#999999'),
                              ),
                              axisLineStyle: charts.LineStyleSpec(
                               
                                color: charts.Color.fromHex(code: '#CCCCCC'),
                              ),
                            ),
                          ),
                        ),
                        _dataSelect != null && _timeSelect != null
                            ? Positioned(
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  color: Color.fromRGBO(0, 0, 0, 0.3),
                                  width: 200.0,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        DateFormat("yyyy-MM-dd HH:mm")
                                            .format(_timeSelect!),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        "$_dataSelect ${widget.lbp.fundraisingToken.symbol}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ))
                            : Container(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sample time series data type.
class TimeSeriesPrice {
  final DateTime time;
  final double price;

  TimeSeriesPrice(this.time, this.price);
}
