import 'package:daily_fifteen/providers/auth_provider.dart';
import 'package:daily_fifteen/screens/auth/login_screen.dart';
import 'package:daily_fifteen/screens/home_screen.dart';
import 'package:daily_fifteen/screens/onboarding/onboarding_screen.dart';
import 'package:daily_fifteen/utils/constants.dart';
import 'package:daily_fifteen/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Add other providers here as needed
      ],
      child: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return MaterialApp(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system,

              // Define named routes
              routes: {
                '/': (context) => _getInitialScreen(authProvider),
                '/home': (context) => const HomeScreen(),
                '/login': (context) => const LoginScreen(),
                '/onboarding': (context) => const OnboardingScreen(),
              },

              // Initial route
              initialRoute: '/',

              // Handle unknown routes
              onUnknownRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                );
              },

              builder: (context, child) {
                // Initialize SizeConfig here to ensure it's available throughout the app
                SizeConfig.init(context);

                // Return the child with the correct text scale factor
                return MediaQuery(
                  // Prevent the app from resizing when the keyboard appears
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child!,
                );
              },
            );
          }
      ),
    );
  }

  Widget _getInitialScreen(AuthProvider authProvider) {
    // Show onboarding screen if it's the first launch
    if (authProvider.isFirstLaunch) {
      return const OnboardingScreen();
    }

    // Show login screen or home screen based on authentication status
    if (authProvider.isAuthenticated) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
