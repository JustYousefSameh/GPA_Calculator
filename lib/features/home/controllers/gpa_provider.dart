import 'package:gpa_calculator/features/home/controllers/courses_provider.dart';
import 'package:gpa_calculator/features/home/controllers/semsters_provider.dart';
import 'package:gpa_calculator/core/common/semester_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GPANotifier extends Notifier<double> {
  @override
  build() {
    return getGPA();
  }

  double getGPA() {
    {
      double gpa = 0;
      double totalCredits = 0;

      for (SemesterWidget semesterWidget
          in ref.watch(semesterProvider).listOfWidgets) {
        var notifier = ref.watch(courseProvider(semesterWidget.id).notifier);
        if (notifier.getSemesterGPA() == 0) continue;
        gpa += (notifier.getSemesterGPA() * notifier.getTotalCredit());
        totalCredits += notifier.getTotalCredit();
      }
      var result = double.parse((gpa / totalCredits).toStringAsPrecision(3));
      state = result.isNaN ? 0 : result;
      return state;
    }
  }
}

final gpaProvider = NotifierProvider<GPANotifier, double>(() => GPANotifier());
