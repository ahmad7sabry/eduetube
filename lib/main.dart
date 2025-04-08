import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:eduetube/firebase_options.dart';
import 'package:eduetube/views/home.dart';
import 'package:eduetube/views/community.dart';
import 'package:eduetube/views/videoplayer.dart';
import 'package:eduetube/views/livestream.dart';
import 'package:eduetube/views/messages.dart';
import 'package:eduetube/views/call.dart';
import 'package:eduetube/views/cources.dart';
import 'package:eduetube/views/profile.dart';
import 'package:eduetube/views/editprofile.dart';
import 'package:eduetube/views/settings.dart';
import 'package:eduetube/views/messages.dart';
import 'package:eduetube/views/notification.dart';
import 'package:eduetube/views/filter.dart';
import 'package:eduetube/views/splash.dart';
import 'package:eduetube/views/onboarding1.dart';
import 'package:eduetube/views/onboarding2.dart';
import 'package:eduetube/views/onboarding3.dart';
import 'package:eduetube/views/login.dart';
import 'package:eduetube/views/signup.dart';
import 'package:eduetube/views/otp.dart';
import 'package:eduetube/views/forgetpassword.dart';
import 'package:eduetube/views/resetpassword.dart';
import 'package:eduetube/views/verify.dart';
import 'package:eduetube/views/createpost.dart';
import 'package:eduetube/views/courses/webdev.dart';
import 'package:eduetube/views/courses/appdev.dart';
import 'package:eduetube/views/courses/cprogramming.dart';
import 'package:eduetube/views/courses/python.dart';
import 'package:eduetube/views/videoplayer_web.dart';
import 'package:eduetube/views/course_cat/course_cat.dart';
import 'package:eduetube/views/course_checkout.dart';
import 'package:eduetube/views/cart.dart';
import 'package:eduetube/views/search.dart';
import 'package:eduetube/views/videos/video_collection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EdueTube',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff335EF7)),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/community': (context) => const CommunityScreen(),
        '/videoplayer': (context) => const VideoPlayerScreen(),
        '/livestream': (context) => const LivestreamScreen(),
        '/messages': (context) => const MessagesScreen(),
        '/call': (context) => const CallScreen(),
        '/cources': (context) => const CourseScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/editprofile': (context) => const EditProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/notifications': (context) => const NotificationScreen(),
        '/filter': (context) => const FilterScreen(),
        '/onboarding1': (context) => const Onboarding1Screen(),
        '/onboarding2': (context) => const Onboarding2Screen(),
        '/onboarding3': (context) => const Onboarding3Screen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/otp': (context) => const OtpScreen(),
        '/forgetpassword': (context) => const ForgetPasswordScreen(),
        '/resetpassword': (context) => const ResetPasswordScreen(),
        '/verify': (context) => const VerifyScreen(),
        '/createpost': (context) => const CreatePostScreen(),
        '/webdev': (context) => const WebDevScreen(),
        '/appdev': (context) => const AppDevScreen(),
        '/cprogramming': (context) => const CProgrammingScreen(),
        '/python': (context) => const PythonScreen(),
        '/videoplayer_web': (context) => const VideoPlayerWebScreen(),
        '/course_cat': (context) => const CourseCatScreen(),
        '/course_checkout': (context) => const CourseCheckoutScreen(),
        '/cart': (context) => const CartScreen(),
        '/search': (context) => const SearchScreen(),
        '/video_collection': (context) => const VideoCollectionScreen(),
        '/add_video': (context) => const AddVideoPage(),
      },
    );
  }
}
