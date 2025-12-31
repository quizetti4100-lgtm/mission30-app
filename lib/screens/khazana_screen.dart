import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'video_player_screen.dart';

class KhazanaScreen extends StatelessWidget {
  const KhazanaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Khazana", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ApiService.fetchKhazana(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) return const Center(child: Text("Khazana is empty for now."));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final khazana = data[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [primaryColor.withOpacity(0.8), primaryColor]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(20),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(Icons.star, color: Colors.orange, size: 30),
                  ),
                  title: Text(khazana['title'], 
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(khazana['description'] ?? "Best Lectures from Top Faculty", 
                    style: const TextStyle(color: Colors.white70)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                  onTap: () {
                     // यहाँ आप सिलेबस की तरह ही वीडियो लिस्ट दिखा सकते हैं
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Loading Premium Content...")));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}