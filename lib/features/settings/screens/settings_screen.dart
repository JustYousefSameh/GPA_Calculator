import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';

import '../widgets/dark_mode.dart';
import '../widgets/user_info.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
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
                    Spacer(),
                    Row(
                      children: [
                        SizedBox(
                          child: TextButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
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
                                      onPressed: () {
                                        ref
                                            .read(
                                                authControllerProvider.notifier)
                                            .deleteAccount();
                                        Navigator.pop(context, "Cancel");
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
                              );
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
                            icon: Icon(
                              Icons.info_outline_rounded,
                              size: 25,
                            ),
                            label: Text(
                              "About Developer",
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
        if (ref.watch(authControllerProvider))
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
