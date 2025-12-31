import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'quiz_screen.dart'; // <--- यह इम्पोर्ट जोड़ें

// बाकी कोड पहले जैसा ही रहेगा, बस पक्का करें कि QuizScreen(testData: test) पास हो रहा है।
class TestListScreen extends StatelessWidget {
  const TestListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All India Test Series")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ApiService.fetchTests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final tests = snapshot.data ?? [];
          if (tests.isEmpty) return const Center(child: Text("No Tests Assigned Yet"));

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: tests.length,
            itemBuilder: (context, index) {
              final test = tests[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.only(bottom: 15),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  leading: const CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.assignment, color: Colors.white)),
                  title: Text(test['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${test['duration']} Mins | ${test['questions'].length} MCQs"),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, shape: const StadiumBorder()),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => QuizScreen(testData: test)));
                    },
                    child: const Text("START TEST", style: TextStyle(color: Colors.white, fontSize: 12)),
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