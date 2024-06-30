import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'category_items_screen.dart';

class HomeScreen extends StatefulWidget {
  final String full_name;
  final int id;

  const HomeScreen({Key? key, required this.full_name, required this.id}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;

  List<String> carouselImages = [
    'https://www.whites.net/s/5e5b8eb5e1a30016118f588f/661b89b1f27c3565913eccf8/wedding-makeup_mobile-banner-1080x1080.jpg',
    'https://www.whites.net/s/5e5b8eb5e1a30016118f588f/667d58c89a3330960179282a/mix-banner-products-june-mobile-eng-1080x1080.jpg',
    'https://www.whites.net/s/5e5b8eb5e1a30016118f588f/66796d828485c7001167a5f1/clara_offer-banner-480x200-f-1080x1080.jpg',
  ];

  int _currentCarouselIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    startCarouselTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startCarouselTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _currentCarouselIndex = (_currentCarouselIndex + 1) % carouselImages.length;
      });
      startCarouselTimer();
    });
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('https://datagrid.sd/slider_android/api/category.php'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          categories = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _logout() {
    //Navigator.pop(context);
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الرئيسية',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
        backgroundColor: Colors.redAccent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pinkAccent, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'مرحبا ${widget.full_name}!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),

            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            const SizedBox(height: 10),
            const Text(
              'أفضل العروض',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 130, // Set the desired height here
              child: CarouselSlider(
                items: carouselImages.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentCarouselIndex = index;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            const SizedBox(height: 20),
            const Text(
              'التصنيفات',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),

            Expanded(
              child: isLargeScreen
                  ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.75,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryCard(category: category, onTap: () => _navigateToCategoryItemsScreen(context, category));
                },
              )
                  : ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryCard(category: category, onTap: () => _navigateToCategoryItemsScreen(context, category));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCategoryItemsScreen(BuildContext context, Map<String, dynamic> category) {
    int catId = int.parse(category['id'].toString()); // Parse id as int
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryItemsScreen(catId: catId),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback onTap;

  const CategoryCard({Key? key, required this.category, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 150,
              child: Image.network(
                category['cat_image_url'],
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                category['cat_name'],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                category['cat_description'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
