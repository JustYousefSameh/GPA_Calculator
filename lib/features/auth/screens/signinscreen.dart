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

  late final controller = ref.read(authControllerProvider.notifier);

  void navigateToRegisterPage(BuildContext context) {
    setState(() {
      validationMode = AutovalidateMode.disabled;
    });
    _formKey.currentState?.reset();
    context.go('/signup');
  }

  void signInWithEmailAndPassword(
    BuildContext context,
    WidgetRef ref,
    String emailAddress,
    String password,
  ) {
    controller.singInWithEmailAndPassowrd(context, emailAddress, password);
  }

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  AutovalidateMode validationMode = AutovalidateMode.disabled;

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
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 80),
                        Text(
                          'Sign in',
                          style: GoogleFonts.roboto(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'with email and password \nor continue with google',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Form(
                          autovalidateMode: validationMode,
                          key: _formKey,
                          child: Column(
                            children: [
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
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  suffixIcon: const Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
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
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
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
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  suffixIcon: const Icon(Icons.lock),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () => context.push('/forgotpassword'),
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        FilledButton(
                          style: FilledButton.styleFrom(
                              minimumSize: Size.fromHeight(50)),
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();

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
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?  ",
                              style: TextStyle(fontSize: 15),
                            ),
                            GestureDetector(
                              onTap: () {
                                navigateToRegisterPage(context);
                              },
                              child: const Text(
                                'Register Now',
                                style: TextStyle(
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (isLoading) const LinearProgressIndicator(),
                        const Spacer(),
                        const Row(
                          children: [
                            Expanded(child: Divider(thickness: 2)),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                'Or',
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
          ),
        ),
      ),
    );
  }
}
