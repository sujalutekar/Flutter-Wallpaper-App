import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilteredRowComponent extends StatelessWidget {
  final String title;
  final String imgUrl;
  final void Function()? onTap;
  const FilteredRowComponent({
    super.key,
    required this.title,
    required this.imgUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
          image: DecorationImage(
            opacity: 0.6,
            image: AssetImage(
              imgUrl,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.oswald(
              letterSpacing: 1,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
