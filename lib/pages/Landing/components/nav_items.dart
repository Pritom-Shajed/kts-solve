import 'package:flutter/material.dart';

List<BottomNavigationBarItem> get navItems {
  return [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'হোম'),
    BottomNavigationBarItem(
        icon: Icon(Icons.list_alt_outlined), label: 'সকল বিজ্ঞাপন',),
    BottomNavigationBarItem(
        icon: Icon(Icons.favorite_border_sharp), label: 'আমার বিজ্ঞাপন'),
    BottomNavigationBarItem(
        icon: Icon(Icons.person), label:  'অ্যাকাউন্ট'),
  ];
}