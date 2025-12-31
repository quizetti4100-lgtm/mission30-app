import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'pdf_view_screen.dart'; // इसे हमने पहले बनाया था

class StudyMaterialScreen extends StatelessWidget {
  const StudyMaterialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Study Material", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ApiService.fetchStudyMaterial(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text("No Study Material available."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final item = docs[index];
              return Card(
                elevation: 0,
                color: Colors.grey[50],
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(15),
  side: BorderSide(color: Colors.grey.shade200), // 'border' को 'side' से बदला गया
),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  ),
                  title: Text(item['title'] ?? "Lecture Notes", style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item['subject'] ?? "General", style: const TextStyle(fontSize: 12)),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_red_eye, color: primaryColor),
                    onPressed: () {
                      // PDF व्यूअर खोलें
                      Navigator.push(context, MaterialPageRoute(
                        builder: (c) => PDFViewScreen(pdfUrl: item['pdfUrl'], title: item['title'])
                      ));
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}