import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({
    required this.navigationShell,
    Key? key,
    }) : super(key: key ?? const ValueKey<String>('AppLayout'));

    final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: navigationShell.goBranch,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Konsumen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}