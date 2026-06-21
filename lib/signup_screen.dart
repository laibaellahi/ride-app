import 'package:flutter/material.dart';
import 'main.dart'; // AppState

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _phoneC = TextEditingController();
  final _passC = TextEditingController();
  final _confirmC = TextEditingController();

  bool _loading = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  String _role = "Passenger";

  InputDecoration _dec(String label, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Future<void> _signup() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_passC.text != _confirmC.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      // 🔥 SAVE ROLE GLOBALLY (IMPORTANT FIX)
      AppState.setUserType(_role);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account created as $_role")),
      );

      // 🚀 FIXED NAVIGATION (NO driverHome error anymore)
      Navigator.pushReplacementNamed(context, "/home");

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup failed: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                const SizedBox(height: 20),

                const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 25),

                // ================= NAME =================
                TextFormField(
                  controller: _nameC,
                  decoration: _dec("Full Name", Icons.person),
                  validator: (v) =>
                  v!.isEmpty ? "Enter name" : null,
                ),

                const SizedBox(height: 12),

                // ================= EMAIL =================
                TextFormField(
                  controller: _emailC,
                  decoration: _dec("Email", Icons.email),
                  validator: (v) =>
                  v!.contains("@") ? null : "Enter valid email",
                ),

                const SizedBox(height: 12),

                // ================= PHONE =================
                TextFormField(
                  controller: _phoneC,
                  decoration: _dec("Phone", Icons.phone),
                  validator: (v) =>
                  v!.isEmpty ? "Enter phone" : null,
                ),

                const SizedBox(height: 12),

                // ================= PASSWORD =================
                TextFormField(
                  controller: _passC,
                  obscureText: _obscurePass,
                  decoration: _dec(
                    "Password",
                    Icons.lock,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePass
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePass = !_obscurePass),
                    ),
                  ),
                  validator: (v) =>
                  v!.length < 6 ? "Min 6 characters" : null,
                ),

                const SizedBox(height: 12),

                // ================= CONFIRM PASSWORD =================
                TextFormField(
                  controller: _confirmC,
                  obscureText: _obscureConfirm,
                  decoration: _dec(
                    "Confirm Password",
                    Icons.lock_outline,
                    suffix: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (v) =>
                  v!.isEmpty ? "Confirm password" : null,
                ),

                const SizedBox(height: 20),

                // ================= ROLE SELECTOR (FIXED STYLE) =================
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [

                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _role = "Passenger"),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _role == "Passenger"
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Passenger",
                                style: TextStyle(
                                  color: _role == "Passenger"
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _role = "Driver"),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _role == "Driver"
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Driver",
                                style: TextStyle(
                                  color: _role == "Driver"
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // ================= SIGNUP BUTTON =================
                SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _signup,
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Create Account"),
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