import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class BottomContainer extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  const BottomContainer({
    super.key,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        child: Text(
          title,
          style: GoogleFonts.oswald(
            letterSpacing: 2,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
