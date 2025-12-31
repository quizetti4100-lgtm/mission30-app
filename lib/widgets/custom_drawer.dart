import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// पाथ चेक करें - सभी इम्पोर्ट्स यहाँ हैं
import '../screens/login_screen.dart';
import '../screens/test_list_screen.dart';
import '../screens/my_downloads_screen.dart';
import '../screens/study_material_screen.dart';
import '../screens/contact_us_screen.dart'; // <--- यह नया इम्पोर्ट जोड़ा गया है

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
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blueGrey,
                  backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hi, ${widget.userName}", 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const Text("View profile", 
                      style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w600)),
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
                _buildItem(Icons.shopping_bag_outlined, "My Purchases", null, onTap: () {}),
                _buildItem(Icons.star_outline, "Join Beta Program", "New", onTap: () {}),
                
                const Divider(indent: 20, endIndent: 20),

                // Dark Mode Switch
                _buildItem(Icons.dark_mode_outlined, "Dark Mode", null, 
                  trailing: Switch(
                    value: isDarkMode, 
                    activeColor: primaryColor,
                    onChanged: (v) => setState(() => isDarkMode = v)
                  )
                ),
                
                _buildItem(Icons.bookmark_outline, "Bookmarks", null, onTap: () {}),
                
                _buildItem(Icons.quiz_outlined, "Test Series", null, onTap: () {
                  Navigator.pop(context); // ड्रावर बंद करें
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const TestListScreen()));
                }),

                _buildItem(Icons.storefront_outlined, "${widget.coachingName} Store", null, onTap: () {}),
                _buildItem(Icons.school_outlined, "Online Degree", "New", onTap: () {}),
                
                _buildItem(Icons.library_books_outlined, "Library", null, onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const StudyMaterialScreen()));
                }),
                
                _buildItem(Icons.file_download_outlined, "My Downloads", null, onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const MyDownloadsScreen()));
                }),

                const Divider(indent: 20, endIndent: 20),

                _buildItem(Icons.share_outlined, "Refer & Earn", null, onTap: () {}),
                _buildItem(Icons.info_outline, "About Us", null, onTap: () {}),
                
                // --- यहाँ सुधार किया गया है: Contact Us को लिंक किया गया ---
                _buildItem(Icons.headset_mic_outlined, "Contact Us", null, onTap: () {
                  Navigator.pop(context); // पहले ड्रावर बंद करें
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (c) => const ContactUsScreen())
                  );
                }),
                
                // Logout
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  onTap: () => _handleLogout(context),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // --- 3. VISTER BRANDING ---
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            color: Colors.grey.shade50,
            child: Column(
              children: [
                const Text("From", style: TextStyle(color: Colors.grey, fontSize: 10)),
                const Text("VISTER TECHNOLOGIES", 
                  style: TextStyle(color: Colors.black45, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 2)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, String? badge, {Widget? trailing, Function()? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 24),
      title: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
          if (badge != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(5)),
              child: Text(badge, style: const TextStyle(fontSize: 9, color: Colors.orange, fontWeight: FontWeight.bold)),
            )
          ]
        ],
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? logo = prefs.getString('logoUrl'); 
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (c) => LoginScreen(logoUrl: logo ?? "")), 
      (route) => false
    );
  }
}