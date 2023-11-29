import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  
  final int currentIndex;
  final List<String> routes = ['/home/0','/home/1','/home/2'];

  CustomBottomNavigation({super.key, required this.currentIndex });
  void onItemTapped(BuildContext context , int index) {
    context.go(routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (value) {
        onItemTapped(context, value);
      },
      items: const  [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max),
          label: 'Inicio'
        ) , 
        BottomNavigationBarItem(
          icon: Icon(Icons.label_outlined),
          label: 'Categorias'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: 'Favoritos'
        )
      ]
    );
  }
}