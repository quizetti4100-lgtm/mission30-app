import 'package:flutter/material.dart';

class MyDownloadsScreen extends StatefulWidget {
  const MyDownloadsScreen({super.key});

  @override
  State<MyDownloadsScreen> createState() => _MyDownloadsScreenState();
}

class _MyDownloadsScreenState extends State<MyDownloadsScreen> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            "My Downloads", 
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
          ),
          bottom: TabBar(
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColor,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: "VIDEOS"),
              Tab(text: "DOCUMENTS"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // टैब 1: डाउनलोड किए हुए वीडियो
            _DownloadList(type: "video"),
            // टैब 2: डाउनलोड किए हुए PDF
            _DownloadList(type: "pdf"),
          ],
        ),
      ),
    );
  }
}

class _DownloadList extends StatelessWidget {
  final String type;
  const _DownloadList({required this.type});

  @override
  Widget build(BuildContext context) {
    // ब्राउज़र (Chrome) में फाइल सेव नहीं होती, इसलिए हम यहाँ एम्प्टी स्टेट दिखा रहे हैं।
    // असली मोबाइल ऐप (APK) में यहाँ डाउनलोड की हुई फाइलों की लिस्ट आएगी।
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type == "video" ? Icons.video_library_outlined : Icons.picture_as_pdf_outlined,
              size: 100,
              color: Colors.grey[200],
            ),
            const SizedBox(height: 20),
            Text(
              "No ${type == 'video' ? 'Videos' : 'Documents'} Found",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              "Content you download for offline use will be shown here.",
              textAlign: TextAlign.center, // यहाँ गलती थी, अब ठीक कर दी गई है
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // वापस होम पर जाने के लिए
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                elevation: 0,
              ),
              child: const Text("EXPLORE BATCHES", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}