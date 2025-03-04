import 'dart:ui';

/// Used to calculate device independent pixels.
class Dip {
  /// Creates a device independent pixel calculator.
  ///
  /// [designWidth] and [designHeight] are the width and height
  /// of the designs viewport respectively.
  const Dip({required this.designWidth, required this.designHeight});

  /// The width of the design's viewport in pixels.
  final double designWidth;

  /// The height of the design's viewport in pixels.
  final double designHeight;

  /// If the design is in landscape orientation.
  bool get designLandscape => designWidth > designHeight;

  /// Calculates device independent pixels.
  ///
  /// The [designPixels] are the length in pixels specified in the design.
  double call(double designPixels) {
    final PlatformDispatcher platformDispatcher = PlatformDispatcher.instance;
    final FlutterView view = platformDispatcher.views.first;
    final Size pSize = view.physicalSize;

    return (designPixels * pSize.height) /
        (designHeight * view.devicePixelRatio);
  }
}