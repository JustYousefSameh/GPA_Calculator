import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../../../Themes/theme.dart';
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
            Image.asset('assets/images/signupscreenphoto.png'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Welcome to GPA Calculator",
                        style: elevatedButtonTextStyle.copyWith(
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: userNameTextController,
                      decoration: InputDecoration(
                          hintText: "Enter your name",
                          hintStyle: GoogleFonts.roboto(),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailTextController,
                      decoration: InputDecoration(
                          hintText: "Enter your email",
                          hintStyle: GoogleFonts.roboto(),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: passwordTextController,
                      decoration: InputDecoration(
                          hintText: "Enter your password",
                          hintStyle: GoogleFonts.roboto(),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => signUpWithEmailAndPassword(
                          context,
                          ref,
                          userNameTextController.text,
                          emailTextController.text,
                          passwordTextController.text),
                      child: Text(
                        'Sign up',
                        style: elevatedButtonTextStyle.copyWith(
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?  ",
                          style: elevatedButtonTextStyle.copyWith(fontSize: 15),
                        ),
                        GestureDetector(
                          onTap: () => navigateToLoginPage(context),
                          child: Text(
                            "Login",
                            style: elevatedButtonTextStyle.copyWith(
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
            )
          ],
        ),
      ),
    );
  }
}
