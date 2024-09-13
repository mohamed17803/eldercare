import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // Profile section
          const ListTile(
            visualDensity: VisualDensity(vertical: 4),  // Make the tile taller
            leading: CircleAvatar(
              backgroundImage: AssetImage('images/elderly.png'), // Add your own profile image
            ),
            title: Text('Jiya Malik'),
          ),


          // Settings options
          Expanded(
            child: ListView(
              children: [

                ListTile(
                  visualDensity: VisualDensity(vertical: 4),  // Make the tile taller
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to Language settings
                  },
                ),

                ListTile(
                  visualDensity: VisualDensity(vertical: 4),  // Make the tile taller
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notification'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to Notification settings
                  },
                ),

                ListTile(
                  visualDensity: VisualDensity(vertical: 4),  // Make the tile taller
                  leading: const Icon(Icons.info),
                  title: const Text('About'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to About section
                  },
                ),

                ListTile(
                  visualDensity: VisualDensity(vertical: 4),  // Make the tile taller
                  leading: const Icon(Icons.help),
                  title: const Text('Help'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to Help section
                  },
                ),

                ListTile(
                  visualDensity: VisualDensity(vertical: 4),
                  leading: const Icon(Icons.account_box),
                  title: const Text('Mange Your account'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to Help section
                  },
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: 4),  // Make the tile taller
                  leading: const Icon(Icons.contact_emergency),
                  title: const Text('Emergency'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to Help section
                  },
                ),

                ListTile(
                  visualDensity: VisualDensity(vertical: 4),  // Make the tile taller
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to Help section
                  },
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: 4),  // Make the tile taller
                  leading: const Icon(Icons.switch_access_shortcut),
                  title: const Text('Switch Accounts'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to Help section
                  },
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: 4),  // Make the tile taller
                  leading: const Icon(Icons.share),
                  title: const Text('Share Profile'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to Help section
                  },
                ),
              ],
            ),
          ),

          // Contact Us button
          Container(
            color: Colors.purple,
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                // Handle Contact Us button action
              },
              child: const Text(
                'Contact Us , We Ready To Help You',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        items: const [

          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add medication'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'Medications'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}