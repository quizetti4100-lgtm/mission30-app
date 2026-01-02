import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'test_list_screen.dart';
import 'my_downloads_screen.dart';
import 'contact_us_screen.dart';

class CustomDrawer extends StatelessWidget {
  final String userName;
  final String coachingName;

  const CustomDrawer({
    super.key, 
    required this.userName, 
    required this.coachingName
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
                ),
                const SizedBox(height: 10),
                Text("Hi, $userName", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text("View profile", style: TextStyle(color: Colors.blue, fontSize: 13)),
              ],
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildItem(Icons.shopping_bag_outlined, "My Purchases", () {}),
                const Divider(),
                _buildItem(Icons.quiz_outlined, "Test Series", () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const TestListScreen()));
                }),
                _buildItem(Icons.file_download_outlined, "My Downloads", () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const MyDownloadsScreen()));
                }),
                _buildItem(Icons.headset_mic_outlined, "Contact Us", () {
  Navigator.pop(context); // साइडबार बंद करें
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ContactUsScreen()), // यहाँ से 'const' हटा दिया गया है
  );
}),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    String logo = prefs.getString('logoUrl') ?? "";
                    await prefs.clear();
                    Navigator.pushAndRemoveUntil(
                      context, 
                      MaterialPageRoute(builder: (c) => LoginScreen(logoUrl: logo)), 
                      (route) => false
                    );
                  },
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text("VISTER TECHNOLOGIES", style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 2)),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: onTap,
    );
  }
}