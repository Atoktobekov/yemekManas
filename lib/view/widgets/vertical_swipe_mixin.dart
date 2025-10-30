import 'package:flutter/material.dart';

mixin VerticalPageSwipeHandler<T extends StatefulWidget> on State<T> {
  double _dragStartY = 0.0;
  double _dragCurrentY = 0.0;
  bool _isAnimating = false;

  static const double edgeZone = 235.0;
  static const double distanceThreshold = 120.0;
  static const double velocityThreshold = 700.0;

  void onDragStart(DragStartDetails details) {
    _dragStartY = details.globalPosition.dy;
    _dragCurrentY = _dragStartY;
  }

  void onDragUpdate(DragUpdateDetails details) {
    _dragCurrentY = details.globalPosition.dy;
  }

  /// Возвращает номер целевой страницы или null, если не нужно листать
  int? onDragEnd(
      DragEndDetails details,
      int currentPage,
      int pageCount,
      BuildContext context,
      ) {
    if (_isAnimating) return null;

    final height = MediaQuery.of(context).size.height;
    final delta = _dragCurrentY - _dragStartY;
    final vy = details.velocity.pixelsPerSecond.dy;

    final startedAtTopEdge = _dragStartY < edgeZone;
    final startedAtBottomEdge = _dragStartY > height - edgeZone;

    int targetPage = currentPage;

    if (vy.abs() > velocityThreshold) {
      targetPage = vy > 0 ? currentPage - 1 : currentPage + 1;
    } else if (delta > distanceThreshold && startedAtTopEdge) {
      targetPage = currentPage - 1;
    } else if (delta < -distanceThreshold && startedAtBottomEdge) {
      targetPage = currentPage + 1;
    }

    targetPage = targetPage.clamp(0, pageCount - 1);
    if (targetPage == currentPage) return null;

    return targetPage;
  }

  Future<void> animateToPage(
      PageController controller,
      int page,
      ) async {
    _isAnimating = true;
    try {
      await controller.animateToPage(
        page,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeOutCubic,
      );
    } finally {
      _isAnimating = false;
    }
  }
}
