// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:medibd/authentication/login.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _fadeInBackground;
  late Animation<double> _fadeInLogo;
  late Animation<Offset> _upperTextSlide;
  late Animation<Offset> _lowerTextSlide;

  @override
  void initState() {
    super.initState();

    // Initialize background fade-in controller
    _bgController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Initialize logo animation controller
    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Initialize text animation controller
    _textController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Background fade-in animation
    _fadeInBackground = CurvedAnimation(
      parent: _bgController,
      curve: Curves.easeIn,
    );

    // Logo fade-in animation
    _fadeInLogo = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    );

    // Slide in animations for texts
    _upperTextSlide = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _lowerTextSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    // Start background and logo animation with delays
    _bgController.forward().then((_) => _logoController.forward());

    // Start text animations after the logo animation
    Timer(const Duration(seconds: 2), () {
      _textController.forward();
    });

    // Navigate to LoginPage after splash screen duration
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeInBackground,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0D5C75), // Dark teal
                Color(0xFF2A93B4), // Lighter blue
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SlideTransition(
                  position: _upperTextSlide,
                  child: FadeTransition(
                    opacity: _fadeInLogo,
                    child: const Text(
                      "We care deeply",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: _fadeInLogo,
                  child: Image.asset(
                    'assets/medihubLogo.png',
                    width: 120,
                    height: 120,
                  ),
                ),
                const SizedBox(height: 20),
                SlideTransition(
                  position: _lowerTextSlide,
                  child: FadeTransition(
                    opacity: _fadeInLogo,
                    child: const Text(
                      "about your health",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Loading indicator
                FadeTransition(
                  opacity: _fadeInLogo,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
