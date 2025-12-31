import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'result_screen.dart'; // रिजल्ट स्क्रीन को जोड़ना ज़रूरी है

class QuizScreen extends StatefulWidget {
  final Map<String, dynamic> testData;
  const QuizScreen({super.key, required this.testData});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  Map<int, int> selectedAnswers = {};
  late Timer _timer;
  int _remainingTime = 0;

  @override
  void initState() {
    super.initState();
    // टाइमर सेट करना
    _remainingTime = (widget.testData['duration'] ?? 30) * 60;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        submitQuiz(); // टाइम खत्म होने पर अपने आप सबमिट
      }
    });
  }

  // --- सबमिट फंक्शन (पूरी तरह सही किया गया) ---
  void submitQuiz() async {
    _timer.cancel(); // टाइमर रोकें
    
    int finalScore = 0;
    List questions = widget.testData['questions'] ?? [];

    // 1. स्कोर कैलकुलेट करें
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i]['ans']) {
        finalScore++;
      }
    }

    // 2. Firebase में रिजल्ट सेव करें
    try {
      final prefs = await SharedPreferences.getInstance();
      String? phone = prefs.getString('userPhone');
      String? name = prefs.getString('userName');

      await FirebaseFirestore.instance.collection('test_results').add({
        'studentPhone': phone,
        'studentName': name,
        'testId': widget.testData['id'],
        'testTitle': widget.testData['title'],
        'score': finalScore,
        'total': questions.length,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Error saving result: $e");
    }

    if (!mounted) return;

    // 3. सीधे रिजल्ट स्क्रीन पर ले जाएं (डायलॉग हटा दिया गया है PW स्टाइल के लिए)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          score: finalScore,
          total: questions.length,
          testTitle: widget.testData['title'] ?? "Test Result",
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List questions = widget.testData['questions'] ?? [];
    if (questions.isEmpty) return const Scaffold(body: Center(child: Text("No Questions")));
    
    var q = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.testData['title'] ?? "Quiz"),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                "${(_remainingTime ~/ 60)}:${(_remainingTime % 60).toString().padLeft(2, '0')}",
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Question ${currentQuestionIndex + 1}/${questions.length}", 
                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Text(q['q'] ?? "", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            // ऑप्शंस की लिस्ट
            ...List.generate(4, (index) => Card(
              elevation: 2,
              color: selectedAnswers[currentQuestionIndex] == index ? Colors.orange.shade100 : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: selectedAnswers[currentQuestionIndex] == index ? Colors.orange : Colors.grey.shade200,
                  child: Text(String.fromCharCode(65 + index), style: TextStyle(color: selectedAnswers[currentQuestionIndex] == index ? Colors.white : Colors.black)),
                ),
                title: Text(q['options'][index]),
                onTap: () => setState(() => selectedAnswers[currentQuestionIndex] = index),
              ),
            )),
            const Spacer(),
            // नेविगेशन बटन्स
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentQuestionIndex > 0)
                  OutlinedButton(
                    onPressed: () => setState(() => currentQuestionIndex--), 
                    child: const Text("PREV")
                  ),
                const Spacer(),
                if (currentQuestionIndex < questions.length - 1)
                  ElevatedButton(
                    onPressed: () => setState(() => currentQuestionIndex++), 
                    child: const Text("NEXT")
                  )
                else
                  ElevatedButton(
                    onPressed: submitQuiz, 
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("SUBMIT TEST", style: TextStyle(color: Colors.white)),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}