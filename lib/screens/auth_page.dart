import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_setup_page.dart'; // Make sure to import your next screen
import 'swipe_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Common method to handle authentication (sign in or sign up)
  Future<void> _authenticate({required bool isSignIn}) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    try {
      final response = isSignIn
          ? await Supabase.instance.client.auth.signInWithPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            )
          : await Supabase.instance.client.auth.signUp(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            );

      if (response.user != null) {
        if (isSignIn) {
          // Check if profile exists
          final profileExists = await Supabase.instance.client
              .from('profiles')
              .select()
              .eq('id', response.user!.id)
              .maybeSingle();

          // Navigate based on profile status
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  profileExists == null ? ProfileSetupPage() : SwipePage(),
            ),
          );
        } else {
          // New users always go to ProfileSetupPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ProfileSetupPage()),
          );
        }
      }
    } on AuthException catch (e) {
      _showErrorSnackBar(e.message);
    } catch (e) {
      print("Authentication error: $e");
      _showErrorSnackBar("Authentication failed. Please try again.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Swayam Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                autofillHints: const [AutofillHints.email],
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
                validator: _validatePassword,
                autofillHints: const [AutofillHints.password],
              ),
              const SizedBox(height: 20),
              if (isLoading)
                const CircularProgressIndicator()
              else
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => _authenticate(isSignIn: true),
                      child: const Text("Login"),
                    ),
                    TextButton(
                      onPressed: () => _authenticate(isSignIn: false),
                      child: const Text("Don't have an account? Sign Up"),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
