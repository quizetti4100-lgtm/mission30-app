import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'my_batches_screen.dart';
import 'test_list_screen.dart';
import 'ask_doubt_screen.dart';
import 'profile_screen.dart';
import 'notification_screen.dart';
import 'custom_drawer.dart'; 

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;
  String _userName = "Student";

  // --- यहाँ सुधार किया गया है: लिस्ट से 'const' हटा दिया गया है ---
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _loadUser();
    
    // पेजों की लिस्ट को यहाँ डिफाइन किया गया है
    _pages = [
      const HomeScreen(),      // Index 0
      const MyBatchesScreen(), // Index 1 (यही आपके अपलोड बैच दिखाएगा)
      const TestListScreen(),  // Index 2
      AskDoubtScreen(),        // Index 3 (Doubt Page - Non Const)
      const ProfileScreen(),   // Index 4
    ];
  }

  void _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? "Student";
    });
  }

  @override
  Widget build(BuildContext context) {
    // थीम से प्राइमरी कलर (नारंगी) उठाना
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      // १. साइडबार (Drawer)
      drawer: CustomDrawer(
        userName: _userName,
        coachingName: "Vister Technologies",
      ),

      // २. प्रोफेशनल AppBar
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          _currentIndex == 0 ? "Vister Study" : 
          _currentIndex == 1 ? "My Batches" :
          _currentIndex == 2 ? "Test Series" :
          _currentIndex == 3 ? "Doubt Room" : "My Profile",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      // ३. मुख्य कंटेंट (IndexedStack स्थिति याद रखता है)
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      // ४. नीचे के ५ बटन (Navigation Bar)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.text_snippet_outlined), label: "Study"),
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_outline), label: "Batches"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: "Test"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Doubt"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}