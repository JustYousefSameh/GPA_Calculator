import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/core/constants/constants.dart';
import 'package:gpa_calculator/features/semesters/controller/gradetoscale_controller.dart';
import 'package:gpa_calculator/models/grade_scale_model.dart';

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
