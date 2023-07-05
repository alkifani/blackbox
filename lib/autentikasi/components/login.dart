// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:bb/autentikasi/components/auth_service.dart';
import 'package:bb/autentikasi/components/home.dart';
import 'package:flutter/material.dart';

class LoginScreenOld extends StatefulWidget {
  static const routeName = "/LoginScreen";

  @override
  _LoginScreenOldState createState() => _LoginScreenOldState();
}

class _LoginScreenOldState extends State<LoginScreenOld> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30.0,
              ),
              Container(
                width: 215,
                height: 215,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(hintText: 'Email'),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  final message = await AuthService().login(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                  if (message!.contains('Success')) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            Home(email: _emailController.text),
                      ),
                    );
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                    ),
                  );
                },
                child: const Text('Login'),
              ),
              const SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
