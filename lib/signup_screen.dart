import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Create Account", style: TextStyle(fontSize: 26)),
              const SizedBox(height: 20),

              TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
              const SizedBox(height: 12),
              TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  try {
                    await AuthService().signUp(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Signup failed: $e")),
                    );
                  }
                },
                child: const Text("Create Account"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
