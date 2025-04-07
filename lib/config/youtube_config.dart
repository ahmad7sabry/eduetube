class YouTubeConfig {
  // استبدل هذا بالمفتاح الحقيقي لـ YouTube Data API الخاص بك
  static const String apiKey = 'YOUR_YOUTUBE_API_KEY';

  // عدد النتائج في كل طلب (الحد الأقصى المسموح من YouTube هو 50)
  static const int maxResults = 50;

  // إذا تركت اللغة والمنطقة فاضية، سيستخدم YouTube الإعدادات الافتراضية أو كل اللغات والمناطق
  static const String region = ''; // كل المناطق
  static const String language = ''; // كل اللغات

  // قائمة تشغيل من قناة طليق (إبراهيم عادل) – كورس تعلم اللغة الإنجليزية
  static const String taleekPlaylistId = 'PLzTRMA7AXm0V5T0Fd6KOZZ0XmzF8XMvJD';
}
