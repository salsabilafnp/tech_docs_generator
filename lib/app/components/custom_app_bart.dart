import 'package:flutter/material.dart';
import 'package:tech_docs_generator/utils/dictionary.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  static bool centerTitle = true;

  const CustomAppBar({super.key, required this.pageTitle});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: pageTitle.isNotEmpty
          ? Text(pageTitle, style: TextStyle(fontWeight: FontWeight.bold))
          : Text(Dictionary.appTitle),
      backgroundColor: Colors.lightBlue,
      centerTitle: true,
    );
  }
}
