import 'package:MayTeam/core/constant/color.dart';
import 'package:flutter/material.dart';

class AppAppbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onTap;
  final Animation<double>? progress;
  final bool isDrawer;
  final List<Widget> actions;

  const AppAppbar({
    super.key,
    this.onTap,
    this.progress,
    required this.isDrawer,
    required this.actions
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
    );
  }
}