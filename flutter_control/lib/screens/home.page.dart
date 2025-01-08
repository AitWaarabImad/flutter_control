import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Function to fetch user details from Firestore
  Future<Map<String, String>> getUserDetailsFromFirestore(User user) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        String userName = userData['username'] ?? user.displayName ?? 'No name';
        String userPhotoURL = userData['profileImageUrl'] ??
            user.photoURL ??
            'images/default_user.png';
        String userEmail = userData['email'] ?? user.email ?? 'No email';
        return {'name': userName, 'photoURL': userPhotoURL, 'email': userEmail};
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
    // Return default values in case of failure or missing data
    return {
      'name': user.displayName ?? 'Guest',
      'photoURL': user.photoURL ?? 'images/default_user.png',
      'email': user.email ?? 'No email'
    };
  }

  @override
  Widget build(BuildContext context) {
    // Get the current logged-in user from Firebase Auth
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // If no user is logged in, show login page
      return Scaffold(
        appBar: AppBar(
          title: Text('No User'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
          child: Text('Please login first.', style: TextStyle(fontSize: 18)),
        ),
      );
    }

    return FutureBuilder<Map<String, String>>(
      future: getUserDetailsFromFirestore(user), // Load user details
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while data is being fetched
          return Scaffold(
            appBar: AppBar(
              title: Text('Loading...'),
              backgroundColor: Colors.blueAccent,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          // Handle error in data fetching
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
              backgroundColor: Colors.redAccent,
            ),
            body: Center(child: Text('Error loading user data')),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          // Handle case where no data is available
          return Scaffold(
            appBar: AppBar(
              title: Text('Home Page'),
              backgroundColor: Colors.blueAccent,
            ),
            body: Center(child: Text('No user data available')),
          );
        }

        // Extract user details
        Map<String, String> userDetails = snapshot.data!;
        String userName = userDetails['name'] ?? 'No name';
        String userPhotoURL =
            userDetails['photoURL'] ?? 'images/default_user.png';
        String userEmail = userDetails['email'] ?? 'No email';

        return Scaffold(
          appBar: AppBar(
            title: Text('Home Page'),
            backgroundColor: Colors.blueAccent,
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blueAccent),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(userPhotoURL),
                        radius: 40,
                      ),
                      SizedBox(height: 10),
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        userEmail,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildDrawerItem(
                    context, Icons.home, 'Home', Colors.blue, () {}),
                _buildDrawerItem(context, Icons.track_changes, 'Covid Tracker',
                    Colors.yellow, () {}),
                _buildDrawerItem(
                    context, Icons.deck, 'Emsi Tracker', Colors.green, () {}),
                _buildDrawerItem(
                    context, Icons.person, 'Profile', Colors.purple, () {}),
                _buildDrawerItem(context, Icons.settings, 'Settings',
                    Colors.redAccent, () {}),
                _buildDrawerItem(
                    context, Icons.logout, 'Logout', Colors.lightBlue,
                    () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context); // Close the drawer
                }),
              ],
            ),
          ),
          body: Center(
            child: Text(
              'Welcome, $userName!',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            ),
          ),
        );
      },
    );
  }

  // Helper method to build drawer items
  Widget _buildDrawerItem(BuildContext context, IconData icon, String title,
      Color iconColor, Function() onTap) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      onTap: onTap,
    );
  }
}
