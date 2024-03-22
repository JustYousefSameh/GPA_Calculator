import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:gpa_calculator/core/utils.dart';
import 'package:gpa_calculator/features/semesters/controller/gradetonumber_controller.dart';
import 'package:gpa_calculator/models/grade_scale_model.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradeToNumberController = ref.watch(gradeToNumberControllerProvider);
    final gradeToNumberNotifier =
        ref.read(gradeToNumberControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            gradeToNumberController.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => const Text("got error"),
              data: (data) {
                return ListView(
                    shrinkWrap: true,
                    children: data
                        .mapWithIndex((e, index) => GradeScaleWidget(
                              gradeToScale: e,
                              index: index,
                            ))
                        .toList());
              },
            ),
            ElevatedButton(
                onPressed: () async =>
                    await gradeToNumberNotifier.updateRemoteMap(gradeScale),
                child: const Text("Upadate Values"))
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
  late bool isEnabled;

  @override
  void initState() {
    isEnabled = widget.gradeToScale.isEnabled;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final map = widget.gradeToScale.map.entries.first;
    gradeScaleTextController.text = map.value.toString();
    final controller = ref.read(gradeToNumberControllerProvider.notifier);

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
          ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Checkbox(
              value: isEnabled,
              onChanged: (bool? value) {
                setState(() {
                  isEnabled = value!;
                });
                updateLocal(isEnabled: value);
              }),
          SizedBox(
            width: 60,
            child: Text(map.key),
          ),
          SizedBox(
            width: 60,
            child: TextField(
              enabled: isEnabled,
              keyboardType: TextInputType.number,
              onChanged: (value) => updateLocal(),
              controller: gradeScaleTextController,
            ),
          ),
        ],
      ),
    );
  }
}
