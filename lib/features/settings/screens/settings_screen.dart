import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_calculator/core/utils.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';

import '../widgets/dark_mode.dart';
import '../widgets/user_info.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final authNotifier = ref.watch(authControllerProvider.notifier);
  bool isLoading = false;

  Future<String?> showPasswordDialoug(
      BuildContext context, void Function(bool newvalue) updateLoading) async {
    return showGeneralDialog<String>(
      context: context,
      transitionBuilder: (ctx, a1, a2, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: a1, curve: Curves.ease),
          child: ScaleTransition(
            scale: Tween(begin: 0.2, end: 1.0).animate(
              CurvedAnimation(parent: a1, curve: Curves.ease),
            ),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (newContext, a1, a2) => AlertDialog(
        title: const Text("Confirm your passowrd"),
        content: PasswordAlert(updateLoading: updateLoading),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            title: const Text("Settings"),
          ),
          body: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            behavior: HitTestBehavior.translucent,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const UserInfo(),
                    const SizedBox(height: 8),
                    const DarkMode(),
                    // const Divider(thickness: 2, height: 2),
                    SizedBox(
                      height: 60,
                      child: InkWell(
                        onTap: () {
                          context.push('/settings/customGPA');
                        },
                        borderRadius: BorderRadius.circular(5),
                        child: Row(
                          children: [
                            const Icon(Icons.school_rounded),
                            const SizedBox(width: 12),
                            Text(
                              "Custom GPA",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                    // const Divider(thickness: 2, height: 2),
                    const Spacer(),
                    Row(
                      children: [
                        SizedBox(
                          child: TextButton.icon(
                            onPressed: () {
                              showGeneralDialog<String>(
                                context: context,
                                transitionBuilder: (ctx, a1, a2, child) {
                                  return FadeTransition(
                                    opacity: CurvedAnimation(
                                        parent: a1, curve: Curves.ease),
                                    child: ScaleTransition(
                                      scale:
                                          Tween(begin: 0.2, end: 1.0).animate(
                                        CurvedAnimation(
                                            parent: a1, curve: Curves.ease),
                                      ),
                                      child: child,
                                    ),
                                  );
                                },
                                transitionDuration:
                                    const Duration(milliseconds: 300),
                                pageBuilder: (newContext, a1, a2) =>
                                    AlertDialog(
                                  title: const Text("Delete Account"),
                                  content: Text(
                                    "Deleting your account will remove all your data from the cloud. This action cannot be undone.",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, "Cancel");
                                        },
                                        child: const Text("Cancel")),
                                    TextButton(
                                      onPressed: () async {
                                        //TODO: find a better way to do this. Probably need to rewrite authController
                                        final type = await authNotifier
                                            .determineAccountType();

                                        if (type == "google.com") {
                                          Navigator.pop(context, "google");
                                        } else if (type == "password") {
                                          Navigator.pop(context, "password");
                                        }
                                      },
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ).then((value) async {
                                if (value == "google") {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  final successOfFailure = await authNotifier
                                      .deleteGoogleAccount(context);
                                  successOfFailure.fold(
                                    (l) {
                                      showErrorSnackBar(context, l.message);
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                    (r) {},
                                  );
                                } else if (value == "password") {
                                  showPasswordDialoug(context, (value) {
                                    setState(() {
                                      isLoading = value;
                                    });
                                  }).then((value) {
                                    if (value == "Cancel") {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  });
                                }
                              });
                            },
                            icon: Icon(
                              Icons.delete_forever,
                              size: 25,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            label: Text(
                              "Delete Account",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          child: TextButton.icon(
                            onPressed: () {
                              context.push('/settings/aboutdeveloper');
                            },
                            icon: const Icon(
                              Icons.info_outline_rounded,
                              size: 25,
                            ),
                            label: const Text(
                              "Developer",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (ref.watch(authControllerProvider) || isLoading)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withAlpha(127),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

class PasswordAlert extends ConsumerStatefulWidget {
  const PasswordAlert({
    super.key,
    required this.updateLoading,
  });

  final void Function(bool newValue) updateLoading;

  @override
  ConsumerState<PasswordAlert> createState() => _PasswordAlertState();
}

class _PasswordAlertState extends ConsumerState<PasswordAlert> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  var shouldObscure = true;
  var validationMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Form(
        key: _formKey,
        autovalidateMode: validationMode,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
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
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              controller: emailTextController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                suffixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: Text(
                'Password',
                style: GoogleFonts.roboto(fontSize: 15),
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              autofillHints: const [AutofillHints.password],
              obscureText: shouldObscure,
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      shouldObscure = !shouldObscure;
                    });
                  },
                  icon: shouldObscure
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, "Cancel");
                    },
                    child: const Text("Cancel")),
                TextButton(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();

                    if (_formKey.currentState!.validate()) {
                      widget.updateLoading(true);
                      final successOrFailure = await ref
                          .watch(authControllerProvider.notifier)
                          .deletePasswordAccount(
                              context,
                              emailTextController.text,
                              passwordTextController.text);
                      successOrFailure.fold(
                        (l) {
                          showErrorSnackBar(context, l.message);
                          Navigator.pop(context, "Cancel");
                        },
                        (r) => Navigator.pop(context, "Success"),
                      );
                    } else {
                      setState(() {
                        validationMode = AutovalidateMode.always;
                      });
                    }
                  },
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
