import 'package:flutter/material.dart';

import 'add_semester_button.dart';
import 'semester_list_view.dart';

GlobalKey<AnimatedListState> semesterListKey = GlobalKey<AnimatedListState>();

class SemesterWithButton extends StatefulWidget {
  const SemesterWithButton({
    super.key,
  });

  @override
  State<SemesterWithButton> createState() => _SemesterWithButtonState();
}

class _SemesterWithButtonState extends State<SemesterWithButton>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  final _controller = ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    animation.forward();
    super.initState();
  }

  @override
  void dispose() {
    animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.2, 0),
            end: const Offset(0, 0),
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.ease,
            ),
          ),
          child: SemesterListView(scrollController: _controller),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: ScaleTransition(
            scale: CurvedAnimation(parent: animation, curve: Curves.ease),
            child: AddSemesterButton(
              scrollController: _controller,
            ),
          ),
        )
      ],
    );
  }
}
