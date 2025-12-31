import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../configs/app_config.dart';
import 'package:intl/intl.dart'; // समय को सुंदर दिखाने के लिए

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Notice Board", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('instituteId', isEqualTo: AppConfig.instituteId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // १. एरर हैंडलिंग
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // २. लोडिंग स्टेट
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ३. डेटा चेक
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 10),
                  const Text("No new announcements", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              String type = data['type'] ?? 'notice'; 
              
              // टाइप के हिसाब से रंग और आइकन
              IconData icon;
              Color iconColor;
              if (type == 'holiday') {
                icon = Icons.beach_access;
                iconColor = Colors.red;
              } else if (type == 'live') {
                icon = Icons.videocam;
                iconColor = Colors.green;
              } else {
                icon = Icons.campaign;
                iconColor = Colors.orange;
              }

              // --- यहाँ पिछला ब्रैकेट एरर फिक्स किया गया है ---
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02), 
                      blurRadius: 10, 
                      offset: const Offset(0, 5)
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1), 
                      shape: BoxShape.circle
                    ),
                    child: Icon(icon, color: iconColor),
                  ),
                  title: Text(
                    data['title'] ?? "Important Update", 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        data['message'] ?? "", 
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 14)
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 12, color: Colors.grey),
                          const SizedBox(width: 5),
                          Text(
                            data['createdAt'] != null 
                              ? DateFormat('dd MMM, hh:mm a').format((data['createdAt'] as Timestamp).toDate())
                              : "Just now",
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ); // Container End
            }, // ItemBuilder End
          ); // ListView End
        }, // StreamBuilder Builder End
      ), // StreamBuilder End
    ); // Scaffold End
  }
}