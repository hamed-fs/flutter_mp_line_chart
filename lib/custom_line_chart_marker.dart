import 'dart:ui';

import 'package:flutter/painting.dart';

import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/highlight/highlight.dart';
import 'package:mp_chart/mp/core/marker/i_marker.dart';
import 'package:mp_chart/mp/core/poolable/point.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';
import 'package:mp_chart/mp/core/utils/painter_utils.dart';
import 'package:mp_chart/mp/core/utils/utils.dart';
import 'package:mp_chart/mp/core/value_formatter/default_value_formatter.dart';

class CustomLineChartMarker implements IMarker {
  Entry _entry;
  double _dx;
  double _dy;

  DefaultValueFormatter _formatter;
  Color _textColor;
  Color _backColor;
  double _fontSize;

  CustomLineChartMarker({Color textColor, Color backColor, double fontSize, double dx, double dy})
      : _textColor = textColor,
        _backColor = backColor,
        _fontSize = fontSize,
        _dx = dx,
        _dy = dy {
    _formatter = DefaultValueFormatter(0);
    this._textColor ??= ColorUtils.PURPLE;
    this._backColor ??= ColorUtils.WHITE;
    this._fontSize ??= Utils.convertDpToPixel(10);
    this._dx ??= 0;
    this._dy ??= 0;
  }

  @override
  void draw(Canvas canvas, double posX, double posY) {
    TextPainter painter = PainterUtils.create(null, "${_formatter.getFormattedValue1(_entry.x)},${_formatter.getFormattedValue1(_entry.y)}", _textColor, _fontSize);
    Paint paint = Paint()
      ..color = _backColor
      ..strokeWidth = 2
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    MPPointF offset = getOffsetForDrawingAtPoint(posX, posY);

    canvas.save();
    painter.layout();
    Offset pos = calculatePos(posX + offset.x, posY + offset.y, painter.width, painter.height);
    canvas.drawRRect(RRect.fromLTRBR(pos.dx - 5, pos.dy - 5, pos.dx + painter.width + 5, pos.dy + painter.height + 5, Radius.circular(5)), paint);
    painter.paint(canvas, pos);
    canvas.restore();
  }

  Offset calculatePos(double posX, double posY, double textW, double textH) {
    return Offset(posX - textW / 2, posY - textH / 2);
  }

  @override
  MPPointF getOffset() {
    return MPPointF.getInstance1(_dx, _dy);
  }

  @override
  MPPointF getOffsetForDrawingAtPoint(double posX, double posY) {
    return getOffset();
  }

  @override
  void refreshContent(Entry e, Highlight highlight) {
    _entry = e;
    highlight = highlight;
  }
}
