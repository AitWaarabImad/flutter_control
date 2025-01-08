import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final keyForm = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool _isObscured = true;

  // Validators
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) return "Please enter your email";
    final emailPattern = r'^[^@]+@[^@]+\.[^@]+';
    final regExp = RegExp(emailPattern);
    if (!regExp.hasMatch(value)) return "Invalid email format";
    return null;
  }

  String? passValidator(String? value) {
    if (value == null || value.isEmpty) return "Please enter your password";
    if (value.length < 6) return "Password must be at least 6 characters long";
    return null;
  }

  Future<void> signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      if (userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sign in successful")),
        );
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      String message = "An unexpected error occurred";
      switch (e.code) {
        case "user-not-found":
          message = "No user found with this email";
          break;
        case "wrong-password":
          message = "Incorrect password";
          break;
        case "invalid-email":
          message = "Invalid email format";
          break;
        case "user-disabled":
          message = "This account has been disabled";
          break;
        default:
          message = "Error: ${e.message}";
          break;
      }
      Fluttertoast.showToast(msg: message);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Network error. Please check your internet connection.");
    } catch (e) {
      Fluttertoast.showToast(msg: "An unexpected error occurred.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Home Page",
          style: TextStyle(color: Colors.blue, fontSize: 40),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: keyForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset("images/logo.jpg", height: 100, width: 100),
              const SizedBox(height: 20),
              const Text(
                "Hello Back to the home Page",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 50, color: Colors.blueAccent),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.pink,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: emailValidator,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passController,
                obscureText: _isObscured,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.pink,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                  ),
                ),
                keyboardType: TextInputType.text,
                validator: passValidator,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (keyForm.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing login')),
                    );
                    signIn();
                  }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 30, color: Colors.deepPurple),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/register");
                },
                child: const Text(
                  "Don't have an account?",
                  style: TextStyle(fontSize: 30, color: Colors.pink),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
