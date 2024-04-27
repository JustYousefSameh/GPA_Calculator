import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/semesters/controller/gradetoscale_controller.dart';

import '../widgets/custom_gpa.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          behavior: HitTestBehavior.translucent,
          child: SafeArea(
            child: BackButtonListener(
              onBackButtonPressed: () {
                ref.read(gradeToScaleProvider.notifier).updateRemoteMap();
                return Future.value(false);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserInfo(),
                    SizedBox(height: 16),
                    DarkMode(),
                    SizedBox(height: 4),
                    Divider(thickness: 2),
                    SizedBox(height: 4),
                    CustomGPA(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
