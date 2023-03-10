import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_painter.dart';
import 'package:fl_chart/src/chart/bar_chart/title_right_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Renders a bar chart as a widget, using provided [BarChartData].
class BarChart extends ImplicitlyAnimatedWidget {
  /// Determines how the [BarChart] should be look like.
  final BarChartData data;

  final void Function(bool value)? onLoading;

  /// [data] determines how the [BarChart] should be look like,
  /// when you make any change in the [BarChartData], it updates
  /// new values with animation, and duration is [swapAnimationDuration].
  const BarChart(
    this.data, {
    Key? key,
    this.onLoading,
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
  }) : super(
          key: key,
          duration: swapAnimationDuration,
        );

  /// Creates a [_BarChartState]
  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends AnimatedWidgetBaseState<BarChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [BarChartData] to the new one.
  BarChartDataTween? _barChartDataTween;

  TouchHandler<BarTouchResponse>? _touchHandler;

  final GlobalKey _chartKey = GlobalKey();

  final Map<int, List<int>> _showingTouchedTooltips = {};

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("reach the bottom");
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("reach the top");
    }
  }
  bool? isMaxScrollExtent;

  @override
  Widget build(BuildContext context) {
    final showingData = _getData();
    final touchData = showingData.barTouchData;
    final size = MediaQuery.of(context).size;


    return LayoutBuilder(builder: (context, constraints) {
      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollStartNotification) {

          } else if (notification is ScrollUpdateNotification) {
            if (notification.metrics.pixels > notification.metrics.maxScrollExtent) {
              setState(() {
                isMaxScrollExtent = true;
              });
            }
            if (notification.metrics.pixels < 0) {
              setState(() {
                isMaxScrollExtent = false;
              });
            }
          } else if (notification is ScrollEndNotification) {
            if(isMaxScrollExtent != null){
              widget.onLoading?.call(isMaxScrollExtent!);
            }
          }
          debugPrint('${notification.metrics.pixels} ${notification.metrics.maxScrollExtent}');
          return true;
        },
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            // physics: _getData().barGroups.length <= 7 ? NeverScrollableScrollPhysics() : null,
            child: Container(
                decoration: BoxDecoration(
                    // border: Border(top: BorderSide()),
                    ),
                child: MouseRegion(
                  onEnter: (e) {
                    final chartSize = _getChartSize();
                    if (chartSize == null || _touchHandler == null) {
                      return;
                    }

                    final response = _touchHandler!.handleTouch(FlPanStart(e.localPosition), chartSize);
                    touchData.touchCallback?.call(response);
                  },
                  onExit: (e) {
                    final chartSize = _getChartSize();
                    if (chartSize == null || _touchHandler == null) {
                      return;
                    }

                    final response = _touchHandler!.handleTouch(
                        FlPanEnd(Offset.zero, const Velocity(pixelsPerSecond: Offset.zero)), chartSize);
                    touchData.touchCallback?.call(response);
                  },
                  onHover: (e) {
                    final chartSize = _getChartSize();
                    if (chartSize == null || _touchHandler == null) {
                      return;
                    }

                    final response = _touchHandler!.handleTouch(FlPanMoveUpdate(e.localPosition), chartSize);
                    touchData.touchCallback?.call(response);
                  },
                  child: GestureDetector(
                    onLongPressStart: (d) {
                      final chartSize = _getChartSize();
                      if (chartSize == null || _touchHandler == null) {
                        return;
                      }

                      final response = _touchHandler!.handleTouch(FlLongPressStart(d.localPosition), chartSize);
                      touchData.touchCallback?.call(response);
                    },
                    onLongPressEnd: (d) {
                      final chartSize = _getChartSize();
                      if (chartSize == null || _touchHandler == null) {
                        return;
                      }

                      final response = _touchHandler!.handleTouch(FlLongPressEnd(d.localPosition), chartSize);
                      touchData.touchCallback?.call(response);
                    },
                    onLongPressMoveUpdate: (d) {
                      final chartSize = _getChartSize();
                      if (chartSize == null || _touchHandler == null) {
                        return;
                      }

                      final response =
                          _touchHandler!.handleTouch(FlLongPressMoveUpdate(d.localPosition), chartSize);
                      touchData.touchCallback?.call(response);
                    },
                    onPanCancel: () {
                      final chartSize = _getChartSize();
                      if (chartSize == null || _touchHandler == null) {
                        return;
                      }

                      final response = _touchHandler!.handleTouch(
                          FlPanEnd(Offset.zero, const Velocity(pixelsPerSecond: Offset.zero)), chartSize);
                      touchData.touchCallback?.call(response);
                    },
                    onPanEnd: (DragEndDetails details) {
                      final chartSize = _getChartSize();
                      if (chartSize == null || _touchHandler == null) {
                        return;
                      }

                      final response =
                          _touchHandler!.handleTouch(FlPanEnd(Offset.zero, details.velocity), chartSize);
                      touchData.touchCallback?.call(response);
                    },
                    onPanDown: (DragDownDetails details) {
                      final chartSize = _getChartSize();
                      if (chartSize == null || _touchHandler == null) {
                        return;
                      }

                      final response = _touchHandler!.handleTouch(FlPanStart(details.localPosition), chartSize);
                      touchData.touchCallback?.call(response);
                    },
                    onPanUpdate: (DragUpdateDetails details) {
                      final chartSize = _getChartSize();
                      if (chartSize == null || _touchHandler == null) {
                        return;
                      }

                      final response =
                          _touchHandler!.handleTouch(FlPanMoveUpdate(details.localPosition), chartSize);
                      touchData.touchCallback?.call(response);
                    },
                    child: CustomPaint(
                      key: _chartKey,
                      size: getDefaultSize(Size(
                          double.infinity,
                          getWidth(context) > (size.height - constraints.maxHeight)
                              ? getWidth(context)
                              : (size.height - constraints.maxHeight))),
                      painter: BarChartPainter(
                        _withTouchedIndicators(_barChartDataTween!.evaluate(animation)),
                        _withTouchedIndicators(showingData),
                        (touchHandler) {
                          // print(touchHandler);
                          _touchHandler = touchHandler;
                        },
                        textScale: MediaQuery.of(context).textScaleFactor,
                      ),
                    ),
                  ),
                ))),
      );
    });
  }

  BarChartData _withTouchedIndicators(BarChartData barChartData) {
    if (!barChartData.barTouchData.enabled || !barChartData.barTouchData.handleBuiltInTouches) {
      return barChartData;
    }

    final newGroups = <BarChartGroupData>[];
    for (var i = 0; i < barChartData.barGroups.length; i++) {
      final group = barChartData.barGroups[i];

      newGroups.add(
        group.copyWith(
          showingTooltipIndicators: _showingTouchedTooltips[i],
        ),
      );
    }

    return barChartData.copyWith(
      barGroups: newGroups,
    );
  }

  Size? _getChartSize() {
    final containerRenderBox = _chartKey.currentContext?.findRenderObject();
    if (containerRenderBox == null || containerRenderBox is! RenderBox) {
      return null;
    }
    if (containerRenderBox.hasSize) {
      return containerRenderBox.size;
    }
    return null;
  }

  BarChartData _getData() {
    final barTouchData = widget.data.barTouchData;
    if (barTouchData.enabled && barTouchData.handleBuiltInTouches) {
      return widget.data.copyWith(
        barTouchData: widget.data.barTouchData.copyWith(touchCallback: _handleBuiltInTouch),
      );
    }
    return widget.data;
  }

  double getWidth(BuildContext context) {
    var widthBarRods = 0.0;
    widthBarRods = _getData().barGroups.map((e) => e.width).reduce((value, element) => value + element);
    widthBarRods = widthBarRods * 4.4;
    return widthBarRods;
  }

  void _handleBuiltInTouch(BarTouchResponse touchResponse) {
    widget.data.barTouchData.touchCallback?.call(touchResponse);

    if (touchResponse.touchInput is FlPanStart ||
        touchResponse.touchInput is FlPanMoveUpdate ||
        touchResponse.touchInput is FlLongPressStart ||
        touchResponse.touchInput is FlLongPressMoveUpdate) {
      setState(() {
        final spot = touchResponse.spot;
        if (spot == null) {
          _showingTouchedTooltips.clear();
          return;
        }
        final groupIndex = spot.touchedBarGroupIndex;
        final rodIndex = spot.touchedRodDataIndex;

        _showingTouchedTooltips.clear();
        _showingTouchedTooltips[groupIndex] = [rodIndex];
      });
    } else {
      setState(() {
        _showingTouchedTooltips.clear();
      });
    }
  }

  @override
  void forEachTween(visitor) {
    _barChartDataTween = visitor(
      _barChartDataTween,
      widget.data,
      (dynamic value) => BarChartDataTween(begin: value, end: widget.data),
    ) as BarChartDataTween;
  }
}
