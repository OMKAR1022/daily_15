import 'package:flutter/material.dart';

/// A utility class that provides size configuration for responsive UI
/// This class calculates sizes based on a reference design size
class SizeConfig {
  // Private constructor to prevent instantiation
  SizeConfig._();

  // Singleton instance
  static final SizeConfig _instance = SizeConfig._();

  // Factory constructor to return the singleton instance
  factory SizeConfig() => _instance;

  // Design size (based on iPhone X)
  static const Size _designSize = Size(375, 812);

  // Device screen size
  static late Size _screenSize;

  // Device pixel ratio
  static late double _pixelRatio;

  // Text scale factor
  static late double _textScaleFactor;

  // Safe area padding
  static late EdgeInsets _safeAreaPadding;

  // Initialize the size config
  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _screenSize = mediaQuery.size;
    _pixelRatio = mediaQuery.devicePixelRatio;
    _textScaleFactor = mediaQuery.textScaleFactor;
    _safeAreaPadding = mediaQuery.padding;
  }

  /// Returns the screen width
  static double get screenWidth => _screenSize.width;

  /// Returns the screen height
  static double get screenHeight => _screenSize.height;

  /// Returns the pixel ratio
  static double get pixelRatio => _pixelRatio;

  /// Returns the text scale factor
  static double get textScaleFactor => _textScaleFactor;

  /// Returns the safe area padding
  static EdgeInsets get safeAreaPadding => _safeAreaPadding;

  /// Returns the width scale factor
  static double get widthScaleFactor => _screenSize.width / _designSize.width;

  /// Returns the height scale factor
  static double get heightScaleFactor => _screenSize.height / _designSize.height;

  /// Returns the scaled width
  static double scaleWidth(double width) => width * widthScaleFactor;

  /// Returns the scaled height
  static double scaleHeight(double height) => height * heightScaleFactor;

  /// Returns the scaled text size
  static double scaleText(double size) => size * widthScaleFactor;

  /// Returns the scaled radius
  static double scaleRadius(double radius) => radius * widthScaleFactor;

  /// Returns the proportional width based on percentage
  static double proportionalWidth(double percentage) =>
      screenWidth * (percentage / 100);

  /// Returns the proportional height based on percentage
  static double proportionalHeight(double percentage) =>
      screenHeight * (percentage / 100);

  /// Returns the adaptive font size
  static double adaptiveFontSize(double size, {double? min, double? max}) {
    final scaledSize = scaleText(size);

    if (min != null && scaledSize < min) {
      return min;
    }

    if (max != null && scaledSize > max) {
      return max;
    }

    return scaledSize;
  }

  /// Returns the adaptive padding
  static EdgeInsets adaptivePadding({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? horizontal,
    double? vertical,
    double? all,
  }) {
    if (all != null) {
      final scaledValue = scaleWidth(all);
      return EdgeInsets.all(scaledValue);
    }

    if (horizontal != null || vertical != null) {
      return EdgeInsets.symmetric(
        horizontal: horizontal != null ? scaleWidth(horizontal) : 0,
        vertical: vertical != null ? scaleHeight(vertical) : 0,
      );
    }

    return EdgeInsets.only(
      left: left != null ? scaleWidth(left) : 0,
      top: top != null ? scaleHeight(top) : 0,
      right: right != null ? scaleWidth(right) : 0,
      bottom: bottom != null ? scaleHeight(bottom) : 0,
    );
  }

  /// Returns the adaptive margin
  static EdgeInsets adaptiveMargin({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? horizontal,
    double? vertical,
    double? all,
  }) {
    return adaptivePadding(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      horizontal: horizontal,
      vertical: vertical,
      all: all,
    );
  }

  /// Returns the adaptive border radius
  static BorderRadius adaptiveBorderRadius({
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
    double? all,
  }) {
    if (all != null) {
      final scaledValue = scaleRadius(all);
      return BorderRadius.circular(scaledValue);
    }

    return BorderRadius.only(
      topLeft: Radius.circular(
        topLeft != null ? scaleRadius(topLeft) : 0,
      ),
      topRight: Radius.circular(
        topRight != null ? scaleRadius(topRight) : 0,
      ),
      bottomLeft: Radius.circular(
        bottomLeft != null ? scaleRadius(bottomLeft) : 0,
      ),
      bottomRight: Radius.circular(
        bottomRight != null ? scaleRadius(bottomRight) : 0,
      ),
    );
  }
}

/// Extension methods for num to make it easier to use SizeConfig
extension SizeExtension on num {
  /// Returns the scaled width
  double get w => SizeConfig.scaleWidth(toDouble());

  /// Returns the scaled height
  double get h => SizeConfig.scaleHeight(toDouble());

  /// Returns the scaled text size
  double get sp => SizeConfig.scaleText(toDouble());

  /// Returns the scaled radius
  double get r => SizeConfig.scaleRadius(toDouble());

  /// Returns the proportional width
  double get pw => SizeConfig.proportionalWidth(toDouble());

  /// Returns the proportional height
  double get ph => SizeConfig.proportionalHeight(toDouble());
}
