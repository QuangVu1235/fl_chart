import 'dart:math';
import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_data.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'bar_chart_extensions.dart';

import '../../utils/utils.dart';

/// Paints [BarChartData] in the canvas, it can be used in a [CustomPainter]
class TitleRightPainter extends AxisChartPainter<BarChartData> {
  late Paint _barPaint;

  TitleRightPainter(BarChartData data, BarChartData targetData, {double textScale = 1})
      : super(data, targetData, textScale: textScale) {
    _barPaint = Paint()..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    final canvasWrapper = CanvasWrapper(canvas, size);

    if (data.barGroups.isEmpty) {
      return;
    }
    _drawTitles(
      canvasWrapper,
    );
  }

  void _drawTitles(CanvasWrapper canvasWrapper) {
    final viewSize = canvasWrapper.size;
    final drawSize = getChartUsableDrawSize(viewSize);

    final rightTitles = targetData.titlesData.rightTitles;
    final rightInterval = rightTitles.interval ?? getEfficientInterval(viewSize.height, data.verticalDiff);
    var verticalSeek = data.minY;
    while (verticalSeek <= data.maxY) {
      if (verticalSeek == data.maxY || verticalSeek == data.maxY / 2 || verticalSeek == 0) {
        // var x = drawSize.width + getLeftOffsetDrawSize();
        var x = viewSize.width / 3;
        var y = getPixelY(verticalSeek, drawSize);

        final text = rightTitles.getTitles(verticalSeek);

        // final span = TextSpan(style: rightTitles.getTextStyles(verticalSeek), text: text);
        final span =
            TextSpan(style: TextStyle(fontSize: 12, color: Colors.black26, fontWeight: FontWeight.bold), text: text);
        final tp = TextPainter(
            text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr, textScaleFactor: textScale);
        tp.layout(maxWidth: viewSize.width);
        x += rightTitles.margin;
        y -= tp.height / 2;

        canvasWrapper.save();
        canvasWrapper.translate(x + tp.width / 2, y + tp.height / 2);
        canvasWrapper.rotate(radians(rightTitles.rotateAngle));
        canvasWrapper.translate(-(x + tp.width), -(y + tp.height / 2));
        y += translateRotatedPosition(tp.width, 0);

        canvasWrapper.drawText(tp, Offset(x, y));
        canvasWrapper.restore();
      }
      if (data.maxY - verticalSeek < rightInterval && data.maxY != verticalSeek) {
        verticalSeek = data.maxY;
      } else {
        verticalSeek += rightInterval;
      }
    }
  }

  /// We add our needed horizontal space to parent needed.
  /// we have some titles that maybe draw in the left and right side of our chart,
  /// then we should draw the chart a with some left space,
  /// the left space is [getLeftOffsetDrawSize],
  /// and the whole space is [getExtraNeededHorizontalSpace]
  @override
  double getExtraNeededHorizontalSpace() {
    var sum = super.getExtraNeededHorizontalSpace();
    if (data.titlesData.show) {
      final leftSide = data.titlesData.leftTitles;
      if (leftSide.showTitles) {
        sum += leftSide.reservedSize + leftSide.margin;
      }

      final rightSide = data.titlesData.rightTitles;
      if (rightSide.showTitles) {
        sum += rightSide.reservedSize + rightSide.margin;
      }
    }
    return sum;
  }

  /// We add our needed vertical space to parent needed.
  /// we have some titles that maybe draw in the top and bottom side of our chart,
  /// then we should draw the chart a with some top space,
  /// the top space is [getTopOffsetDrawSize()],
  /// and the whole space is [getExtraNeededVerticalSpace]
  @override
  double getExtraNeededVerticalSpace() {
    var sum = super.getExtraNeededVerticalSpace();
    if (data.titlesData.show) {
      final bottomSide = data.titlesData.bottomTitles;
      if (bottomSide.showTitles) {
        sum += bottomSide.reservedSize + bottomSide.margin;
      }

      final topSide = data.titlesData.topTitles;
      if (topSide.showTitles) {
        sum += topSide.reservedSize + topSide.margin;
      }
    }
    return sum;
  }

  /// calculate left offset for draw the chart,
  /// maybe we want to show both left and right titles,
  /// then just the left titles will effect on this function.
  @override
  double getLeftOffsetDrawSize() {
    var sum = super.getLeftOffsetDrawSize();

    final leftTitles = data.titlesData.leftTitles;
    if (data.titlesData.show && leftTitles.showTitles) {
      sum += leftTitles.reservedSize + leftTitles.margin;
    }

    return sum;
  }

  /// calculate top offset for draw the chart,
  /// maybe we want to show both top and bottom titles,
  /// then just the top titles will effect on this function.
  @override
  double getTopOffsetDrawSize() {
    var sum = super.getTopOffsetDrawSize();

    final topTitles = data.titlesData.topTitles;
    if (data.titlesData.show && topTitles.showTitles) {
      sum += topTitles.reservedSize + topTitles.margin;
    }

    return sum;
  }

  @override
  bool shouldRepaint(TitleRightPainter oldDelegate) => oldDelegate.data != data;
}

class _GroupBarsPosition {
  final double groupX;
  final List<double> barsX;

  _GroupBarsPosition(this.groupX, this.barsX);
}
