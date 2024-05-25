import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:banking_app/constants/routes.dart';

class RootAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RootAppBar({
    super.key,
    required this.title,
  });

  final title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: AppBar(
        title: Text(this.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => context.push(Routes.profile),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
