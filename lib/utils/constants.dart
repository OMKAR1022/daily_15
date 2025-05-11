import 'package:flutter/material.dart';

/// This class contains all the constant values used throughout the app
/// Colors, dimensions, text styles, and other design system elements
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // App name
  static const String appName = 'Daily JEE/NEET MCQ';

  // Animation durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // Padding and margin values
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Border radius values
  static const double borderRadiusS = 4.0;
  static const double borderRadiusM = 8.0;
  static const double borderRadiusL = 16.0;
  static const double borderRadiusXL = 24.0;
  static const double borderRadiusCircular = 100.0;

  // Icon sizes
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;

  // Button heights
  static const double buttonHeightS = 32.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 56.0;
}

/// App color palette
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary colors
  static const Color primary = Color(0xFF0A6EBD);
  static const Color primaryLight = Color(0xFF3A8ED0);
  static const Color primaryDark = Color(0xFF004F8B);

  // Secondary colors
  static const Color secondary = Color(0xFF7A4069);
  static const Color secondaryLight = Color(0xFFA86E97);
  static const Color secondaryDark = Color(0xFF4D1A3E);

  // Accent colors
  static const Color accent = Color(0xFFFF6B00);
  static const Color accentLight = Color(0xFFFF9A4D);
  static const Color accentDark = Color(0xFFCC5500);

  // Neutral colors
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textDisabled = Color(0xFFE0E0E0);
  static const Color textLight = Color(0xFFFFFFFF);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Exam mode colors
  static const Color jeeColor = Color(0xFF0A6EBD);
  static const Color neetColor = Color(0xFF7A4069);

  // Streak color
  static const Color streakColor = Color(0xFFFF6B00);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCardBackground = Color(0xFF2C2C2C);
}

/// Text styles for the app
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // Heading styles
  static TextStyle h1(BuildContext context) => Theme.of(context).textTheme.displayLarge!.copyWith(
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle h2(BuildContext context) => Theme.of(context).textTheme.displayMedium!.copyWith(
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle h3(BuildContext context) => Theme.of(context).textTheme.displaySmall!.copyWith(
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle h4(BuildContext context) => Theme.of(context).textTheme.headlineMedium!.copyWith(
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle h5(BuildContext context) => Theme.of(context).textTheme.headlineSmall!.copyWith(
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle h6(BuildContext context) => Theme.of(context).textTheme.titleLarge!.copyWith(
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // Body styles
  static TextStyle bodyLarge(BuildContext context) => Theme.of(context).textTheme.bodyLarge!.copyWith(
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium(BuildContext context) => Theme.of(context).textTheme.bodyMedium!.copyWith(
    color: AppColors.textPrimary,
  );

  static TextStyle bodySmall(BuildContext context) => Theme.of(context).textTheme.bodySmall!.copyWith(
    color: AppColors.textSecondary,
  );

  // Button styles
  static TextStyle buttonLarge(BuildContext context) => Theme.of(context).textTheme.labelLarge!.copyWith(
    fontWeight: FontWeight.bold,
  );

  static TextStyle buttonMedium(BuildContext context) => Theme.of(context).textTheme.labelMedium!.copyWith(
    fontWeight: FontWeight.bold,
  );

  static TextStyle buttonSmall(BuildContext context) => Theme.of(context).textTheme.labelSmall!.copyWith(
    fontWeight: FontWeight.bold,
  );

  // Caption style
  static TextStyle caption(BuildContext context) => Theme.of(context).textTheme.bodySmall!.copyWith(
    color: AppColors.textSecondary,
    fontSize: 12,
  );
}

/// Theme data for the app
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textLight,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: AppColors.cardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingL,
          vertical: AppConstants.paddingM,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingL,
          vertical: AppConstants.paddingM,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
        borderSide: const BorderSide(color: AppColors.textHint),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.all(AppConstants.paddingM),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: AppColors.textLight,
      unselectedLabelColor: AppColors.textLight,
      indicatorColor: AppColors.textLight,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textLight,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.textHint,
      thickness: 1,
      space: AppConstants.paddingM,
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.textLight,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: AppColors.darkCardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingL,
          vertical: AppConstants.paddingM,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        side: const BorderSide(color: AppColors.primaryLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingL,
          vertical: AppConstants.paddingM,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
        borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
        borderSide: const BorderSide(color: AppColors.textHint),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.all(AppConstants.paddingM),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: AppColors.textLight,
      unselectedLabelColor: AppColors.textHint,
      indicatorColor: AppColors.primaryLight,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: AppColors.textHint,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textLight,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.textHint,
      thickness: 1,
      space: AppConstants.paddingM,
    ),
  );
}
