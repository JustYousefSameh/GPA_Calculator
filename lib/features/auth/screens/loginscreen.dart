import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_calculator/core/common/sign_in_button.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void navigateToRegisterPage(BuildContext context) {
    Routemaster.of(context).push('/signup-screen');
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
                      totalRepeatCount: 1,
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
                          const SizedBox(height: 25),
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Cannot be empty';
                              }
                              return null;
                            },
                            controller: passwordTextController,
                            decoration: const InputDecoration(),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                //TODO: add forgot password function
                              },
                              child: const Text(
                                "Forgot password?",
                                style:
                                    TextStyle(fontSize: 17, color: Colors.blue),
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
                              'Login',
                              style: GoogleFonts.lato(fontSize: 20),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?  ",
                                  style: TextStyle(fontSize: 15)),
                              GestureDetector(
                                onTap: () => navigateToRegisterPage(context),
                                child: const Text(
                                  "Register Now",
                                  style: TextStyle(
                                      fontSize: 15,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Row(
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
