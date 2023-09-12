import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../widgets/search_box.dart';
import '../widgets/flitered_row.dart';
import '../pages/single_photo_screen.dart';
import '../constants/api_key.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List images = [];
  String selectedFilter = '';
  int page = 1;
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showButton = false;

  showSnackBar(String title) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
      ),
    );
  }

  Future<void> _scrollUp() async {
    setState(() {
      _isLoading = true;
    });

    await _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 2000),
      curve: Curves.fastEaseInToSlowEaseOut,
    );

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> fetchApi() async {
    try {
      await http.get(
        Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization': apiKey,
        },
      ).then((value) {
        Map result = jsonDecode(value.body);
        setState(() {
          images = result['photos'];
          images.shuffle();
          images.shuffle();
        });
        print(result);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> searchImage(String value) async {
    String searchResult = value.toLowerCase();

    setState(() {
      _isLoading = true;
    });

    String url =
        'https://api.pexels.com/v1/search?query=$searchResult&page=$page&per_page=80';

    if (searchResult.isEmpty) {
      return;
    }

    try {
      await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': apiKey,
        },
      ).then((value) {
        Map result = jsonDecode(value.body);
        setState(() {
          images = result['photos'];
          images.shuffle();
        });
      });
    } catch (e) {
      throw Exception(e.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> loadMore() async {
    String searchResult = '';
    String searchText = _searchController.text.toLowerCase();

    if (searchText.isNotEmpty && selectedFilter.isEmpty) {
      print('1');
      searchResult = searchText;
    }
    if (searchText.isEmpty && selectedFilter.isNotEmpty) {
      print('2');
      searchResult = selectedFilter;
    }
    if (searchText.isNotEmpty && selectedFilter.isNotEmpty) {
      print('3');
      searchResult = searchText;
    }

    setState(() {
      _isLoading = true;
    });

    setState(() {
      page = page + 1;
    });

    String defaultUrl =
        'https://api.pexels.com/v1/curated?per_page=80&page=$page';
    String searchUrl =
        'https://api.pexels.com/v1/search?query=$searchResult&page=$page&per_page=80';

    String url = searchResult.isEmpty ? defaultUrl : searchUrl;

    await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': apiKey,
      },
    ).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchApi();

    _scrollController.addListener(() {
      if (_scrollController.offset > 1500) {
        setState(() {
          _showButton = true;
        });
      } else {
        setState(() {
          _showButton = false;
        });
      }
      // print(_scrollController.offset);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Pixel Wallpapers',
          style: GoogleFonts.oswald(letterSpacing: 5),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: mobileBackgroundColor,
      ),
      floatingActionButton: _showButton
          ? SizedBox(
              height: 42,
              width: 42,
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: Colors.black38,
                onPressed: _scrollUp,
                child: const Icon(
                  Icons.arrow_upward_outlined,
                  color: Colors.white,
                ),
              ),
            )
          : Container(),
      body: Stack(
        children: [
          Column(
            children: [
              SearchBox(
                controller: _searchController,
                onSubmitted: (value) async {
                  await searchImage(value);
                  _scrollUp();
                },
                onSearchPressed: () {
                  searchImage(_searchController.text.toLowerCase());
                  setState(() {
                    FocusScope.of(context).unfocus();
                  });
                },
              ),
              FilteredRow(
                onChange: (value) => searchImage(value),
                onTaped: (value) async {
                  setState(() {
                    selectedFilter = value;
                    print(selectedFilter);
                  });
                  _scrollUp();
                  _searchController.clear();
                },
              ),
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(
                      top: 10, left: 7, right: 7, bottom: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.6,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SinglePhotoScreen(
                              imageUrl: images[index]['src']['large2x'],
                              photographer: images[index]['photographer'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 80, 79, 79),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            images[index]['src']['large2x'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              _isLoading ? const LinearProgressIndicator() : Container(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 120, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(30),
              ),
              child: InkWell(
                onTap: () => loadMore(),
                child: Center(
                  child: Text(
                    'Load More',
                    style: GoogleFonts.oswald(
                      letterSpacing: 2,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
