import 'package:flutter/material.dart';

import 'add_semester_button.dart';
import 'semester_list_view.dart';

class SemesterWithButton extends StatelessWidget {
  SemesterWithButton({
    super.key,
  });

  final GlobalKey<AnimatedListState> _semesterListKey =
      GlobalKey<AnimatedListState>();

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SemesterListView(
          listKey: _semesterListKey,
          scrollController: _controller,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: AddSemesterButton(
            listKey: _semesterListKey,
            scrollController: _controller,
          ),
        )
      ],
    );
  }
}
