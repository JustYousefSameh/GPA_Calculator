import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/common/sign_in_button.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  var validationMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void navigateToLoginPage(BuildContext context) {
      context.go('/login');
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
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
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
                    "Register Account",
                    style: GoogleFonts.roboto(
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Complete your details or sign up \nwith google",
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
                      'Name',
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    controller: userNameTextController,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.perm_identity),
                      suffixIconColor: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 15),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      // You can add more email validation here if needed
                      return null;
                    },
                    controller: emailTextController,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.email_outlined),
                      suffixIconColor: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 15),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      // You can add more password validation here if needed
                      return null;
                    },
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: passwordTextController,
                    decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.lock),
                        suffixIconColor: Colors.black54),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signUpWithEmailAndPassword(
                            context,
                            ref,
                            userNameTextController.text,
                            emailTextController.text,
                            passwordTextController.text);
                      }

                      setState(() {
                        validationMode = AutovalidateMode.always;
                      });
                    },
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
        ),
      ),
    );
  }
}
