import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  // एरर फिक्स: यहाँ से 'const' हटा दिया गया है ताकि डायनामिक थीम काम कर सके
  ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Help & Support", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- प्रीमियम हेडर सेक्शन ---
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.headset_mic, size: 50, color: primaryColor),
                  ),
                  const SizedBox(height: 15),
                  const Text("How can we help you?", 
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text("We are available 10 AM - 7 PM", 
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- कांटेक्ट कार्ड्स ---
            _buildContactCard(context, Icons.phone_in_talk, "Call Us", "+91 9876543210", Colors.blue),
            _buildContactCard(context, Icons.chat_bubble_outline, "WhatsApp", "Chat with Support", Colors.green),
            _buildContactCard(context, Icons.email_outlined, "Email Us", "support@vister.com", Colors.red),

            const SizedBox(height: 40),
            
            // --- सोशल मीडिया सेक्शन ---
            const Text("Follow us for updates", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialIcon(Icons.facebook, Colors.blue),
                const SizedBox(width: 20),
                _socialIcon(Icons.camera_alt, Colors.pink),
                const SizedBox(width: 20),
                _socialIcon(Icons.play_arrow, Colors.red),
              ],
            ),

            const SizedBox(height: 50),
            const Text("From", style: TextStyle(color: Colors.grey, fontSize: 10)),
            const Text("VISTER TECHNOLOGIES", 
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 2)),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, IconData icon, String title, String sub, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(sub),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          onTap: () {},
        ),
      ),
    );
  }

  Widget _socialIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 24),
    );
  }
}