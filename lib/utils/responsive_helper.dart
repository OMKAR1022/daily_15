import 'package:flutter/material.dart';

enum DeviceType {
  mobile,
  tablet,
  desktop,
}

class ResponsiveHelper {
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;

  // Get device type based on width
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (width < tabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  // Check if device is mobile
  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  // Check if device is tablet
  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  // Check if device is desktop
  static bool isDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }

  // Get responsive value based on device type
  static T responsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  /// Returns the current screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Returns the current screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Returns a responsive value based on the screen width
  /// [mobile] value for mobile screens
  /// [tablet] value for tablet screens
  /// [desktop] value for desktop screens
  /// [largeDesktop] value for large desktop screens
  static T responsive<T>(
      BuildContext context, {
        required T mobile,
        T? tablet,
        T? desktop,
        T? largeDesktop,
      }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet ?? mobile;
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    return largeDesktop ?? desktop ?? tablet ?? mobile;
  }

  /// Returns a responsive font size based on the screen width
  static double responsiveFontSize(
      BuildContext context, {
        required double baseFontSize,
        double? minFontSize,
        double? maxFontSize,
      }) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Base size is for 375px width (iPhone X)
    double scaleFactor = screenWidth / 375;

    // Limit scale factor to avoid text becoming too small or too large
    if (minFontSize != null && baseFontSize * scaleFactor < minFontSize) {
      return minFontSize;
    }

    if (maxFontSize != null && baseFontSize * scaleFactor > maxFontSize) {
      return maxFontSize;
    }

    return baseFontSize * scaleFactor;
  }

  /// Returns a responsive width based on the screen width percentage
  static double responsiveWidth(BuildContext context, {required double percentage}) {
    return screenWidth(context) * (percentage / 100);
  }

  /// Returns a responsive height based on the screen height percentage
  static double responsiveHeight(BuildContext context, {required double percentage}) {
    return screenHeight(context) * (percentage / 100);
  }

  /// Returns a responsive size based on the screen width
  /// This is useful for padding, margins, and other dimensions
  static double responsiveSize(
      BuildContext context, {
        required double baseSize,
        double? minSize,
        double? maxSize,
      }) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Base size is for 375px width (iPhone X)
    double scaleFactor = screenWidth / 375;

    // Limit scale factor to avoid sizes becoming too small or too large
    if (minSize != null && baseSize * scaleFactor < minSize) {
      return minSize;
    }

    if (maxSize != null && baseSize * scaleFactor > maxSize) {
      return maxSize;
    }

    return baseSize * scaleFactor;
  }

  /// Returns a responsive padding based on the screen width
  static EdgeInsets responsivePadding(
      BuildContext context, {
        required double horizontal,
        required double vertical,
      }) {
    return EdgeInsets.symmetric(
      horizontal: responsiveSize(context, baseSize: horizontal),
      vertical: responsiveSize(context, baseSize: vertical),
    );
  }

  /// Returns a responsive margin based on the screen width
  static EdgeInsets responsiveMargin(
      BuildContext context, {
        required double horizontal,
        required double vertical,
      }) {
    return EdgeInsets.symmetric(
      horizontal: responsiveSize(context, baseSize: horizontal),
      vertical: responsiveSize(context, baseSize: vertical),
    );
  }

  /// Returns a responsive border radius based on the screen width
  static BorderRadius responsiveBorderRadius(
      BuildContext context, {
        required double radius,
      }) {
    return BorderRadius.circular(
      responsiveSize(context, baseSize: radius),
    );
  }

  /// Returns a safe area padding
  static EdgeInsets safeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Returns the status bar height
  static double statusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// Returns the bottom navigation bar height
  static double bottomNavBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  /// Returns the keyboard height if it's visible, 0 otherwise
  static double keyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  /// Returns true if the keyboard is visible
  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  /// Returns the available height (screen height - status bar - bottom nav bar)
  static double availableHeight(BuildContext context) {
    return screenHeight(context) -
        statusBarHeight(context) -
        bottomNavBarHeight(context);
  }
}

// Responsive builder widget
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveHelper.getDeviceType(context);
    return builder(context, deviceType);
  }
}

// Responsive layout widget
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        switch (deviceType) {
          case DeviceType.mobile:
            return mobile;
          case DeviceType.tablet:
            return tablet ?? mobile;
          case DeviceType.desktop:
            return desktop ?? tablet ?? mobile;
        }
      },
    );
  }
}

/// A widget that applies responsive padding based on the screen size
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final double? horizontal;
  final double? vertical;

  const ResponsivePadding({
    Key? key,
    required this.child,
    this.horizontal,
    this.vertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal != null
            ? ResponsiveHelper.responsiveSize(context, baseSize: horizontal!)
            : 0,
        vertical: vertical != null
            ? ResponsiveHelper.responsiveSize(context, baseSize: vertical!)
            : 0,
      ),
      child: child,
    );
  }
}

/// A widget that applies responsive margin based on the screen size
class ResponsiveMargin extends StatelessWidget {
  final Widget child;
  final double? horizontal;
  final double? vertical;

  const ResponsiveMargin({
    Key? key,
    required this.child,
    this.horizontal,
    this.vertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontal != null
            ? ResponsiveHelper.responsiveSize(context, baseSize: horizontal!)
            : 0,
        vertical: vertical != null
            ? ResponsiveHelper.responsiveSize(context, baseSize: vertical!)
            : 0,
      ),
      child: child,
    );
  }
}

/// A text widget that automatically adjusts its font size based on the screen size
class ResponsiveText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? minFontSize;
  final double? maxFontSize;

  const ResponsiveText(
      this.text, {
        Key? key,
        required this.fontSize,
        this.fontWeight,
        this.color,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.minFontSize,
        this.maxFontSize,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: ResponsiveHelper.responsiveFontSize(
          context,
          baseFontSize: fontSize,
          minFontSize: minFontSize,
          maxFontSize: maxFontSize,
        ),
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
