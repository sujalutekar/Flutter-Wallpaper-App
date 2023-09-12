import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onSubmitted;
  final void Function()? onSearchPressed;

  const SearchBox({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    final InputBorder inputBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(10),
    );

    return Container(
      margin: const EdgeInsets.only(left: 7, right: 7, bottom: 7),
      decoration: BoxDecoration(
        color: mobileBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        onSubmitted: onSubmitted,
        controller: controller,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: 'Search any image, Eg: Ocean Wallpapers',
          hintStyle: GoogleFonts.oswald(letterSpacing: 1),
          enabledBorder: inputBorder,
          focusedBorder: inputBorder,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(left: 7),
          suffixIcon: IconButton(
            onPressed: onSearchPressed,
            icon: const Icon(
              Icons.search,
              size: 27,
            ),
          ),
        ),
      ),
    );
  }
}
