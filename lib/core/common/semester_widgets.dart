import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpa_calculator/features/home/controllers/courses_provider.dart';
import 'package:gpa_calculator/features/home/controllers/semsters_provider.dart';
import 'package:gpa_calculator/core/common/drop_down_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Themes/theme.dart';

class SemesterWidget extends ConsumerWidget {
  const SemesterWidget({super.key, this.index = 0, this.id = 0});

  final int index;
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listCourseWidgets = ref.watch(courseProvider(id));
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6, bottom: 10),
      child: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: SizedBox(
            width: 800,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Semester ${index + 1}",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      IconButton(
                        onPressed: () => ref
                            .read(semesterProvider.notifier)
                            .deleteSemester(index),
                        icon: const Icon(Icons.close),
                      )
                    ],
                  ),
                ),
                const Labels(),
                ListView.builder(
                  itemCount: listCourseWidgets.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    final data = listCourseWidgets[index];
                    return CourseWidget(
                      id: id,
                      index: index,
                      grade: data.grade,
                    );
                  }),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "GPA:  ${ref.watch(courseProvider(id).notifier).getSemesterGPA()}  ",
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(fontSize: 20),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.watch(courseProvider(id).notifier).addCourse();
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green),
                      child: const Row(
                        children: [
                          Icon(Icons.add_circle_outline),
                          SizedBox(width: 10),
                          Text("Add Course"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CourseWidget extends ConsumerWidget {
  const CourseWidget({
    super.key,
    this.grade = "",
    this.index = 0,
    this.id = 0,
  });

  final String grade;
  final int index;
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseData = ref.watch(courseProvider(id))[index];
    final notifier = ref.watch(courseProvider(id).notifier);
    final courseName = courseData.courseName;
    final courseCredits = courseData.courseCredits;
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) => notifier.removeCourse(index),
      child: Padding(
        padding: const EdgeInsets.only(top: 14, left: 20, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: TextFormField(
                  controller: courseName,
                  decoration: const InputDecoration(),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: GPADropdown(
                  updateGrade: (String grade) => ref
                      .watch(courseProvider(id).notifier)
                      .changeGrade(grade, index),
                  selectedValue: courseData.grade,
                  id: id,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: TextFormField(
                  controller: courseCredits,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) => notifier.update(),
                  decoration: const InputDecoration(),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () => notifier.removeCourse(index),
                icon: const Icon(
                  Icons.close,
                  color: primary300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Labels extends StatelessWidget {
  const Labels({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Text("Course Name",
                  style: Theme.of(context).textTheme.labelLarge),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child:
                  Text("Grade", style: Theme.of(context).textTheme.labelLarge),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text("Credits",
                  style: Theme.of(context).textTheme.labelLarge),
            ),
          ),
          const Expanded(flex: 1, child: SizedBox())
        ],
      ),
    );
  }
}
