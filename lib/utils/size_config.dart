import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Orientation orientation;

  // Design dimensions (based on Figma design or reference device)
  static const double designWidth = 375;
  static const double designHeight = 812;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;

    // Initialize default size based on orientation
    defaultSize = orientation == Orientation.landscape
        ? screenHeight * 0.024
        : screenWidth * 0.024;
  }

  // Get the proportional height as per design
  static double getProportionateScreenHeight(double inputHeight) {
    return (inputHeight / designHeight) * screenHeight;
  }

  // Get the proportional width as per design
  static double getProportionateScreenWidth(double inputWidth) {
    return (inputWidth / designWidth) * screenWidth;
  }

  // Get proportional size for both width and height
  static double getProportionateScreenSize(double inputSize) {
    return (inputSize / designWidth) * screenWidth;
  }

  // Check if the device is a tablet
  static bool get isTablet => screenWidth >= 600;

  // Check if the device is a phone
  static bool get isPhone => screenWidth < 600;
}

// Extension methods for easier usage
extension SizeExtension on num {
  // For width
  double get w => SizeConfig.getProportionateScreenWidth(toDouble());

  // For height
  double get h => SizeConfig.getProportionateScreenHeight(toDouble());

  // For font size or general size (radius, padding, etc.)
  double get sp => SizeConfig.getProportionateScreenSize(toDouble());

  // For radius, padding, margin, etc.
  double get r => SizeConfig.getProportionateScreenSize(toDouble());
}
