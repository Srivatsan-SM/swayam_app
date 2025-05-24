import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth_page.dart';
import 'screens/home_page.dart';
import 'screens/create_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://lynyinazdjfkddeftcpq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx5bnlpbmF6ZGpma2RkZWZ0Y3BxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc5MzM4NTQsImV4cCI6MjA2MzUwOTg1NH0.4zgznVxy7lhATXEBXA5Iow3RlxevVW3Zm6xSR__oqfY',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swayam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/auth',
      routes: {
        '/auth': (_) => const AuthPage(),
        '/home': (_) => const HomePage(),
        '/create-profile': (_) => const CreateProfileScreen(),
      },
    );
  }
}
