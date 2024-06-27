import 'package:MayTeam/core/constant/ui_const.dart';
import 'package:flutter/material.dart';

class NavigationTile extends StatelessWidget {
  const NavigationTile({
    super.key,
    this.title,
    this.leading,
    this.trailing = const Icon(Icons.arrow_forward_ios),
    this.leadingPadding = UIConst.paddingValue,
    this.trailingPadding = UIConst.paddingValue,
    this.iconSize = 20,
  });

  final String? title;
  final Icon? leading;
  final Icon? trailing;
  final double leadingPadding;
  final double trailingPadding;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final didSetLeading = leading != null;
    final didSetTrailing = trailing != null;
    final didSetTitle = title != null;
    return Row(
      children: [
        ...didSetLeading
            ? [
                buildIcon(leading),
                SizedBox(width: leadingPadding),
              ]
            : [],
        didSetTitle ? Text(title!) : UIConst.zeroGap,
        ...didSetTrailing
            ? [
                const Spacer(),
                SizedBox(width: trailingPadding),
                buildIcon(trailing),
              ]
            : [],
      ],
    );
  }

  Widget buildIcon(Icon? icon) {
    return SizedBox.square(dimension: iconSize, child: FittedBox(child: icon));
  }
}
