// ignore: file_names
import 'package:flutter/material.dart';

class Mydrawer extends StatelessWidget{

  const Mydrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          buildListTile(
            'Favourites',
            Icons.favorite,
            () => {},
          ),
        ],
      ),
    );
  }

  Widget buildListTile(String title, IconData icon, Function tap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {},
    );
  }
}

