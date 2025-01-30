import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/core/common/constants.dart';
import 'package:gpa_calculator/core/utils.dart';
import 'package:gpa_calculator/features/semesters/controller/gradetoscale_controller.dart';
import 'package:gpa_calculator/models/grade_scale_model.dart';

class GradeScaleWidget extends ConsumerStatefulWidget {
  final int index;

  const GradeScaleWidget({
    super.key,
    required this.index,
  });

  @override
  ConsumerState<GradeScaleWidget> createState() => _GradeScaleWidgetState();
}

class _GradeScaleWidgetState extends ConsumerState<GradeScaleWidget> {
  final gradeScaleTextController = TextEditingController();

  late final GradeToScaleController controller =
      ref.read(gradeToScaleControllerProvider.notifier);

  FocusNode focusNode = FocusNode();

  int? creditCursorPosition;
  String? lastGradeScaleText;

  late GradeToScale gradeToScale;

  String removeDecimalZeroFormat(double n) {
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    return n.toString().replaceAll(regex, '');
  }

  @override
  void dispose() {
    focusNode.dispose();
    gradeScaleTextController.dispose();
    super.dispose();
  }

  void updateLocal({bool? isEnabled, bool isEmpty = false}) {
    lastGradeScaleText = gradeScaleTextController.text;
    creditCursorPosition = gradeScaleTextController.selection.baseOffset;

    controller.updateLocalMap(
      widget.index,
      gradeToScale.copyWith(
        map: {
          gradeToScale.map.entries.first.key:
              gradeScaleTextController.text.isEmpty
                  ? 0.0
                  : double.parse(gradeScaleTextController.text)
        },
        isEnabled: isEnabled,
      ),
    );
  }

  //TODO : changes here should be handled as CourseWidget
  @override
  Widget build(BuildContext context) {
    gradeToScale = ref.watch(gradeToScaleControllerProvider
        .select((value) => value.value![widget.index]));

    final isEnabled = gradeToScale.isEnabled;
    final map = gradeToScale.map.entries.first;

    // if the value is the same as the default value & the node is not focused
    // this means we're ressitting it to the default value
    if (map.value == Constants.gradeScale[widget.index].map[map.key] &&
        !focusNode.hasPrimaryFocus) {
      lastGradeScaleText = null;
    }
    gradeScaleTextController.text = lastGradeScaleText ?? map.value.toString();

    creditCursorPosition ??= gradeScaleTextController.text.length;
    creditCursorPosition =
        creditCursorPosition! > gradeScaleTextController.text.length
            ? gradeScaleTextController.text.length
            : creditCursorPosition;

    gradeScaleTextController.selection = TextSelection.fromPosition(
      TextPosition(
          offset: creditCursorPosition ?? gradeScaleTextController.text.length),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                focusNode: focusNode,
                enabled: isEnabled,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(5),
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
                  SinglePeriodEnforcer()
                ],
                keyboardType: TextInputType.number,
                onChanged: (newValue) {
                  if (newValue.isEmpty) {
                    updateLocal(isEmpty: true);
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
                // decoration:
                //     const InputDecoration(contentPadding: EdgeInsets.zero),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: IconButton(
                icon: isEnabled
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
                onPressed: () {
                  updateLocal(isEnabled: !isEnabled);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
