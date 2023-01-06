import 'package:flutter/material.dart';
import 'package:mediamanager_flutter/pages/HomePage/MoviesPage/movies_page.dart';
import 'package:mediamanager_flutter/pages/HomePage/TVShowsPage/tv_shows_page.dart';
import 'package:mediamanager_flutter/pages/ProfilePage/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.movie_outlined),
            label: 'Movies',
          ),
          NavigationDestination(
            icon: Icon(Icons.tv),
            label: 'TV Shows',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            label: "Profile",
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          MoviesPage(),
          TVShowsPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}
