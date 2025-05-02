import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/shared/styles/color_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? titleIcon;

  final IconData? leadingIcon;
  final VoidCallback? controllerLeading;
  final Widget? leading;

  final IconData? actionIcon;
  final VoidCallback? controllerAction;
  final Widget? action;

  final bool showUnderline;

  const CustomAppBar({
    super.key,
    required this.title,
    this.titleIcon,
    this.leadingIcon,
    this.controllerLeading,
    this.leading,
    this.actionIcon,
    this.controllerAction,
    this.action,
    this.showUnderline = false, 
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading ??
          (leadingIcon != null
              ? IconButton(
                  icon: Icon(leadingIcon, color: ColorStyle.primary),
                  onPressed: controllerLeading ?? () => Get.back(),
                )
              : null),
      actions: [
        if (action != null)
          action!
        else if (actionIcon != null)
          IconButton(
            icon: Icon(actionIcon, color: ColorStyle.primary),
            onPressed: controllerAction,
          ),
      ],
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (titleIcon != null)
                Icon(titleIcon, color: ColorStyle.primary, size: 20),
              if (titleIcon != null) const SizedBox(width: 10),
              Text(
                title.tr,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (showUnderline)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Container(
                width: 65,
                height: 2,
                color: ColorStyle.primary,
              ),
            ),
        ],
      ),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      elevation: 3,
      shadowColor: const Color.fromARGB(66, 0, 0, 0),
      backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
