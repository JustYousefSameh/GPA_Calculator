import 'package:flutter/material.dart';

import 'add_semester_button.dart';
import 'semester_list_view.dart';

GlobalKey<AnimatedListState> semesterListKey = GlobalKey<AnimatedListState>();

class SemesterWithButton extends StatelessWidget {
  SemesterWithButton({
    super.key,
  });

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SemesterListView(
          scrollController: _controller,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: AddSemesterButton(
            scrollController: _controller,
          ),
        )
      ],
    );
  }
}
