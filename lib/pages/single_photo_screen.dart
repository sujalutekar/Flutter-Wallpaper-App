import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';

import '../components/bottom_container.dart';

class SinglePhotoScreen extends StatefulWidget {
  final String imageUrl;
  final String photographer;
  const SinglePhotoScreen({
    super.key,
    required this.imageUrl,
    required this.photographer,
  });

  @override
  State<SinglePhotoScreen> createState() => _SinglePhotoScreenState();
}

class _SinglePhotoScreenState extends State<SinglePhotoScreen> {
  bool _isLoading = false;

  showSnackBar(String title) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
      ),
    );
  }

  Future<void> setHomeScreenWallpaper() async {
    try {
      setState(() {
        _isLoading = true;
      });

      int location = WallpaperManager.HOME_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);
      await WallpaperManager.setWallpaperFromFile(file.path, location);

      setState(() {
        _isLoading = false;
      });

      showSnackBar('Wallpaper Set Successfully');
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> setLockScreenWallpaper() async {
    try {
      setState(() {
        _isLoading = true;
      });

      int location = WallpaperManager.LOCK_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);
      await WallpaperManager.setWallpaperFromFile(file.path, location);

      setState(() {
        _isLoading = false;
      });

      showSnackBar('Wallpaper Set Successfully');
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> setBothScreenWallpaper() async {
    try {
      setState(() {
        _isLoading = true;
      });

      int location = WallpaperManager.BOTH_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);
      await WallpaperManager.setWallpaperFromFile(file.path, location);

      setState(() {
        _isLoading = false;
      });

      showSnackBar('Wallpaper Set Successfully');
    } catch (e) {
      throw e.toString();
    }
  }

  void _donwloadImage() async {
    try {
      setState(() {
        _isLoading = true;
      });

      String url = widget.imageUrl;
      var response = await http.get(Uri.parse(url));
      final result = await ImageGallerySaver.saveImage(
        response.bodyBytes,
        name: 'PixelWall - ${widget.photographer}',
      );

      print(result);

      setState(() {
        _isLoading = false;
      });

      showSnackBar('Image saved in your gallery');
    } catch (e) {
      showSnackBar(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDetails() {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Details',
                  style: GoogleFonts.oswald(
                    letterSpacing: 1,
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Photographer name : ${widget.photographer}',
                style: GoogleFonts.oswald(
                  letterSpacing: 1,
                  fontSize: 18,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _donwloadImage();
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Donwload Image'),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 70)
                    .copyWith(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Photo provided by',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // const url = 'https://www.pexels.com/';
                        // await launchUrl(Uri.parse(url));
                      },
                      child: const Image(
                        height: 40,
                        image: AssetImage('assets/images/pexels-logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                _isLoading ? const LinearProgressIndicator() : Container(),
              ],
            ),

            // Download Image Button
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => _showDetails(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 7),
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Text(
                        'Details',
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          letterSpacing: 1,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BottomContainer(
                    onTap: () {
                      setHomeScreenWallpaper();
                    },
                    title: 'Home Screen',
                  ),
                  BottomContainer(
                    onTap: setLockScreenWallpaper,
                    title: 'Lock Screen',
                  ),
                  BottomContainer(
                    onTap: setBothScreenWallpaper,
                    title: 'Both Screen',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
