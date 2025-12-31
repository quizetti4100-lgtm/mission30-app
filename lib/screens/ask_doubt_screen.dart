import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../configs/app_config.dart';

class AskDoubtScreen extends StatefulWidget {
  const AskDoubtScreen({super.key});

  @override
  State<AskDoubtScreen> createState() => _AskDoubtScreenState();
}

class _AskDoubtScreenState extends State<AskDoubtScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;

  void _sendDoubt() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() => _isSending = true);

    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('userName') ?? "Student";
    String phone = prefs.getString('userPhone') ?? "No Number";

    try {
      await FirebaseFirestore.instance.collection('doubts').add({
        'instituteId': AppConfig.instituteId,
        'studentName': name,
        'studentPhone': phone,
        'question': _controller.text.trim(),
        'answer': '', // टीचर यहाँ जवाब भरेगा
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      _controller.clear();
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Doubt sent to Expert! ✅")));
    } catch (e) {
      print(e);
    }
    setState(() => _isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Doubt Room"), elevation: 0),
      body: Column(
        children: [
          // 1. सवाल पूछने का सेक्शन
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Type your doubt here...",
                      border: InputBorder.none,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _isSending ? null : _sendDoubt,
                      icon: _isSending ? const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send),
                      label: const Text("ASK NOW"),
                      style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: const StadiumBorder()),
                    ),
                  )
                ],
              ),
            ),
          ),

          const Divider(),

          // 2. पुराने डाउट्स और जवाबों की लिस्ट (Real-time from Firebase)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('doubts')
                  .where('instituteId', isEqualTo: AppConfig.instituteId)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) return const Center(child: Text("No doubts asked yet."));

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var data = docs[index].data() as Map<String, dynamic>;
                    bool isResolved = data['status'] == 'resolved';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Q: ${data['question']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            if (isResolved) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(10)),
                                child: Text("A: ${data['answer']}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
                              ),
                            ] else ...[
                              const SizedBox(height: 10),
                              const Text("Status: Waiting for Expert...", style: TextStyle(color: Colors.orange, fontSize: 12, fontStyle: FontStyle.italic)),
                            ]
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}