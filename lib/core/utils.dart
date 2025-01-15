import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SmoothSlideSize extends StatelessWidget {
  const SmoothSlideSize(
      {super.key, required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.2, 0),
        end: const Offset(0, 0),
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.5, 1, curve: Curves.ease),
        ),
      ),
      child: SizeTransition(
        sizeFactor: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0, 0.5, curve: Curves.ease),
          ),
        ),
        child: child,
      ),
    );
  }
}

void showErrorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        elevation: 0,
        dismissDirection: DismissDirection.vertical,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: double.infinity,
            width: double.infinity,
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.onError,
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    text,
                    maxLines: 3,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.onError),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
}

void showSuccessSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 39, 139, 26),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: double.infinity,
            width: double.infinity,
            child: Row(
              children: [
                const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    text,
                    maxLines: 3,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
}

class SinglePeriodEnforcer extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    // Allow only one period
    if ('.'.allMatches(newText).length <= 1) {
      return newValue;
    }
    return oldValue;
  }
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
