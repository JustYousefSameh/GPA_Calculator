import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_calculator/Themes/theme.dart';
import 'package:gpa_calculator/core/common/sign_in_button.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

//TODO: refractor code alot of it is repeated
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void navigateToRegisterPage(BuildContext context) {
    Routemaster.of(context).replace('/signup-screen');
  }

  void signInWithEmailAndPassword(BuildContext context, WidgetRef ref,
      String emailAddress, String password) {
    ref
        .read(authControllerProvider.notifier)
        .singInWithEmailAndPassowrd(context, emailAddress, password);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailTextController = TextEditingController();
    final passwordTextController = TextEditingController();

    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        TypewriterAnimatedText('Welcome to GPA Calculator',
                            textStyle: GoogleFonts.roboto(
                                fontSize: 20.0, color: Colors.black)),
                      ],
                    ),
                  ),
                  Image.asset(
                    "assets/images/loginscreenphoto.png",
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Email',
                                style: GoogleFonts.roboto(
                                    fontSize: 15, color: Colors.black)),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: emailTextController,
                            decoration: InputDecoration(
                                // floatingLabelAlignment:
                                //     FloatingLabelAlignment.start,
                                // label: const Text(
                                //   "Email",
                                //   style: TextStyle(fontSize: 18),
                                // ),
                                // floatingLabelBehavior:
                                //     FloatingLabelBehavior.always,
                                hintStyle: GoogleFonts.roboto(),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
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
                            controller: passwordTextController,
                            decoration: InputDecoration(
                                hintStyle: GoogleFonts.roboto(),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                //TODO: add forgot password function
                              },
                              child: Text(
                                "Forgot password?",
                                style: elevatedButtonTextStyle.copyWith(
                                    fontSize: 17, color: Colors.blue),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => signInWithEmailAndPassword(
                              context,
                              ref,
                              emailTextController.text,
                              passwordTextController.text,
                            ),
                            child: Text(
                              'Log in',
                              style: elevatedButtonTextStyle.copyWith(
                                  color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?  ",
                                style: elevatedButtonTextStyle.copyWith(
                                    fontSize: 15),
                              ),
                              GestureDetector(
                                onTap: () => navigateToRegisterPage(context),
                                child: Text(
                                  "Register Now",
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
                                child:
                                    Text("Or", style: TextStyle(fontSize: 18)),
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
