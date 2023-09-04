import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/common/sign_in_button.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void navigateToLoginPage(BuildContext context) {
      Routemaster.of(context).replace('/');
    }

    void signUpWithEmailAndPassword(BuildContext context, WidgetRef ref,
        String userName, String email, String passowrd) {
      ref
          .read(authControllerProvider.notifier)
          .signUpWithEmailAndPassword(context, userName, email, passowrd);
      Routemaster.of(context).replace('/');
    }

    final userNameTextController = TextEditingController();
    final emailTextController = TextEditingController();
    final passwordTextController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                "Welcome to GPA Calculator",
                style: GoogleFonts.roboto(fontSize: 25.0, color: Colors.black),
              ),
            ),
            Image.asset('assets/images/signupscreenphoto.png'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('User',
                          style: GoogleFonts.roboto(
                              fontSize: 15, color: Colors.black)),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: userNameTextController,
                      decoration: const InputDecoration(),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Email',
                          style: GoogleFonts.roboto(
                              fontSize: 15, color: Colors.black)),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: emailTextController,
                      decoration: const InputDecoration(),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Password',
                          style: GoogleFonts.roboto(
                              fontSize: 15, color: Colors.black)),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: passwordTextController,
                      decoration: const InputDecoration(),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () => signUpWithEmailAndPassword(
                          context,
                          ref,
                          userNameTextController.text,
                          emailTextController.text,
                          passwordTextController.text),
                      child: Text(
                        'Sign up',
                        style: GoogleFonts.lato(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?  ",
                          style: TextStyle(fontSize: 15),
                        ),
                        GestureDetector(
                          onTap: () => navigateToLoginPage(context),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Divider(thickness: 2)),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Text("Or", style: TextStyle(fontSize: 18)),
                        ),
                        Expanded(child: Divider(thickness: 2)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const SignInButton(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
