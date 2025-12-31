import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/batch_model.dart';
import 'video_player_screen.dart';
import 'pdf_view_screen.dart';

class AllClassesScreen extends StatefulWidget {
  final Batch batch; // जिस बैच की क्लासेज देखनी हैं
  const AllClassesScreen({super.key, required this.batch});

  @override
  State<AllClassesScreen> createState() => _AllClassesScreenState();
}

class _AllClassesScreenState extends State<AllClassesScreen> {
  int selectedSubjectIndex = 0;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.batch.title, style: const TextStyle(fontSize: 18)),
        elevation: 0,
      ),
      body: widget.batch.subjects.isEmpty
          ? const Center(child: Text("No subjects added in this batch yet."))
          : Column(
              children: [
                // 1. सब्जेक्ट्स की लिस्ट (Horizontal Chips)
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.batch.subjects.length,
                    itemBuilder: (context, index) {
                      bool isSelected = selectedSubjectIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => selectedSubjectIndex = index),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryColor : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.batch.subjects[index].subjectName,
                            style: TextStyle(
                              color: isSelected ? Colors.white : primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 2. चैप्टर्स और लेक्चर्स की लिस्ट (PW Style Hierarchy)
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.batch.subjects[selectedSubjectIndex].chapters.length,
                    itemBuilder: (context, index) {
                      var chapter = widget.batch.subjects[selectedSubjectIndex].chapters[index];
                      return ExpansionTile(
                        initiallyExpanded: true,
                        leading: Icon(Icons.folder_open, color: primaryColor),
                        title: Text(
                          chapter.chapterName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        children: chapter.contents.map((content) {
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            leading: Icon(
                              content.type == 'video' ? Icons.play_circle_fill : Icons.picture_as_pdf,
                              color: content.type == 'video' ? Colors.blue : Colors.red,
                              size: 35,
                            ),
                            title: Text(content.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            subtitle: Text(content.type == 'video' ? "Watch Lecture" : "View Notes", style: const TextStyle(fontSize: 12)),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                            onTap: () {
                              if (content.type == 'video') {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => VideoPlayerScreen(videoUrl: content.url, title: content.title)
                                ));
                              } else {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => PDFViewScreen(pdfUrl: content.url, title: content.title)
                                ));
                              }
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}