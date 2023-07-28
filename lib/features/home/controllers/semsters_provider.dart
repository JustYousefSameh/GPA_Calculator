import '../../../core/common/semester_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SemesterNotifierData {
  List<SemesterWidget> listOfWidgets = [
    const SemesterWidget(),
  ];
  int id = 0;

  SemesterNotifierData(this.listOfWidgets, this.id);
}

class SemesterNotifier extends Notifier<SemesterNotifierData> {
  @override
  SemesterNotifierData build() {
    return SemesterNotifierData([const SemesterWidget()], 0);
  }

  var courseMap = <int, SemesterWidget>{0: const SemesterWidget()};

  List<SemesterWidget> getList() {
    List<SemesterWidget> newState = [];
    for (int i = 0; i < courseMap.length; i++) {
      newState.add(SemesterWidget(
        index: i,
        id: courseMap.entries.elementAt(i).key,
      ));
    }
    return newState;
  }

  void addSemester() {
    state.id++;
    final newWidget = SemesterWidget(
      index: state.listOfWidgets.length,
      id: state.id,
    );
    final newEntry = <int, SemesterWidget>{state.id: newWidget};
    courseMap.addEntries(newEntry.entries);
    state = SemesterNotifierData(getList(), state.id);
  }

  void deleteSemester(int index) {
    final entryKey = courseMap.entries.elementAt(index).key;
    courseMap.remove(entryKey);
    state = SemesterNotifierData(getList(), state.id);
  }
}

final semesterProvider =
    NotifierProvider<SemesterNotifier, SemesterNotifierData>(
  () => SemesterNotifier(),
);
