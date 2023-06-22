// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:bb/autentikasi/components/auth_service.dart';
import 'package:bb/autentikasi/components/home.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/LoginScreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      backgroundColor: Color.fromRGBO(108, 108, 108, 1.0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 75,
                ),
                Container(
                  width: 165,
                  height: 165,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 175.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'EMAIL',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      fillColor: Color.fromRGBO(217, 217, 217, 1),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: 'KATA SANDI',
                      fillColor: Color.fromRGBO(217, 217, 217, 1),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 36.0,
                ),
                SizedBox(
                  height: 55,
                  width: MediaQuery.of(context).size.width / 2.25,
                  child: ElevatedButton(
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
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Adjust the corner radius as desired
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(23, 46, 130, 0.6), // Red color (RGB: 255, 0, 0)
                      ),
                    ),
                    child: const Text('MASUK', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
