import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vallidator/helpers/reroute_with_permission.dart';
import 'package:vallidator/helpers/show_snackbar_in_scaffold.dart';
import 'package:vallidator/services/auth_service.dart';
import 'package:vallidator/themes/main_colors.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final AuthService authService = AuthService();

  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    //rerouteWithPermission(context, route: 'templates');

    // Debug
    //login(context, 'kaique.govani@hotmail.com', 'senha_segura');
    //login(context, 'ricardo.milos@gmail.com', 'senha_segura');
    //login(context, 'caetano.passos@hotmail.com', 'senha_segura');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
          physics: const RangeMaintainingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/VallidatorLogo.png',
                      height: 250,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Text(
                        'Sistema de Gerenciamento Eletrônico de Templates',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: GoogleFonts.ubuntu().fontFamily,
                          color: const Color.fromRGBO(41, 115, 71, 1),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Email',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            hintText: 'admin@email.com',
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Senha',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                      child: TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !showPassword,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                                icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off)),
                            hintText: '●●●●●●●●',
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: ElevatedButton(
                        onPressed: () {
                          login(context, _emailController.text,
                              _passwordController.text);
                        },
                        style: MainColors.successButton,
                        child: const Text('Entrar'),
                      ),
                    ),
                    TextButton(
                        onPressed: () {}, child: const Text('Esqueci a Senha')),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  login(BuildContext context, String email, String password) {
    authService.login(email: email, password: password).then(
      (result) {
        if (result) {
          authService.getPermission().then((String perm) {
            if (perm == 'admin') {
              rerouteWithPermission(context, route: 'dashboard');
            } else {
              rerouteWithPermission(context, route: 'templates');
            }
          });
        }
      },
    ).catchError(
      (error) {
        var innerError = error as HttpException;
        showSnackbarInScaffold(context, innerError.message);
      },
      test: (error) => error is HttpException,
    ).catchError(
      (error) {
        showSnackbarInScaffold(context,
            "O servidor demorou para responder, tente novamente mais tarde!");
      },
      test: (error) => error is TimeoutException,
    );
  }
}
