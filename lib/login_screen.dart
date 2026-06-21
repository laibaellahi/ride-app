import 'package:flutter/material.dart';
import 'main.dart'; // IMPORTANT for AppState

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _isLoading = false;
  bool _obscurePassword = true;

  String _selectedRole = "Passenger";

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      AppState.setUserType(_selectedRole);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful as $_selectedRole')),
      );

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [

              const SizedBox(height: 60),

              const Icon(Icons.local_taxi, size: 100),

              const SizedBox(height: 20),

              const Text(
                "Welcome Back",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              // ================= EMAIL =================
              TextFormField(
                controller: _emailController,
                focusNode: _emailFocus,
                decoration: _inputDecoration(
                  label: "Email",
                  icon: Icons.email,
                ),
                validator: (value) =>
                value!.isEmpty ? "Enter email" : null,
              ),

              const SizedBox(height: 15),

              // ================= PASSWORD =================
              TextFormField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                obscureText: _obscurePassword,
                decoration: _inputDecoration(
                  label: "Password",
                  icon: Icons.lock,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) =>
                value!.length < 6 ? "Min 6 characters" : null,
              ),

              const SizedBox(height: 20),

              // ================= ROLE SELECTOR (NEW CLEAN UI ONLY) =================
              const Text(
                "Login as:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [

                    // ================= PASSENGER =================
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedRole = "Passenger"),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _selectedRole == "Passenger"
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                color: _selectedRole == "Passenger"
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Passenger",
                                style: TextStyle(
                                  color: _selectedRole == "Passenger"
                                      ? Colors.white
                                      : Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // ================= DRIVER =================
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedRole = "Driver"),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _selectedRole == "Driver"
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.drive_eta,
                                color: _selectedRole == "Driver"
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Driver",
                                style: TextStyle(
                                  color: _selectedRole == "Driver"
                                      ? Colors.white
                                      : Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ================= LOGIN BUTTON =================
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login"),
                ),
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/signup'),
                child: const Text("Create account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}