import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
class PieChartShow extends StatelessWidget {
  //const PieChartShow({Key? key}) : super(key: key);
  late TooltipBehavior  _tooltipBehavior = TooltipBehavior(enable: true);
  @override
  Widget build(BuildContext context) {
    return _buildCharts(context,getChartData());
  }
  _buildCharts(BuildContext context, List<ChartData> posts) {
    return
        SfCircularChart(
        backgroundColor: Colors.white,
        title: ChartTitle(text: 'This Month Attendace'),
        tooltipBehavior: _tooltipBehavior,
        legend:Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
        series: <CircularSeries>[
          PieSeries<ChartData, String>(
              dataSource: posts,
              xValueMapper: (ChartData data, _) => data.name,
              yValueMapper: (ChartData data, _) => data.percent,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              enableTooltip: true)
        ],
        // ),
        // )
      );
  }
  List<ChartData> getChartData() {
    final List<ChartData> chartData = [
      ChartData('Present Day', 20),
      ChartData('Absent Day', 5),
      ChartData('Holliday', 5),

    ];
    return chartData;
  }
}
class ChartData {
  final String name;
  final double percent;
  ChartData(this.name, this.percent);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'dataname': name,
      'data': percent,
    };
    return map;
  }
  factory ChartData.fromMap(Map data) {
    return ChartData(
      data["dataname"] as String,
      data["data"] as double,
    );}
}