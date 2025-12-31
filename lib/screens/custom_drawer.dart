import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/login_screen.dart';
import '../configs/app_config.dart';
import '../widgets/custom_drawer.dart';

class CustomDrawer extends StatefulWidget {
  final String userName;
  final String coachingName;

  const CustomDrawer({
    super.key, 
    required this.userName, 
    required this.coachingName
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // --- 1. PROFILE HEADER ---
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hi, ${widget.userName}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Text("View profile", style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),

          // --- 2. MENU ITEMS ---
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildItem(Icons.shopping_bag_outlined, "My Purchases", null),
                _buildItem(Icons.star_outline, "Join Beta Program", "New"),
                
                const Divider(indent: 20, endIndent: 20),

                _buildItem(Icons.dark_mode_outlined, "Dark Mode", null, 
                  trailing: Switch(
                    value: isDarkMode, 
                    activeColor: primaryColor,
                    onChanged: (v) => setState(() => isDarkMode = v)
                  )
                ),
                _buildItem(Icons.bookmark_outline, "Bookmarks", null),
                _buildItem(Icons.quiz_outlined, "Test Series", null),
                _buildItem(Icons.storefront_outlined, "${widget.coachingName} Store", null),
                _buildItem(Icons.school_outlined, "Online Degree", "New"),
                _buildItem(Icons.library_books_outlined, "Library", null),
                _buildItem(Icons.file_download_outlined, "My Downloads", null),

                const Divider(indent: 20, endIndent: 20),

                _buildItem(Icons.share_outlined, "Refer & Earn", null),
                _buildItem(Icons.info_outline, "About Us", null),
                _buildItem(Icons.headset_mic_outlined, "Contact Us", null),
                
                const SizedBox(height: 10),
                
                // LOGOUT BUTTON
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  onTap: () => _handleLogout(context),
                ),
              ],
            ),
          ),

          // --- 3. VISTER BRANDING ---
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const Text("From", style: TextStyle(color: Colors.grey, fontSize: 10)),
                Text("VISTER TECHNOLOGIES", 
                  style: TextStyle(
                    color: Colors.grey.shade400, 
                    fontSize: 12, 
                    fontWeight: FontWeight.bold, 
                    letterSpacing: 2
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget for Menu Items
  Widget _buildItem(IconData icon, String title, String? badge, {Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 24),
      title: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          if (badge != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(5)),
              child: Text(badge, style: const TextStyle(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.bold)),
            )
          ]
        ],
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      onTap: () {},
    );
  }

  void _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (c) => const LoginScreen(logoUrl: "")), 
      (route) => false
    );
  }
}