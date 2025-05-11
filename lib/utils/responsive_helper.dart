import 'package:flutter/material.dart';

/// A utility class that provides responsive sizing helpers
/// This helps ensure UI elements adapt properly to different screen sizes
class ResponsiveHelper {
  // Private constructor to prevent instantiation
  ResponsiveHelper._();

  /// Device type breakpoints
  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 900;
  static const double _desktopBreakpoint = 1200;

  /// Returns the current screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Returns the current screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Returns true if the screen width is less than the mobile breakpoint
  static bool isMobile(BuildContext context) {
    return screenWidth(context) < _mobileBreakpoint;
  }

  /// Returns true if the screen width is between mobile and tablet breakpoints
  static bool isTablet(BuildContext context) {
    return screenWidth(context) >= _mobileBreakpoint &&
        screenWidth(context) < _tabletBreakpoint;
  }

  /// Returns true if the screen width is between tablet and desktop breakpoints
  static bool isDesktop(BuildContext context) {
    return screenWidth(context) >= _tabletBreakpoint &&
        screenWidth(context) < _desktopBreakpoint;
  }

  /// Returns true if the screen width is greater than the desktop breakpoint
  static bool isLargeDesktop(BuildContext context) {
    return screenWidth(context) >= _desktopBreakpoint;
  }

  /// Returns the device type as a string
  static String deviceType(BuildContext context) {
    if (isMobile(context)) return 'mobile';
    if (isTablet(context)) return 'tablet';
    if (isDesktop(context)) return 'desktop';
    return 'large_desktop';
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

/// A widget that builds different layouts based on the screen size
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, String deviceType) builder;

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return builder(context, ResponsiveHelper.deviceType(context));
      },
    );
  }
}

/// A widget that builds different layouts for mobile, tablet, and desktop
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (ResponsiveHelper.isMobile(context)) {
          return mobile;
        }

        if (ResponsiveHelper.isTablet(context)) {
          return tablet ?? mobile;
        }

        if (ResponsiveHelper.isDesktop(context)) {
          return desktop ?? tablet ?? mobile;
        }

        return largeDesktop ?? desktop ?? tablet ?? mobile;
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
