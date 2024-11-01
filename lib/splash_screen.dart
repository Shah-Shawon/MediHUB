// splash_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _upperTextSlide;
  late Animation<Offset> _lowerTextSlide;

  @override
  void initState() {
    super.initState();

    // Controller for logo fade-in
    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Controller for text animations
    _textController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Fade-in animation for the logo
    _fadeInAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    );

    // Slide animations for upper and lower text
    _upperTextSlide = Tween<Offset>(
      begin: Offset(0, -0.5), // Slide in from above
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _lowerTextSlide = Tween<Offset>(
      begin: Offset(0, 0.5), // Slide in from below
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    // Start logo animation
    _logoController.forward();

    // Start text animation with a delay
    Timer(const Duration(seconds: 2), () {
      _textController.forward();
    });

    // Navigate to HomePage after splash screen duration
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
                  opacity: _fadeInAnimation,
                  child: const Text(
                    "We have concerns",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeTransition(
                opacity: _fadeInAnimation,
                child: Image.asset(
                  'assets/medihubLogo.png',
                  width: 100,
                  height: 100,
                ),
              ),
              const SizedBox(height: 10),
              SlideTransition(
                position: _lowerTextSlide,
                child: FadeTransition(
                  opacity: _fadeInAnimation,
                  child: const Text(
                    "about your health",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
