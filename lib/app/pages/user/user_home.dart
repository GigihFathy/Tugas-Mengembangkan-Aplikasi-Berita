import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aplikasi_berita/app/pages/categories_page.dart';
import 'package:aplikasi_berita/app/pages/user/saved_articles_page.dart';
import 'package:aplikasi_berita/app/providers.dart';
import 'package:aplikasi_berita/widgets/display_articles.dart';
import 'package:aplikasi_berita/widgets/user_top_bar.dart';

class UserHome extends ConsumerStatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends ConsumerState<UserHome> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    DisplayArticles(),
    CategoriesPage(),
    SavedArticles(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(232, 251, 252, 255),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserTopBar(
                leadingIconButton: IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => ref.read(firebaseAuthProvider).signOut(),
                ),
                menuIconButton: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CategoriesPage()));
                  },
                ),
                bookmarkIconButton: IconButton(
                  icon: const Icon(Icons.bookmarks),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SavedArticles()));
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(child: _pages.elementAt(_selectedIndex)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmarks),
            label: 'Saved',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
