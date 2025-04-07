# EduTube Course Platform

EduTube is a Flutter-based educational platform that allows users to access and manage online courses.

## API Integration Setup

To integrate real course data, follow these steps:

1. Open `lib/config/api_config.dart` and update the following values:

```dart
static const String baseUrl = 'YOUR_API_BASE_URL';  // e.g., 'https://api.yourdomain.com/v1'
static const String apiKey = 'YOUR_API_KEY';        // Your API authentication key
```

### API Endpoints

The application expects the following API endpoints:

- `GET /courses` - Fetch all available courses
- `GET /courses/{courseId}` - Fetch a specific course
- `PATCH /courses/{courseId}/progress` - Update course progress
- `PATCH /courses/{courseId}/videos/{videoId}/watched` - Mark a video as watched

### Expected Response Format

#### Course Object
```json
{
  "id": "string",
  "title": "string",
  "description": "string",
  "author": "string",
  "thumbnailUrl": "string",
  "categories": ["string"],
  "videos": [
    {
      "id": "string",
      "title": "string",
      "description": "string",
      "youtubeId": "string",
      "watched": boolean
    }
  ],
  "progress": number
}
```

### Offline Support

The application includes offline support through local storage:
- Courses are cached locally when fetched
- If the API is unreachable, the app will use cached data
- Course progress is synchronized when connectivity is restored

### Error Handling

The application handles various API error scenarios:
- 401: Authentication errors
- 404: Resource not found
- Network connectivity issues
- Invalid response formats

## Development

To start development:

1. Install dependencies:
```bash
flutter pub get
```

2. Configure your API endpoint and key in `lib/config/api_config.dart`

3. Run the app:
```bash
flutter run
```

## Architecture

The app follows a clean architecture pattern:
- `models/` - Data models
- `services/` - API and data services
- `providers/` - State management
- `pages/` - UI screens
- `widgets/` - Reusable UI components
- `utils/` - Helper utilities
- `config/` - Configuration files
