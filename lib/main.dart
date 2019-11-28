import 'package:flutter/material.dart';

import 'package:flutter_mp_line_chart/line_chart_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MP Flutter Chart Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('MP Flutter Chart Demo'),
        ),
        body: LineChartPage(),
      ),
    );
  }
}
