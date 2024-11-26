import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _firstNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isHoveringSignIn = false; // Hover state for "Sign In"

  void _register() async {
    if (_firstNameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        if (!user.emailVerified) {
          await user.sendEmailVerification();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Verification email sent. Please check your inbox.')),
          );
        }

        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'first_name': _firstNameController.text.trim(),
          'phone': _phoneController.text.trim(),
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Create Account',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/medihubLogo.png', width: 80, height: 80),
                  const SizedBox(height: 16),
                  const Text(
                    'Join Us!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                      _firstNameController, 'First Name', Icons.person),
                  const SizedBox(height: 20),
                  _buildTextField(
                      _phoneController, 'Phone Number', Icons.phone),
                  const SizedBox(height: 20),
                  _buildTextField(_emailController, 'Email', Icons.email),
                  const SizedBox(height: 20),
                  _buildPasswordTextField(
                      _passwordController, 'Create Password'),
                  const SizedBox(height: 20),
                  _buildPasswordTextField(
                      _confirmPasswordController, 'Confirm Password',
                      isConfirmPassword: true),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.blueGrey)
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.blue[200],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          "or",
                          style: TextStyle(color: Color(0xFFC1C1C1)),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.blue[200]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Add Google login logic here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Google white
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.zero, // No rounded corners
                              side: BorderSide(color: Colors.black12, width: 1),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/google_logo.png',
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Sign up with Google",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10), // Space between buttons
                      // Facebook Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Add Facebook login logic here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Facebook blue
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.zero, // No rounded corners
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.facebook,
                                size: 24,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Sign up with Facebook",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? ',
                          style: TextStyle(color: Colors.blueGrey)),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) {
                          setState(() {
                            _isHoveringSignIn = true;
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            _isHoveringSignIn = false;
                          });
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Sign In',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: _isHoveringSignIn
                                      ? Colors.orange[200]
                                      : Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              AnimatedOpacity(
                                opacity: _isHoveringSignIn ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 200),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueGrey),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blueGrey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueGrey),
        ),
      ),
      style: const TextStyle(color: Colors.black87),
    );
  }

  Widget _buildPasswordTextField(
    TextEditingController controller,
    String label, {
    bool isConfirmPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText:
          isConfirmPassword ? !_isConfirmPasswordVisible : !_isPasswordVisible,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock, color: Colors.blueGrey),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blueGrey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueGrey),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            (isConfirmPassword ? _isConfirmPasswordVisible : _isPasswordVisible)
                ? Icons.visibility
                : Icons.visibility_off,
            color: Colors.blueGrey,
          ),
          onPressed: () {
            setState(() {
              if (isConfirmPassword) {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              } else {
                _isPasswordVisible = !_isPasswordVisible;
              }
            });
          },
        ),
      ),
      style: const TextStyle(color: Colors.black87),
    );
  }

  Widget _buildSocialLoginButton(String text, dynamic icon, Color bgColor,
      Color textColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 160,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon is String
                ? Image.asset(
                    icon,
                    width: 20,
                    height: 20,
                  )
                : Icon(
                    icon,
                    size: 20,
                    color: textColor,
                  ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
