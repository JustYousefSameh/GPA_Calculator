import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gpa_calculator/core/constants/constants.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/features/semesters/controller/gradetoscale_controller.dart';
import 'package:gpa_calculator/features/semesters/controller/user_doc_controller.dart';
import 'package:gpa_calculator/features/theme_provider.dart';
import 'package:gpa_calculator/models/grade_scale_model.dart';

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
                    // Text(
                    //   'Settings',
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .displaySmall!
                    //       .copyWith(
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    // ),
                    // SizedBox(height: 16),
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

class CustomGPA extends ConsumerWidget {
  const CustomGPA({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradeToNumberProvider = ref.watch(gradeToScaleProvider);

    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.school_rounded),
            SizedBox(width: 5),
            Text(
              "Custom GPA",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "Grade",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 19),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "Credits",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 19),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      "Visibility",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 19),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              gradeToNumberProvider.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, stackTrace) => const Text("got error"),
                data: (data) {
                  return ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: data
                        .mapWithIndex(
                          (e, index) => GradeScaleWidget(
                            gradeToScale: e,
                            index: index,
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DarkMode extends ConsumerWidget {
  const DarkMode({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(Icons.dark_mode_rounded),
            SizedBox(width: 5),
            Text(
              "Theme",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        SizedBox(
          width: 100,
          height: 45,
          child: DropdownButtonFormField<ThemeMode>(
            borderRadius: BorderRadius.circular(10),
            value: ref.watch(themeControllerProvider),
            items: [
              DropdownMenuItem(
                child: Text('Light'),
                value: ThemeMode.light,
              ),
              DropdownMenuItem(
                child: Text('Dark'),
                value: ThemeMode.dark,
              ),
              DropdownMenuItem(
                child: Text('System'),
                value: ThemeMode.system,
              ),
            ],
            onChanged: (value) =>
                ref.read(themeControllerProvider.notifier).setTheme(value!),
            decoration: InputDecoration(contentPadding: EdgeInsets.zero),
          ),
        ),
      ],
    );
  }
}

class UserInfo extends ConsumerWidget {
  const UserInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDocProvider);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border:
            Border.all(color: Theme.of(context).colorScheme.onInverseSurface),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: user.value!.profilePic == ''
                  ? CachedNetworkImage(
                      memCacheWidth: 50,
                      width: 50,
                      imageUrl: Constants.avatarDefault,
                    )
                  : CachedNetworkImage(
                      memCacheWidth: 50,
                      width: 50,
                      imageUrl: user.value!.profilePic,
                    ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.value!.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(user.value!.emailAddress),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () => ref.read(authControllerProvider.notifier).logout(),
              child: Icon(
                Icons.logout_outlined,
                color: const Color.fromARGB(255, 141, 141, 141),
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradeScaleWidget extends ConsumerStatefulWidget {
  final GradeToScale gradeToScale;
  final int index;

  const GradeScaleWidget({
    super.key,
    required this.gradeToScale,
    required this.index,
  });

  @override
  ConsumerState<GradeScaleWidget> createState() => _GradeScaleWidgetState();
}

class _GradeScaleWidgetState extends ConsumerState<GradeScaleWidget> {
  final gradeScaleTextController = TextEditingController();
  final focusNode = FocusNode();
  late bool isEnabled;

  @override
  void initState() {
    isEnabled = widget.gradeToScale.isEnabled;
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    gradeScaleTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final map = widget.gradeToScale.map.entries.first;
    gradeScaleTextController.text =
        map.value.toString().replaceAll(Constants.regex, '');
    final controller = ref.read(gradeToScaleProvider.notifier);

    void updateLocal({bool? isEnabled}) {
      controller.updateLocalMap(
        widget.index,
        widget.gradeToScale.copyWith(
          map: {
            map.key: gradeScaleTextController.text.isEmpty
                ? 0.0
                : double.parse(gradeScaleTextController.text)
          },
          isEnabled: isEnabled,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Text(
              map.key,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isEnabled
                    ? Theme.of(context).textTheme.bodySmall!.color
                    : Theme.of(context).disabledColor,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: TextField(
                focusNode: focusNode,
                enabled: isEnabled,
                inputFormatters: [LengthLimitingTextInputFormatter(5)],
                keyboardType: TextInputType.number,
                onChanged: (newValue) {
                  if (newValue.isEmpty) {
                    updateLocal();
                    return;
                  }
                  final newValueAfterregex = double.parse(newValue)
                      .toString()
                      .replaceAll(Constants.regex, '');

                  final value =
                      map.value.toString().replaceAll(Constants.regex, '');

                  if (newValueAfterregex != value &&
                      newValue.substring(newValue.length - 1) != '.') {
                    updateLocal();
                  }
                },
                controller: gradeScaleTextController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(contentPadding: EdgeInsets.zero),
              ),
            ),
          ),
          // SizedBox(
          //   width: 45,
          //   child: IconButton(
          //     onPressed: isEnabled ? () => focusNode.requestFocus() : null,
          //     icon: Icon(
          //       Icons.edit,
          //     ),
          //   ),
          // ),
          Expanded(
            child: Center(
              child: IconButton(
                icon: Icon(isEnabled ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    isEnabled = !isEnabled;
                  });
                  updateLocal(isEnabled: isEnabled);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
