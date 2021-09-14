import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:http/http.dart' as http;
import 'package:sewa/common/colors.dart';
import '../../common/converter.dart';
import '../../backend_work/apis.dart';



class VendorUserPieChart extends StatefulWidget {
  const VendorUserPieChart({Key? key}) : super(key: key);

  @override
  _VendorUserPieChartState createState() => _VendorUserPieChartState();
}

class _VendorUserPieChartState extends State<VendorUserPieChart> {

  // Data to render.
  Map<String, double> dataMap = {};

  List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
  ];

  getVendorUser() async {
    var res = await http.post(Api.getData, body: {
      "get_data": "vendorUser"
    });
    var data = jsonDecode(res.body);

    for (int i = 0; i <= data.length - 1; i++) {
      dataMap.addAll({
        data[i]['user_type'] == '1' ? 'Vendors' : 'Users':
        data[i]['numbers'].toString().toDouble(),
      });
    }
    if(mounted){
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getVendorUser();
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
    // final _colorPalettes = charts.MaterialPalette.getOrderedPalettes(_data.length);

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
