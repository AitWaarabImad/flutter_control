import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home page',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Colors.amber,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.red),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('images/avatar.jpg'),
                    radius: 20,
                  ),
                  Text(
                    'Imad ait waarab',
                    style: TextStyle(fontSize: 35, color: Colors.white),
                  ),
                  Text(
                    'Imad@gmail.com',
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  )
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.yellow,
              ),
              title: Text('Covid tracker'),
              onTap: () => {Navigator.pop(context)},
            ),
            ListTile(
              leading: Icon(
                Icons.deck,
                color: Colors.green,
              ),
              title: Text('Emsi tracker'),
              onTap: () => {Navigator.pop(context)},
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.purple,
              ),
              title: Text('Profile'),
              onTap: () => {Navigator.pop(context)},
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.redAccent,
              ),
              title: Text('Parametres'),
              onTap: () => {Navigator.pop(context)},
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.lightBlue,
              ),
              title: Text('Logout'),
              onTap: () => {Navigator.pop(context)},
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          textAlign: TextAlign.center,
          "Welcome to the home page",
          style: TextStyle(color: Colors.black26, fontSize: 20),
        ),
      ),
    );
  }
}
