import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // kIsWeb के लिए
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'configs/app_config.dart';
import 'services/api_service.dart';
import 'models/institute_model.dart';
import 'screens/login_screen.dart';
import 'screens/main_wrapper.dart';

void main() async {
  // 1. सुनिश्चित करें कि Flutter पूरी तरह तैयार है
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. वेब और मोबाइल दोनों के लिए Firebase सेटअप
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyADqPv28bFaX5mpi4M6YAg-gzVkf77igMk",
        authDomain: "pw-saas-app.firebaseapp.com",
        projectId: "pw-saas-app",
        storageBucket: "pw-saas-app.firebasestorage.app",
        messagingSenderId: "298347320838",
        appId: "1:298347320838:web:340029986a307239d5d587",
      ),
    );
  } else {
    // मोबाइल के लिए यह खुद-ब-खुद google-services.json उठा लेगा
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String logoUrl = "";
  Color primaryColor = const Color(0xFFFF5722); // डिफ़ॉल्ट नारंगी (Vister Color)
  bool isLoading = true;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  // --- ऐप की पूरी सेटिंग और ब्रांडिंग यहाँ लोड होगी ---
  void initializeApp() async {
    try {
      // १. सबसे पहले Firebase से 'mission30' (या Config ID) की डिटेल्स लाओ
      final config = await ApiService.fetchInstituteConfig();
      
      if (config != null) {
        // लोगो और कलर सेट करना
        logoUrl = config.logo; 
        String hex = config.primaryColor.replaceFirst('#', '0xFF');
        primaryColor = Color(int.parse(hex));
      }

      // २. चेक करना कि छात्र पहले से लॉगिन है या नहीं
      final prefs = await SharedPreferences.getInstance();
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    } catch (e) {
      debugPrint("Startup Error: $e");
    } finally {
      // डेटा लोड होने के बाद लोडिंग बंद करें
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // जब तक डेटा लोड हो रहा है, स्पलैश लोडर दिखाएं
    if (isLoading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vister Technologies',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      // --- अगर लॉगिन है तो डैशबोर्ड (5 बटन), नहीं तो लॉगिन स्क्रीन (लोगो के साथ) ---
      home: isLoggedIn 
          ? const MainWrapper() 
          : LoginScreen(logoUrl: logoUrl),
    );
  }
}