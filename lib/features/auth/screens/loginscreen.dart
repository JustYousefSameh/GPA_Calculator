import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_calculator/core/common/sign_in_button.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void navigateToRegisterPage(BuildContext context) {
    setState(() {
      validationMode = AutovalidateMode.disabled;
    });
    _formKey.currentState?.reset();
    context.go('/signup');
  }

  void signInWithEmailAndPassword(BuildContext context, WidgetRef ref,
      String emailAddress, String password) {
    ref
        .read(authControllerProvider.notifier)
        .singInWithEmailAndPassowrd(context, emailAddress, password);
  }

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  var validationMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sign in'),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Form(
                    autovalidateMode: validationMode,
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          "Welcome Back",
                          style: GoogleFonts.roboto(
                            fontSize: 34.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Sign in with email and password \nor continue with google",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email',
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          controller: emailTextController,
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              suffixIcon: Icon(Icons.email_outlined),
                              suffixIconColor: Colors.black54),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          // autovalidateMode: validationMode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          controller: passwordTextController,
                          decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.lock),
                              suffixIconColor: Colors.black54),
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
                        const SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              signInWithEmailAndPassword(
                                context,
                                ref,
                                emailTextController.text,
                                passwordTextController.text,
                              );
                            } else {
                              setState(() {
                                validationMode = AutovalidateMode.always;
                              });
                            }
                          },
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
                              onTap: () {
                                navigateToRegisterPage(context);
                              },
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
                              child: Text(
                                "Or",
                                style: TextStyle(fontSize: 18),
                              ),
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
              ),
            ),
    );
  }
}
