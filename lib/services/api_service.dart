import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../configs/app_config.dart';
import '../models/batch_model.dart';
import '../models/institute_model.dart';

class ApiService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. कोचिंग की ब्रांडिंग (Color/Name/Logo) लाना
  static Future<InstituteConfig?> fetchInstituteConfig() async {
    try {
      var doc = await _db.collection('institutes').doc(AppConfig.instituteId).get();
      if (doc.exists) {
        return InstituteConfig.fromJson(doc.data()!);
      }
    } catch (e) {
      print("❌ Firebase Config Error: $e");
    }
    return null;
  }

  // 2. लॉगिन फंक्शन (छात्र को रजिस्टर और सेशन सेव करना)
  static Future<bool> loginUser(String name, String phone) async {
    try {
      await _db.collection('users').doc(phone).set({
        'name': name,
        'phoneNumber': phone,
        'instituteId': AppConfig.instituteId,
        'joinedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userName', name);
      await prefs.setString('userPhone', phone);
      return true;
    } catch (e) {
      print("❌ Login Error: $e");
      return false;
    }
  }

  // 3. सभी उपलब्ध बैच लाना (Home Screen के लिए) - FIXED & SYNCED
  static Future<List<Batch>> fetchBatches() async {
    try {
      print("🚀 App is looking for Institute ID: ${AppConfig.instituteId}");
      
      var snapshot = await _db.collection('batches')
          .where('instituteId', isEqualTo: AppConfig.instituteId)
          .get();
      
      print("📊 Firebase found: ${snapshot.docs.length} batches");

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        // बहुत ज़रूरी: Firestore की Document ID को 'id' नाम के फील्ड में डालना
        data['id'] = doc.id; 
        return Batch.fromJson(data);
      }).toList();
    } catch (e) {
      print("❌ ERROR FETCHING BATCHES: $e");
      return [];
    }
  }

  // 4. बैच में एनरोल (Enroll) करने का फंक्शन
  static Future<bool> enrollInBatch(String batchId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? phone = prefs.getString('userPhone');
      if (phone == null) return false;

      await _db.collection('users').doc(phone).update({
        'enrolledBatches': FieldValue.arrayUnion([batchId])
      });
      return true;
    } catch (e) {
      print("❌ Enroll Error: $e");
      return false;
    }
  }

  // 5. सिर्फ छात्र के खरीदे हुए बैच लाना (My Batches Tab के लिए)
  static Future<List<Batch>> fetchMyBatches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? phone = prefs.getString('userPhone');
      if (phone == null) return [];

      var userDoc = await _db.collection('users').doc(phone).get();
      if (!userDoc.exists) return [];

      List enrolledIds = userDoc.data()?['enrolledBatches'] ?? [];
      if (enrolledIds.isEmpty) return [];

      // उन IDs के बैच लाना
      var snapshot = await _db.collection('batches')
          .where(FieldPath.documentId, whereIn: enrolledIds)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        return Batch.fromJson(data);
      }).toList();
    } catch (e) {
      print("❌ My Batches Error: $e");
      return [];
    }
  }

  // 6. टेस्ट सीरीज की लिस्ट लाना
  static Future<List<Map<String, dynamic>>> fetchTests() async {
    try {
      var snap = await _db.collection('tests')
          .where('instituteId', isEqualTo: AppConfig.instituteId)
          .get();
      return snap.docs.map((d) => {...d.data(), 'id': d.id}).toList();
    } catch (e) {
      print("❌ Fetch Tests Error: $e");
      return [];
    }
  }

  // 7. स्टडी मटेरियल लाना
  static Future<List<Map<String, dynamic>>> fetchStudyMaterial() async {
    try {
      var snap = await _db.collection('study_material')
          .where('instituteId', isEqualTo: AppConfig.instituteId)
          .get();
      return snap.docs.map((d) => {...d.data(), 'id': d.id}).toList();
    } catch (e) {
      print("❌ Fetch Material Error: $e");
      return [];
    }
  }

  // 8. खजाना (Premium Content) लाना
  static Future<List<Map<String, dynamic>>> fetchKhazana() async {
    try {
      var snap = await _db.collection('khazana')
          .where('instituteId', isEqualTo: AppConfig.instituteId)
          .get();
      return snap.docs.map((d) => {...d.data(), 'id': d.id}).toList();
    } catch (e) {
      print("❌ Fetch Khazana Error: $e");
      return [];
    }
  }
} // क्लास यहाँ खत्म