import 'package:flutter/material.dart';
import 'login_screen.dart';

// Custom ListTile widget
class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const CustomListTile({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: 4),  // Make the tile taller
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}

// SettingsPage using CustomListTile
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
                CustomListTile(
                  icon: Icons.language,
                  title: 'Language',
                  onTap: () {
                    // Navigate to Language settings
                  },
                ),
                CustomListTile(
                  icon: Icons.notifications,
                  title: 'Notification',
                  onTap: () {
                    // Navigate to Notification settings
                  },
                ),
                CustomListTile(
                  icon: Icons.info,
                  title: 'About',
                  onTap: () {

                  },
                ),
                CustomListTile(
                  icon: Icons.help,
                  title: 'Help',
                  onTap: () {

                  },
                ),
                CustomListTile(
                  icon: Icons.account_box,
                  title: 'Manage Your account',
                  onTap: () {

                  },
                ),
                CustomListTile(
                  icon: Icons.contact_emergency,
                  title: 'Emergency',
                  onTap: () {
                    // Navigate to Emergency settings
                  },
                ),
                CustomListTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
                  },
                ),
                CustomListTile(
                  icon: Icons.switch_access_shortcut,
                  title: 'Switch Accounts',
                  onTap: () {
                    // Navigate to Switch Accounts
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}