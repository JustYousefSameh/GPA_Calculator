import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_calculator/core/constants/constants.dart';
import 'package:gpa_calculator/features/auth/controller/auth_controller.dart';
import 'package:gpa_calculator/features/semesters/controller/user_doc_controller.dart';

class UserInfo extends ConsumerWidget {
  const UserInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDocProvider);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border:
            Border.all(color: Theme.of(context).colorScheme.onInverseSurface),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: user.value!.profilePic == ''
                  ? CachedNetworkImage(
                      memCacheWidth: 50,
                      width: 50,
                      imageUrl: Constants.avatarDefault,
                    )
                  : CachedNetworkImage(
                      memCacheWidth: 50,
                      width: 50,
                      imageUrl: user.value!.profilePic,
                    ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.value!.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(user.value!.emailAddress),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () => ref.read(authControllerProvider.notifier).logout(),
              child: Icon(
                Icons.logout_outlined,
                color: const Color.fromARGB(255, 141, 141, 141),
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
