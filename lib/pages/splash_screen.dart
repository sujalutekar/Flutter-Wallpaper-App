import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixelwall/pages/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: const Image(
                image: AssetImage('assets/images/pixelwall-logo2.png'),
              ),
            ),
          ),
          Container(
            height: 100,
            child: Text(
              'Pixel Wall',
              style: GoogleFonts.oswald(
                fontSize: 18,
                letterSpacing: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
