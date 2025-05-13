import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus {
  initial,
  authenticating,
  authenticated,
  unauthenticated,
  error
}

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  String? _token;
  String? _userId;
  String? _errorMessage;
  bool _isFirstLaunch = true;
  String? _examType;

  // Getters
  AuthStatus get status => _status;
  String? get token => _token;
  String? get userId => _userId;
  String? get errorMessage => _errorMessage;
  bool get isFirstLaunch => _isFirstLaunch;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  String? get examType => _examType;

  // Constructor - initialize and check stored auth state
  AuthProvider() {
    _checkAuthStatus();
    _checkFirstLaunch();
  }

  // Check if it's the first time the app is launched
  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstLaunch = prefs.getBool('is_first_launch') ?? true;
    notifyListeners();
  }

  // Mark that the app has been launched before
  Future<void> markAppLaunched() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_launch', false);
    _isFirstLaunch = false;
    notifyListeners();
  }

  // Check if user is already logged in from stored token
  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      _token = token;
      _userId = prefs.getString('user_id');
      _examType = prefs.getString('exam_type');
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  // Login with email and password
  Future<bool> login(String email, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/v1/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Save auth token and user data
        _token = responseData['token'];
        _userId = responseData['user']['id'].toString();
        _examType = responseData['user']['exam_type'];
        _status = AuthStatus.authenticated;

        // Store in shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString('user_id', _userId!);
        if (_examType != null) {
          await prefs.setString('exam_type', _examType!);
        }

        notifyListeners();
        return true;
      } else {
        _errorMessage = responseData['message'] ?? 'Login failed';
        _status = AuthStatus.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    try {
      // Implement Google sign-in logic here
      // This is a placeholder for now
      await Future.delayed(const Duration(seconds: 1));

      _status = AuthStatus.error;
      _errorMessage = 'Google sign-in not implemented yet';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Google sign-in error: ${e.toString()}';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Sign in with GitHub
  Future<bool> signInWithGithub() async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    try {
      // Implement GitHub sign-in logic here
      // This is a placeholder for now
      await Future.delayed(const Duration(seconds: 1));

      _status = AuthStatus.error;
      _errorMessage = 'GitHub sign-in not implemented yet';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'GitHub sign-in error: ${e.toString()}';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Register new user
  Future<bool> register(String name, String email, String password, {String? examType}) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      // Here you would normally make an API call to register the user
      // For now, we'll simulate a successful registration
      await Future.delayed(const Duration(seconds: 1));

      // In a real implementation, you would get these values from the API response
      _token = 'dummy_token';
      _userId = 'dummy_user_id';
      _examType = examType;
      _status = AuthStatus.authenticated;

      // Store in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      await prefs.setString('user_id', _userId!);
      if (examType != null) {
        await prefs.setString('exam_type', examType);
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Registration error: ${e.toString()}';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _token = null;
    _userId = null;
    _examType = null;
    _status = AuthStatus.unauthenticated;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('exam_type');

    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }
}
