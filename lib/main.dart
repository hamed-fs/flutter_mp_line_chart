import 'package:flutter/material.dart';

import 'package:flutter_mp_line_chart/line_chart_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LineChartPage(title: 'Flutter Demo Home Page'),
    );
  }
}
