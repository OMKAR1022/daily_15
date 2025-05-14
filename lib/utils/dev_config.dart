// Development configuration settings
class DevConfig {
  // Set to true during development to bypass certain checks
  static const bool isDevelopmentMode = true;

  // API endpoints
  static const String baseApiUrl = 'http://127.0.0.1:8000/api/v1';
  static const String loginEndpoint = '$baseApiUrl/users/login';
  static const String registerEndpoint = '$baseApiUrl/users/register';

  // Development settings
  static const bool bypassEmailVerification = true;

  // Test accounts for development
  static const Map<String, String> testAccounts = {
    'test@example.com': 'password123',
  };

  // Helper method to check if using a test account
  static bool isTestAccount(String email) {
    return testAccounts.containsKey(email);
  }
}
