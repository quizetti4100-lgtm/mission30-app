import 'package:flutter/material.dart';
import '../models/batch_model.dart';
import 'video_player_screen.dart';

class BatchDetailScreen extends StatelessWidget {
  final Batch batch;
  const BatchDetailScreen({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(batch.title),
          bottom: const TabBar(
            tabs: [
              Tab(text: "INFO"),
              Tab(text: "LECTURES"),
              Tab(text: "NOTES"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 1. INFO TAB
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(batch.description, style: const TextStyle(fontSize: 16)),
            ),
            
            // 2. LECTURES TAB (Hierarchical View)
            batch.subjects.isEmpty 
              ? const Center(child: Text("No content available"))
              : ListView.builder(
                  itemCount: batch.subjects.length,
                  itemBuilder: (context, sIdx) {
                    var subject = batch.subjects[sIdx];
                    return ExpansionTile(
                      initiallyExpanded: true,
                      title: Text(subject.subjectName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      children: subject.chapters.map((chapter) {
                        return Column(
                          children: chapter.contents.map((content) {
                            return ListTile(
                              leading: const Icon(Icons.play_circle_fill, color: Colors.blue),
                              title: Text(content.title),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => VideoPlayerScreen(videoUrl: content.url, title: content.title)
                                ));
                              },
                            );
                          }).toList(),
                        );
                      }).toList(),
                    );
                  },
                ),

            // 3. NOTES TAB
            const Center(child: Text("Notes will appear here")),
          ],
        ),
      ),
    );
  }
}