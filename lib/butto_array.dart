import 'package:flutter/cupertino.dart';

class _HomeScreenState extends State<HomeScreen> {
  List<String> imageUrls = [];
  bool isLoading = true;
  List<String> buttonArray = [
    'Button 1',
    'Button 2',
    'Button 3',
    'Button 4',
    'Button 5',
    'Button 6',
    'Button 7',
    'Button 8',
    'Button 9',
    'Button 10',
    'Button 11',
    'Button 12',
  ];

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

// Remaining code...
}