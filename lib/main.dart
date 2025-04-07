import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edutube/models/app_state.dart';
import 'package:edutube/providers/course_provider.dart';
import 'package:edutube/providers/youtube_provider.dart';
import 'package:edutube/services/youtube_service.dart';
import 'package:edutube/config/youtube_config.dart';
import 'package:edutube/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => CourseProvider()),
        Provider<YouTubeService>(
          create: (context) => YouTubeService(YouTubeConfig.apiKey),
        ),
        ChangeNotifierProxyProvider<YouTubeService, YouTubeProvider>(
          create: (context) => YouTubeProvider(context.read<YouTubeService>()),
          update:
              (context, service, previous) =>
                  previous ?? YouTubeProvider(service),
        ),
      ],
      child: MaterialApp(
        title: 'EduTube Courses',
        theme: ThemeData(
          primarySwatch: Colors.red,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
