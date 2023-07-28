import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_calculator/core/constants/constants.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/features/home/controllers/semsters_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/features/home/drawers/profile_drawer.dart';
import '../../../Themes/theme.dart';
import '../controllers/gpa_provider.dart';

class AppMainScreen extends ConsumerWidget {
  const AppMainScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    void displayEndDrawer(BuildContext context) {
      Scaffold.of(context).openEndDrawer();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "GPA Calculator",
            style: GoogleFonts.rubik(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: secondary300,
            ),
          ),
          actions: <Widget>[
            const CumlativeGPA(),
            const AddSemesterButton(),
            Builder(builder: (context) {
              return IconButton(
                onPressed: () => displayEndDrawer(context),
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user!.profilePic == ''
                      ? Constants.avatarDefault
                      : user.profilePic),
                ),
              );
            })
          ],
        ),
        endDrawer: const ProfileDrawer(),
        body: const SafeArea(child: SemesterListView()));
  }
}

class CumlativeGPA extends ConsumerWidget {
  const CumlativeGPA({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Text(
        "Total GPA : ${ref.watch(gpaProvider)}",
        style: GoogleFonts.rubik(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: secondary300,
        ),
      ),
    );
  }
}

class SemesterListView extends ConsumerWidget {
  const SemesterListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final semesters = ref.watch(semesterProvider).listOfWidgets;
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: semesters.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            semesters[index],
            if (index != semesters.length - 1)
              const Divider(
                indent: 40,
                endIndent: 40,
                thickness: 2,
              )
          ],
        );
      },
    );
  }
}

class AddSemesterButton extends ConsumerWidget {
  const AddSemesterButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: IconButton(
        icon: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () {
          try {
            ref.read(semesterProvider.notifier).addSemester();
          } on Exception catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}
