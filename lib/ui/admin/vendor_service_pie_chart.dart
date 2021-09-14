import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';
import 'package:sewa/common/colors.dart';

import '../../backend_work/apis.dart';
import '../../common/converter.dart';

class VendorServicePieChart extends StatefulWidget {
  const VendorServicePieChart({Key? key}) : super(key: key);

  @override
  _VendorServicePieChartState createState() => _VendorServicePieChartState();
}

class _VendorServicePieChartState extends State<VendorServicePieChart> {
  // Data to render.
  Map<String, double> dataMap = {};

  List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
  ];

  getVendorService() async {
    var res = await http
        .post(Api.getData, body: {"get_data": "vendorService"});
    var data = jsonDecode(res.body);

    for (int i = 0; i <= data.length - 1; i++) {
      dataMap.addAll(
        {data[i]['name'].toString(): data[i]['services'].toString().toDouble()},
      );
    }
    if(mounted){
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getVendorService();
  }


  ChartType? _chartType = ChartType.disc;
  double? _chartLegendSpacing = 32;

  bool _showLegendsInRow = false;
  bool _showLegends = true;

  bool _showChartValueBackground = true;
  bool _showChartValues = true;
  bool _showChartValuesInPercentage = false;
  bool _showChartValuesOutside = false;

  LegendPosition? _legendPosition = LegendPosition.right;

  int key = 0;


  @override
  Widget build(BuildContext context) {

    final chart = dataMap.isNotEmpty ? PieChart(
      key: ValueKey(key),
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: _chartLegendSpacing!,
      chartRadius: 300,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: _chartType!,
      legendOptions: LegendOptions(
        showLegendsInRow: _showLegendsInRow,
        legendPosition: _legendPosition!,
        showLegends: _showLegends,
        legendTextStyle: TextStyle(
            color: MyColors.highlightColor
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: _showChartValueBackground,
        showChartValues: _showChartValues,
        showChartValuesInPercentage: _showChartValuesInPercentage,
        showChartValuesOutside: _showChartValuesOutside,
        chartValueBackgroundColor: MyColors.bgColor,
        decimalPlaces: 0,
      ),
    ) : Container(
      child: Center(child: CircularProgressIndicator(color: MyColors.highlightColor,)),
    );

    return chart;
  }
}
