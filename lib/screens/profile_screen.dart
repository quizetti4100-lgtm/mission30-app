import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "Loading...";
  String phone = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('userName') ?? "Student";
      phone = prefs.getString('userPhone') ?? "No Number";
    });
  }

  // --- लॉगआउट फंक्शन (फिक्स किया गया) ---
  void _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    // लोगो यूआरएल को डिलीट करने से पहले कॉपी कर लें
    String savedLogo = prefs.getString('logoUrl') ?? "";
    
    await prefs.clear(); // सब साफ़ करें
    
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen(logoUrl: savedLogo)), // यहाँ लोगो पास करें
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile"), elevation: 0),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const Center(child: CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50))),
          const SizedBox(height: 20),
          Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text("+91 $phone", style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 30),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () => _handleLogout(context),
          ),
        ],
      ),
    );
  }
}