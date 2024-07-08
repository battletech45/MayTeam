import 'package:MayTeam/core/constant/color.dart';
import 'package:flutter/material.dart';

import '../../core/constant/text_style.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onTap;
  final Animation<double>? progress;
  final bool isDrawer;
  final List<Widget> actions;
  final String? title;
  final Widget? leading;
  const AppAppBar({
    super.key,
    this.onTap,
    this.title,
    this.leading,
    this.progress,
    required this.isDrawer,
    this.actions = const <Widget>[],
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.primaryBackgroundColor,
      scrolledUnderElevation: 0.0,
      centerTitle: true,
      title: Text(title ?? 'My Team', style: AppTextStyle.dialogTitle),
      leading: leading ?? (isDrawer ? IconButton(onPressed: onTap, icon: AnimatedIcon(icon: AnimatedIcons.menu_close, progress: progress!)) : null),
      actions: isDrawer ? actions.isNotEmpty ? actions: [] : actions,
    );
  }
}