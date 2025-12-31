import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Help & Support", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Top Decorative Image/Icon
            Container(
              height: 200,
              width: double.infinity,
              color: primaryColor.withOpacity(0.1),
              child: Icon(Icons.headset_mic, size: 100, color: primaryColor),
            ),

            const SizedBox(height: 30),
            const Text("How can we help you?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Text(
                "Our team is available 10 AM to 7 PM to assist you with your queries.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 30),

            // 2. Contact Options Cards
            _contactCard(
              context,
              Icons.phone_in_talk,
              "Call Us",
              "+91 9199614867",
              () {
                // यहाँ कॉल करने का लॉजिक आएगा
              },
            ),
            _contactCard(
              context,
              Icons.chat_bubble_outline,
              "WhatsApp Support",
              "9199614867",
              () {
                // यहाँ व्हाट्सएप ओपन करने का लॉजिक आएगा
              },
            ),
            _contactCard(
              context,
              Icons.email_outlined,
              "Email Us",
              "mission30patna@gmail.com",
              () {
                // यहाँ ईमेल का लॉजिक आएगा
              },
            ),

            const SizedBox(height: 40),
            const Text("Follow us on", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            
            // 3. Social Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialIcon("https://cdn-icons-png.flaticon.com/512/1384/1384060.png"), // Youtube
                _socialIcon("https://cdn-icons-png.flaticon.com/512/2111/2111463.png"), // Instagram
                _socialIcon("https://cdn-icons-png.flaticon.com/512/733/733547.png"),   // Facebook
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _contactCard(BuildContext context, IconData icon, String title, String subtitle, Function() onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
          color: Colors.grey[50],
          child: ListTile(
            leading: Icon(icon, color: Theme.of(context).primaryColor),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(subtitle),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _socialIcon(String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Image.network(url, height: 30, width: 30),
    );
  }
}