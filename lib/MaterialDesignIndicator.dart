import 'package:flutter/material.dart';

class MaterialDesignIndicator extends Decoration {
  final BoxPainter _painter;

  MaterialDesignIndicator({required Color indicatorColor, required double indicatorHeight})
      : _painter = _MaterialPainter(indicatorColor, indicatorHeight);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _MaterialPainter extends BoxPainter {
  final Paint _paint;
  final double indicatorHeight;

  _MaterialPainter(Color color, this.indicatorHeight)
      : _paint = Paint()
    ..color = color
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset indicatorOffset = offset + Offset(0, cfg.size!.height - indicatorHeight);
    final Rect indicatorRect = indicatorOffset & Size(cfg.size!.width, indicatorHeight);
    canvas.drawRRect(
      RRect.fromRectAndRadius(indicatorRect, Radius.circular(4)),
      _paint,
    );
  }
}
