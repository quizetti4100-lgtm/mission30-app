import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final String testTitle;

  const ResultScreen({
    super.key, 
    required this.score, 
    required this.total, 
    required this.testTitle
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    double percentage = (score / total) * 100;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Test Result"), elevation: 0),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const Text("Your Score", style: TextStyle(color: Colors.white70, fontSize: 18)),
                const SizedBox(height: 10),
                Text("$score / $total", 
                  style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text("${percentage.toStringAsFixed(1)}% Accuracy", 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Result Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem("Correct", score, Colors.green),
                _statItem("Wrong", total - score, Colors.red),
                _statItem("Total", total, Colors.blue),
              ],
            ),
          ),

          const Spacer(),
          
          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("GO TO HOME", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          
          const Text("Powered by VISTER TECHNOLOGIES", style: TextStyle(color: Colors.grey, fontSize: 10)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _statItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text("$value", style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }
}