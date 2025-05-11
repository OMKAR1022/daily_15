import 'package:daily_fifteen/utils/constants.dart';
import 'package:daily_fifteen/utils/size_config.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: AppConstants.appName),
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
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Example of using the responsive utilities
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Using responsive text styles from AppTextStyles
            Text(
              'You have pushed the button this many times:',
              style: AppTextStyles.bodyLarge(context),
            ),
            // Using responsive text with extension methods
            Text(
              '$_counter',
              style: TextStyle(
                fontSize: 24.sp, // Using the extension method for responsive font size
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            // Example of responsive padding
            SizedBox(height: 20.h), // Using the extension method for responsive height
            // Example of using responsive container
            Container(
              width: 200.w, // Using the extension method for responsive width
              padding: EdgeInsets.all(16.r), // Using the extension method for responsive radius
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'This is a responsive container',
                style: AppTextStyles.bodyMedium(context),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
