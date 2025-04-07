class ApiConfig {
  // Base URL for the course API
  static const String baseUrl =
      'https://api.yourdomain.com/v1'; // Replace with your actual API endpoint

  // API endpoints
  static const String courses = '/courses';
  static const String videos = '/videos';

  // API Keys
  static const String apiKey =
      'YOUR_API_KEY'; // Replace with your actual API key

  // Request headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };
}
