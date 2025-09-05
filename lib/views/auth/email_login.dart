import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/dashboard/main_dashboard_loader.dart';
import 'otp_login_view.dart'; // Import your OTP screen here
import '../../services/auth_service.dart'; // Import your AuthService here
import '../dashboard/saloon_dashboard.dart';

class LoginToggleView extends StatefulWidget {
  const LoginToggleView({super.key});

  @override
  State<LoginToggleView> createState() => _LoginToggleViewState();
}

class _LoginToggleViewState extends State<LoginToggleView> {
  bool showOtpLogin = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  bool showPassword = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Navigate to OTP screen only once when showOtpLogin becomes true
    if (showOtpLogin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OtpLoginView()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              if (!showOtpLogin) ...[
                /// EMAIL LOGIN SECTION
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed:
                          () => setState(() => showPassword = !showPassword),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("Forgot password?"),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      if (email.isNotEmpty && password.isNotEmpty) {
                        final success = await AuthService.login(
                          email,
                          password,
                        );

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Login Successful")),
                          );

                          // Navigate to Dashboard
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MainDashboardLoader(),
                            ), // <- Update with your page name
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Invalid credentials"),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Email and password required"),
                          ),
                        );
                      }
                    },

                    child: const Text(
                      "LOGIN",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() => showOtpLogin = true);

                      // Navigate after rebuild is complete
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => OtpLoginView()),
                        );
                      });
                    },

                    child: const Text("Login with OTP"),
                  ),
                ),
              ] else ...[
                // Just placeholder, navigation is already triggered
                const SizedBox.shrink(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
