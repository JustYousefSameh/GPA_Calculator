import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_calculator/core/common/sign_in_button.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  AutovalidateMode validationMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final userNameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  var obscureText = true;

  @override
  void dispose() {
    userNameTextController.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    void navigateToLoginPage(BuildContext context) {
      context.pop();
    }

    void signUpWithEmailAndPassword(
      BuildContext context,
      WidgetRef ref,
      String userName,
      String email,
      String passowrd,
    ) {
      ref
          .read(authControllerProvider.notifier)
          .signUpWithEmailAndPassword(context, userName, email, passowrd);
    }

    return Stack(
      children: [
        Scaffold(
          body: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: Column(
                        children: [
                          const SizedBox(height: 80),
                          Text(
                            'Sign up',
                            style: GoogleFonts.roboto(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Complete your details \nor continue with google',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 40),
                          AutofillGroup(
                            child: Form(
                              autovalidateMode: validationMode,
                              key: _formKey,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Name',
                                      style: GoogleFonts.roboto(
                                        fontSize: 15,
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
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      suffixIcon: Icon(Icons.perm_identity),
                                      // border: OutlineInputBorder(
                                      //   borderRadius: BorderRadius.circular(10),
                                      // ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Email',
                                      style: GoogleFonts.roboto(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  TextFormField(
                                    autofillHints: const [AutofillHints.email],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!RegExp(
                                              r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                          .hasMatch(value)) {
                                        return 'Please enter a valid email address';
                                      }
                                      // You can add more email validation here if needed
                                      return null;
                                    },
                                    controller: emailTextController,
                                    decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      suffixIcon: Icon(Icons.email_outlined),
                                      // border: OutlineInputBorder(
                                      //   borderRadius: BorderRadius.circular(10),
                                      // ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Password',
                                      style: GoogleFonts.roboto(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  TextFormField(
                                    autofillHints: const [
                                      AutofillHints.password
                                    ],
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
                                    obscureText: obscureText,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    controller: passwordTextController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              obscureText = !obscureText;
                                            });
                                          },
                                          icon: obscureText
                                              ? const Icon(Icons.visibility_off)
                                              : const Icon(Icons.visibility)),
                                      // border: OutlineInputBorder(
                                      //   borderRadius: BorderRadius.circular(10),
                                      // ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          FilledButton(
                            style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(50)),
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();

                              if (_formKey.currentState!.validate()) {
                                signUpWithEmailAndPassword(
                                  context,
                                  ref,
                                  userNameTextController.text,
                                  emailTextController.text,
                                  passwordTextController.text,
                                );
                                TextInput.finishAutofillContext();
                              } else {
                                setState(() {
                                  validationMode = AutovalidateMode.always;
                                });
                              }
                            },
                            child: Text(
                              'Sign up',
                              style: GoogleFonts.lato(fontSize: 20),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account?  ',
                                style: TextStyle(fontSize: 15),
                              ),
                              GestureDetector(
                                onTap: () => navigateToLoginPage(context),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: Divider(thickness: 2)),
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child:
                                    Text('Or', style: TextStyle(fontSize: 18)),
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
          }),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withAlpha(127),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }
}
