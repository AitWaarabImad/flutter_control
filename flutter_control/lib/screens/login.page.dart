import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_control/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //check les forme de validation
  final keyForm = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController emailcontroller = TextEditingController();

  final TextEditingController passcontroller = TextEditingController();

  //variable pour mdp
  bool _passVariable = false;

  // methode validator
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) return "Please enter your email";
    final emailpattern = r'^[^@]+@[^@]+\.[^@]+';
    final regExp = RegExp(emailpattern);
    if (!regExp.hasMatch(value)) return "Email inavlide";
    return null;
  }

  String? passValidator(String? value) {
    if (value == null || value.isEmpty) return "Please enter your email";
    if (value.length < 6)
      return "Taille de mot de passe doit depasser 6 caracteres";
  }

  Future<void> signIn() async {
    try {
      // Attempt to sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passcontroller.text.trim(),
      );

      // Navigate to the home page if sign-in is successful
      if (userCredential.user != null) {
        print("Signed in: ${userCredential.user?.email}");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("sign in successfull")));
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      // Handle errors with a switch
      switch (e.code) {
        case "user-not-found":
          Fluttertoast.showToast(
              msg: "Aucun utilisateur trouvé avec cet email");
          break;
        case "wrong-password":
          Fluttertoast.showToast(msg: "Mot de passe incorrect");
          break;
        case "invalid-email":
          Fluttertoast.showToast(msg: "Votre email n'a pas un format valide");
          break;
        case "user-disabled":
          Fluttertoast.showToast(msg: "Ce compte utilisateur a été désactivé");
          break;
        default:
          String msg = "An error occured, try again";
          Fluttertoast.showToast(msg: "Erreur inattendue: ${e.message}");
          Fluttertoast.showToast(msg: "Une erreur inattendue est survenue");
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(msg)));
          print("FirebaseAuthException: $msg");
      }
      print(e);
    } on SocketException catch (e) {
      String message = "Network error : please check your internet connection";
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      print("SocketException: $e");
    } catch (e) {
      String message = "Unexpected error occured";
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      print("Unknown error: $e");
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
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: keyForm,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset("images/logo.jpg", height: 100, width: 100),
                  SizedBox(height: 20),
                  Text("Hello Back to the home Page",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 50, color: Colors.blueAccent)),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                        labelText: "email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.pink,
                        )),
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: passcontroller,
                    obscureText:
                        !_passVariable, //on veut que ca soit true par defaut
                    decoration: InputDecoration(
                        labelText: "password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.pink,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passVariable = !_passVariable;
                              });
                            },
                            icon: Icon(_passVariable
                                ? Icons.visibility
                                : Icons.visibility_off))),

                    keyboardType: TextInputType.emailAddress,
                    validator: passValidator,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (keyForm.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('processing login')),
                          );
                          signIn();
                        }
                      },
                      child: Text(
                        "Login",
                        style:
                            TextStyle(fontSize: 30, color: Colors.deepPurple),
                      )),
                  SizedBox(height: 20),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/register");
                      },
                      child: Text("Don't have an account ?",
                          style: TextStyle(fontSize: 30, color: Colors.pink)))
                ],
              ),
            )));
  }
}
