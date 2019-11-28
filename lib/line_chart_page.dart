import 'dart:math';
import 'package:flutter/material.dart';

import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/core/adapter_android_mp.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/enums/legend_form.dart';
import 'package:mp_chart/mp/core/enums/limite_label_postion.dart';
import 'package:mp_chart/mp/core/enums/mode.dart';
import 'package:mp_chart/mp/core/enums/x_axis_position.dart';
import 'package:mp_chart/mp/core/image_loader.dart';
import 'package:mp_chart/mp/core/limit_line.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';

class LineChartPage extends StatefulWidget {
  @override
  LineChartBasicState createState() => LineChartBasicState();
}

class LineChartBasicState extends State<LineChartPage> {
  static const double MAX_VISIBLE_AREA = 80;

  final List<Entry> values = List<Entry>();
  LineChartController _controller;

  void _getInitialData() {
    int _count = 3;

    for (int i = 0; i < _count; i++) {
      values.add(Entry(x: i.toDouble(), y: generateNextRandomValue(25, 5)));
    }
  }

  Stream<Entry> createDataTimesStream() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      var image = await ImageLoader.loadImage('assets/img/flag.png');

      yield Entry(x: (values.length).toDouble(), y: generateNextRandomValue((values[values.length - 1].y).toDouble(), 5), icon: values.length % 10 == 0 ? image : null);
    }
  }

  Stream<Entry> dataStream;

  @override
  void initState() {
    _getInitialData();

    _initController();
    _initLineData();

    dataStream = createDataTimesStream();

    dataStream.listen((data) {
      setState(() {
        values.add(data);

        _initialLimitLines();
        _initLineData();

        // _controller.setVisibleXRangeMaximum(MAX_VISIBLE_AREA);
        // _controller.moveViewToX(values.length - MAX_VISIBLE_AREA + 1);
      });
    });

    super.initState();
  }

  Widget getBody() {
    return Stack(
      children: <Widget>[
        Positioned(
          right: 0,
          left: 0,
          top: 0,
          bottom: 100,
          child: _initLineChart(),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 50,
          child: Center(child: Text('Dataset size: ${values.length}')),
        )
      ],
    );
  }

  LimitLine limitLineMax;
  LimitLine limitLineMin;
  LimitLine barrier;

  void _initController() {
    Description desc = Description()..enabled = false;

    _initialLimitLines();

    _controller = LineChartController(
      axisLeftSettingFunction: (axisLeft, controller) {
        axisLeft
          ..drawLimitLineBehindData = false
          // ..drawGridLines = false
          // ..setLabelCount1(6)
          ..gridLineWidth = 0.3
          ..gridColor = Colors.grey
          ..addLimitLine(limitLineMax)
          ..addLimitLine(limitLineMin)
          ..addLimitLine(barrier)
          ..setAxisMaximum(values.map<double>((value) => value.y).reduce(max) + 10)
          ..setAxisMinimum(values.map<double>((value) => value.y).reduce(min) - 10);
      },
      axisRightSettingFunction: (axisRight, controller) {
        axisRight.enabled = (false);
      },
      legendSettingFunction: (legend, controller) {
        legend.shape = (LegendForm.SQUARE);
      },
      xAxisSettingFunction: (xAxis, controller) {
        xAxis
          ..drawLimitLineBehindData = false
          ..gridLineWidth = 0.3
          ..gridColor = Colors.grey
          // ..drawGridLines = false
          // ..setLabelCount1(6)
          ..centerAxisLabels = true
          ..position = XAxisPosition.BOTTOM;
      },
      drawGridBackground: false,
      backgroundColor: ColorUtils.WHITE,
      dragXEnabled: true,
      dragYEnabled: false,
      scaleXEnabled: true,
      scaleYEnabled: false,
      pinchZoomEnabled: true,
      description: desc,
    );
  }

  void _initialLimitLines() {
    limitLineMax = LimitLine(values.map<double>((value) => value.y).reduce(max) + 5, 'Upper Limit')
      ..setLineWidth(2)
      ..enableDashedLine(15, 5, 0)
      ..lineColor = Colors.green
      ..labelPosition = (LimitLabelPosition.RIGHT_TOP)
      ..textSize = (10)
      ..typeface = TypeFace(fontFamily: "OpenSans", fontWeight: FontWeight.w800);

    limitLineMin = LimitLine(values.map<double>((value) => value.y).reduce(min) - 5, 'Lower Limit')
      ..setLineWidth(2)
      ..enableDashedLine(15, 5, 0)
      ..lineColor = Colors.red
      ..labelPosition = (LimitLabelPosition.RIGHT_BOTTOM)
      ..textSize = (10)
      ..typeface = TypeFace(fontFamily: "OpenSans", fontWeight: FontWeight.w800);

    barrier = LimitLine(values.map<double>((value) => value.y).last, 'Barrier ${values.map<double>((value) => value.y).last}')
      ..setLineWidth(2)
      ..enableDashedLine(2, 1, 0)
      ..lineColor = Colors.blueGrey
      ..labelPosition = (LimitLabelPosition.RIGHT_TOP)
      ..textSize = (10)
      ..typeface = TypeFace(fontFamily: "OpenSans", fontWeight: FontWeight.w800);
  }

  void _initLineData() async {
    LineDataSet dataset;

    dataset = LineDataSet(values, 'Data Set')
      ..setDrawIcons(true)
      ..setColor1(Colors.black.withOpacity(0.6))
      ..setCircleColor(Colors.black.withOpacity(0.6))
      ..setHighLightColor(ColorUtils.BLACK)
      ..setLineWidth(2)
      ..setCircleRadius(2.5)
      ..setDrawCircleHole(false)
      ..setDrawCircles(true)
      ..setFormLineWidth(1)
      ..setFormSize(15)
      ..setDrawValues(false)
      ..setValueTextSize(9)
      ..enableDashedHighlightLine(1, 1, 0)
      ..setDrawFilled(false)
      ..setFillColor(Colors.white)
      ..setMode(Mode.LINEAR)
      ..setDrawHorizontalHighlightIndicator(true)
      ..setDrawVerticalHighlightIndicator(true)
      ..setCircleHoleColor(Colors.white)
      ..setCircleHoleRadius(1)
      ..setDrawHighlightIndicators(true);

    _controller.data = LineData.fromList([dataset]);
  }

  Widget _initLineChart() {
    return LineChart(_controller..animator.reset());
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }
}

double generateNextRandomValue(double currentValue, int maxGap) {
  return Random().nextBool() ? currentValue + Random().nextInt(maxGap) : currentValue - Random().nextInt(maxGap);
}
