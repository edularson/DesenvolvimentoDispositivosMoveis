import 'package:flutter/material.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import 'register_page.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void signUserIn() async {
    String? emailError = _authService.validateEmail(emailController.text);
    String? passwordError = _authService.validatePassword(passwordController.text);

    if (emailError != null) { showMessage(emailError); return; }
    if (passwordError != null) { showMessage(passwordError); return; }

    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await _authService.signIn(emailController.text, passwordController.text);
      if (mounted) Navigator.pop(context);
    } on AuthServiceException catch (e) {
      if (mounted) {
        Navigator.pop(context);
        showMessage(e.toString());
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        showMessage("Erro inesperado: $e");
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.sports_soccer, size: 100, color: Colors.greenAccent),
                const SizedBox(height: 50),
                const Text('Bem-vindo de volta!', style: TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 25),
                MyTextField(controller: emailController, hintText: 'Email', obscureText: false),
                const SizedBox(height: 10),
                MyTextField(controller: passwordController, hintText: 'Senha', obscureText: true),
                const SizedBox(height: 25),
                MyButton(onTap: signUserIn, text: "Entrar"),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Não tem conta?', style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                      },
                      child: const Text('Registre-se agora', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}