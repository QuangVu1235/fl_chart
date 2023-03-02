import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample4 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartSample4State();
}

class BarChartSample4State extends State<BarChartSample4> {
  final Color dark = const Color(0xff6ac434);
  final Color light = const Color(0x996ac434);

  int touchedIndex;

  List<int> listData = [10000, 12000, 14000, 16000, 18000, 20000, 22000];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: BarChart(
              BarChartData(
                isShowDash: true,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.blueGrey,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                            (rod.y).toString() + '歩',
                            TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ));
                      }),
                  touchCallback: (barTouchResponse) {
                    setState(() {
                      if (barTouchResponse.spot != null &&
                          barTouchResponse.touchInput is! FlPanEnd &&
                          barTouchResponse.touchInput is! FlLongPressEnd) {
                        touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
                      } else {
                        touchedIndex = -1;
                      }
                    });
                  },
                ),
                alignment: BarChartAlignment.spaceEvenly,
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
                  topTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (value) => const TextStyle(color: Color(0xff939393), fontSize: 10),
                    margin: 20,
                    // getTitles: (double value) {
                    //   switch (value.toInt()) {
                    //     case 0:
                    //       return '日';
                    //     case 1:
                    //       return '月';
                    //     case 2:
                    //       return '火';
                    //     case 3:
                    //       return '水';
                    //     case 4:
                    //       return '木';
                    //     case 5:
                    //       return '金';
                    //     case 6:
                    //       return '土';
                    //     default:
                    //       return '';
                    //   }
                    // },
                  ),
                  leftTitles: SideTitles(
                    showTitles: false,
                    getTextStyles: (value) => const TextStyle(
                        color: Color(
                          0xff939393,
                        ),
                        fontSize: 10),
                    margin: 0,
                  ),
                  rightTitles: SideTitles(
                      showTitles: false,
                      getTitles: (double value) {
                        return value.toString();
                      },
                      getTextStyles: (value) => const TextStyle(
                          color: Color(
                            0xff939393,
                          ),
                          fontSize: 10)),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                groupsSpace: 10,
                barGroups: getData(MediaQuery.of(context).size.width * 0.039, touchedIndex),
              ), onLoading: (value) {
            if (value) {
              if (listData.length < 40) {
                setState(() {
                  listData = [...listData, ...listData];
                });
              }
            }
            debugPrint('onLoading: $value');
          }),
        ),
      ),
    );
  }

  List<BarChartGroupData> getData(
    double context,
    int touchedIndex,
  ) {
    return List.generate(
        listData.length,
        (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                    y: listData[index].toDouble(),
                    width: listData.length > 20 ? context - 10 : context,
                    colors: index == touchedIndex ? [Colors.red, Colors.amber] : [Colors.greenAccent, Colors.green],
                    gradientFrom: Offset(0, 1),
                    borderRadius: const BorderRadius.all(Radius.zero)),
              ],
            ));
  }
}
