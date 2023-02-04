import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample4 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartSample4State();
}

class BarChartSample4State extends State<BarChartSample4> {
  final Color dark = const Color(0xff3b8c75);
  final Color normal = const Color(0xff64caad);
  final Color light = const Color(0xff73e8c9);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceEvenly,
              barTouchData: BarTouchData(
                enabled: true,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) => const TextStyle(color: Color(0xff939393), fontSize: 10),
                  margin: 10,
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return '日';
                      case 1:
                        return '月';
                      case 2:
                        return '火';
                      case 3:
                        return '水';
                      case 4:
                        return '木';
                      case 5:
                        return '金';
                      case 6:
                        return '土';
                      default:
                        return '';
                    }
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: false,
                  getTextStyles: (value) =>
                  const TextStyle(
                      color: Color(
                        0xff939393,
                      ),
                      fontSize: 10),
                  margin: 0,
                ),
                rightTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) =>
                  const TextStyle(
                      color: Color(
                        0xff939393,
                      ),
                      fontSize: 10)
                ),
              ),
              gridData: FlGridData(
                show: false,
                drawVerticalLine: false,
                checkToShowHorizontalLine: (value) => value % 30 == 0,
                getDrawingHorizontalLine: (value) =>
                    FlLine(
                      color: const Color(0xffe7e8ec),
                      strokeWidth: 1,
                    ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              groupsSpace: 10,
              barGroups: getData(),
              isShowDash: true,
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> getData() {
    return [
      BarChartGroupData(
        x: 1,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 2000,
              colors: [ Colors.greenAccent, Colors.green],
              gradientFrom: Offset(0,1),
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 2000,
              colors: [ Colors.greenAccent, Colors.green],
              gradientFrom: Offset(0,1),
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 2000,
              colors: [ Colors.greenAccent, Colors.green],
              gradientFrom: Offset(0,1),
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 2000,
              colors: [ Colors.greenAccent, Colors.green],
              gradientFrom: Offset(0,1),
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 2000,
              colors: [ Colors.greenAccent, Colors.green],
              gradientFrom: Offset(0,1),
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 2000,
              colors: [ Colors.greenAccent, Colors.green],
              gradientFrom: Offset(0,1),
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 2000,
              colors: [ Colors.greenAccent, Colors.green],
              gradientFrom: Offset(0,1),
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 3000,
              colors: [ Colors.greenAccent, Colors.green],
              gradientFrom: Offset(0,1),
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 6000,
              colors: [ Colors.greenAccent, Colors.green],
              gradientFrom: Offset(0,1),
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 4,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 5000,
              colors: [ Colors.greenAccent, Colors.green],
              gradientFrom: Offset(0,1),
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 5,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 6000,
              colors: [ Colors.greenAccent, Colors.green],
              gradientFrom: Offset(0,1),
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 6,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 7000,
              colors: [ Colors.greenAccent, Colors.green],
              gradientFrom: Offset(0,1),
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
    ];
  }
}
