import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_calculator/core/common/semester_widgets.dart';
import 'package:gpa_calculator/core/constants/constants.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/features/database/semsters_controller.dart';
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
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/icons/GPA_NoText.png', width: 50),
            Text(
              "GPA Calculator",
              style: GoogleFonts.rubik(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: secondary300,
              ),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.only(right: 5),
                child: IconButton(
                  onPressed: () => displayEndDrawer(context),
                  icon: CircleAvatar(
                    backgroundImage: NetworkImage(user!.profilePic == ''
                        ? Constants.avatarDefault
                        : user.profilePic),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      endDrawer: const ProfileDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: GestureDetector(
        onTap: () {
          print('asdsa');
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: const Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  SemesterListView(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: AddSemesterButton(),
                  )
                ],
              ),
            ),
            Divider(),
            CumlativeGPA()
          ],
        ),
      ),
    );
  }
}

class CumlativeGPA extends ConsumerWidget {
  const CumlativeGPA({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Credits Total",
                style: GoogleFonts.rubik(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Text(
                "Your GPA",
                style: GoogleFonts.rubik(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${ref.watch(gpaStateProvider)[1]}',
                style: GoogleFonts.rubik(
                  fontSize: 23,
                  color: Colors.black,
                ),
              ),
              Text(
                '${ref.watch(gpaStateProvider)[0]}',
                style: GoogleFonts.rubik(
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                  color: secondary300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SemesterListView extends ConsumerWidget {
  const SemesterListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final semesters = ref.watch(semesterStreamProvider);
    return semesters.when(
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
      ),
      error: (error, stackTrace) => Text(error.toString()),
      data: (semesterData) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: semesterData.length,
          itemBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SemesterWidget(
                  index: index,
                  semsesterModel: semesterData[index],
                ),
                if (index != semesterData.length - 1)
                  const Divider(
                    indent: 40,
                    endIndent: 40,
                    thickness: 2,
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class AddSemesterButton extends ConsumerWidget {
  const AddSemesterButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: secondary300),
          child: const Icon(
            Icons.add,
            size: 33,
            color: Colors.white,
          ),
        ),
      ),
      onTap: () {
        try {
          ref.read(semesterControllerProvider).addSemester();
        } on Exception catch (e) {
          print(e);
        }
      },
    );
  }
}
