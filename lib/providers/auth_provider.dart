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
  String? _fullName;

  // Getters
  AuthStatus get status => _status;
  String? get token => _token;
  String? get userId => _userId;
  String? get errorMessage => _errorMessage;
  bool get isFirstLaunch => _isFirstLaunch;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  String? get examType => _examType;
  String? get fullName => _fullName;

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
      _fullName = prefs.getString('full_name');
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

      // Debug print to see the actual response
      print('Login API Response Status: ${response.statusCode}');
      print('Login API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);

          // Handle different response structures
          if (responseData != null) {
            // Extract token - handle different possible structures
            if (responseData['token'] != null) {
              _token = responseData['token'];
            } else if (responseData['access_token'] != null) {
              _token = responseData['access_token'];
            } else if (responseData['data'] != null && responseData['data']['token'] != null) {
              _token = responseData['data']['token'];
            }

            // Extract user ID - handle different possible structures
            if (responseData['user'] != null && responseData['user']['id'] != null) {
              _userId = responseData['user']['id'].toString();

              // Extract other user data if available
              if (responseData['user']['exam_type'] != null) {
                _examType = responseData['user']['exam_type'];
              }

              if (responseData['user']['full_name'] != null) {
                _fullName = responseData['user']['full_name'];
              }
            } else if (responseData['data'] != null && responseData['data']['user'] != null) {
              _userId = responseData['data']['user']['id']?.toString();

              // Extract other user data if available
              if (responseData['data']['user']['exam_type'] != null) {
                _examType = responseData['data']['user']['exam_type'];
              }

              if (responseData['data']['user']['full_name'] != null) {
                _fullName = responseData['data']['user']['full_name'];
              }
            } else if (responseData['id'] != null) {
              _userId = responseData['id'].toString();
            } else {
              // If we can't find a user ID, generate a temporary one
              _userId = DateTime.now().millisecondsSinceEpoch.toString();
            }

            // Extract exam type if available at root level
            if (responseData['exam_type'] != null) {
              _examType = responseData['exam_type'];
            }

            // Extract full name if available at root level
            if (responseData['full_name'] != null) {
              _fullName = responseData['full_name'];
            }

            // If we have a token, consider it a successful login
            if (_token != null) {
              _status = AuthStatus.authenticated;

              // Store in shared preferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('auth_token', _token!);
              if (_userId != null) {
                await prefs.setString('user_id', _userId!);
              }
              if (_examType != null) {
                await prefs.setString('exam_type', _examType!);
              }
              if (_fullName != null) {
                await prefs.setString('full_name', _fullName!);
              }

              notifyListeners();
              return true;
            } else {
              _errorMessage = 'Invalid response format: No token found';
              _status = AuthStatus.error;
              notifyListeners();
              return false;
            }
          } else {
            _errorMessage = 'Invalid response format: Empty response';
            _status = AuthStatus.error;
            notifyListeners();
            return false;
          }
        } catch (e) {
          _errorMessage = 'Error parsing response: ${e.toString()}';
          _status = AuthStatus.error;
          notifyListeners();
          return false;
        }
      } else {
        try {
          final responseData = jsonDecode(response.body);
          _errorMessage = responseData['message'] ?? responseData['detail'] ?? 'Login failed with status code: ${response.statusCode}';
        } catch (e) {
          _errorMessage = 'Login failed with status code: ${response.statusCode}';
        }
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

  // Register new user
  Future<bool> register(String fullName, String email, String password, {String? examType}) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      // Print the request body for debugging
      final requestBody = {
        'email': email,
        'password': password,
        'full_name': fullName,
        'exam_type': examType ?? 'JEE', // Default to JEE if not provided
      };
      print('Register API Request Body: $requestBody');

      // Make API call to register endpoint
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/v1/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      // Debug print to see the actual response
      print('Register API Response Status: ${response.statusCode}');
      print('Register API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final responseData = jsonDecode(response.body);

          // Store user data
          _fullName = fullName;
          _examType = examType;

          // Check if we have a token in the response
          if (responseData['token'] != null) {
            _token = responseData['token'];

            // Try to extract user ID if available
            if (responseData['user'] != null && responseData['user']['id'] != null) {
              _userId = responseData['user']['id'].toString();
            } else if (responseData['user_id'] != null) {
              _userId = responseData['user_id'].toString();
            } else {
              // If no user ID is provided, generate a temporary one
              _userId = DateTime.now().millisecondsSinceEpoch.toString();
            }

            // If we have a token and user ID, we can consider registration successful
            _status = AuthStatus.authenticated;

            // Store in shared preferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', _token!);
            await prefs.setString('user_id', _userId!);
            await prefs.setString('full_name', fullName);
            if (examType != null) {
              await prefs.setString('exam_type', examType);
            }

            notifyListeners();
            return true;
          } else {
            // IMPORTANT CHANGE: Instead of automatically logging in,
            // we'll consider registration successful even without a token
            _status = AuthStatus.authenticated;
            _userId = DateTime.now().millisecondsSinceEpoch.toString(); // Temporary ID

            // Store user data in shared preferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('user_id', _userId!);
            await prefs.setString('full_name', fullName);
            if (examType != null) {
              await prefs.setString('exam_type', examType);
            }

            // Set a message to inform the user they need to verify their email
            _errorMessage = null; // Clear any previous errors

            notifyListeners();
            return true;
          }
        } catch (e) {
          _errorMessage = 'Error parsing registration response: ${e.toString()}';
          _status = AuthStatus.error;
          notifyListeners();
          return false;
        }
      } else {
        try {
          final responseData = jsonDecode(response.body);

          // Check for the specific PostgreSQL unique constraint error
          if (responseData['code'] == '23505' ||
              (responseData['message'] != null && responseData['message'].toString().contains('already exists')) ||
              (responseData['error'] != null && responseData['error'].toString().contains('already exists'))) {

            _errorMessage = 'This email is already registered. Please try logging in instead.';
            _status = AuthStatus.error;
            notifyListeners();
            return false;
          }

          // Other error handling remains the same
          if (responseData is Map<String, dynamic>) {
            if (responseData['detail'] != null) {
              _errorMessage = responseData['detail'];
            } else if (responseData['message'] != null) {
              _errorMessage = responseData['message'];
            } else if (responseData['error'] != null) {
              _errorMessage = responseData['error'];
            } else {
              // Check if there are field-specific errors
              final errors = [];
              responseData.forEach((key, value) {
                if (value is List && value.isNotEmpty) {
                  errors.add('$key: ${value.join(', ')}');
                } else if (value is String) {
                  errors.add('$key: $value');
                }
              });

              if (errors.isNotEmpty) {
                _errorMessage = errors.join('\n');
              } else {
                _errorMessage = 'Registration failed with status code: ${response.statusCode}';
              }
            }
          } else {
            _errorMessage = 'Registration failed with status code: ${response.statusCode}';
          }
        } catch (e) {
          _errorMessage = 'Registration failed with status code: ${response.statusCode}';
        }
        _status = AuthStatus.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error during registration: ${e.toString()}';
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

  // Logout
  Future<void> logout() async {
    _token = null;
    _userId = null;
    _examType = null;
    _fullName = null;
    _status = AuthStatus.unauthenticated;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('exam_type');
    await prefs.remove('full_name');

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
